`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 09/16/2025
// Design Name: 
// Module Name: rgmii_idelay3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
///
// EDUCATIONAL USE ONLY
//
// This source file is provided solely for educational, research, and non-commercial purposes.
//
// Commercial use, redistribution, sublicensing, modification for commercial products,
// or incorporation into proprietary software or hardware is strictly prohibited without prior
// written permission and a valid commercial license from the original creator.
//
// Unauthorized commercial use violates intellectual property and copyright laws.
//
// For licensing inquiries and commercial permissions, contact the creator directly.
//
//////////////////////////////////////////////////////////////////////////////////
module rgmii_idelay3 #(
    parameter DATA_0_DELAY              = 0,
    parameter DATA_1_DELAY              = 0,
    parameter DATA_2_DELAY              = 0,
    parameter DATA_3_DELAY              = 0,
    parameter DATA_CONTROL_DELAY        = 0,
    parameter FORMAT                    = "COUNT",
    parameter SIM_DEVICE                = "ULTRASCALE_PLUS",
    parameter REFCLK_FREQUENCY          = 300.0,
    parameter IDELAYCTRL_ENABLE         = 1,
    parameter CASCADE_ENABLE            = 0,
    parameter IDELAYCTRL_RELEASE_CYCLES = 16,
    parameter RDY_WAIT_CYCLES           = 64
)(
    input   wire                            clock,
    input   wire                            reset_n,
    input   wire                            pre_delay_data_control,
    input   wire [3:0]                      pre_delay_data,

    output   wire                           post_delay_data_control,
    output   wire [3:0]                     post_delay_data,
    output   wire                           ready
);

localparam CALIBRATION_ACTIVE = (FORMAT == "TIME") ? 1'b1 : 1'b0;

wire idelayctrl_reset;
wire idelayctlr_reference_clock;

wire idelayctrl_ready;

generate
    if (FORMAT == "TIME" && IDELAYCTRL_ENABLE) begin
        IDELAYCTRL #(
            .SIM_DEVICE     ("ULTRASCALE")
        ) IDELAYCTRL(
            .RST    (idelayctrl_reset),
            .REFCLK (idelayctlr_reference_clock),
            
            .RDY    (idelayctrl_ready)
        );
    end
    else begin
        assign idelayctrl_ready = 1'b1;
    end
endgenerate



function automatic integer lane_delay(input integer lane);
    case (lane)
        0:          lane_delay = DATA_0_DELAY;
        1:          lane_delay = DATA_1_DELAY;
        2:          lane_delay = DATA_2_DELAY;
        3:          lane_delay = DATA_3_DELAY;
        default:    lane_delay = DATA_CONTROL_DELAY;
    endcase
endfunction

wire [4:0]  pre_delay_lanes;
wire [4:0]  post_delay_lanes;

genvar i;

generate
    for (i = 0; i < 5; i = i + 1) begin : lane
        localparam integer TOTAL_DELAY  = lane_delay(i);
        //a cascaded IDELAYE3/ODELAYE3 pair in FIXED TIME mode shares a bitslice and must use the
        //same DELAY_VALUE (DRC PDRC-184), so the total is split evenly between the two
        localparam integer IDELAY_VALUE = (CASCADE_ENABLE) ? ((TOTAL_DELAY + 1) / 2) : TOTAL_DELAY;
        localparam integer ODELAY_VALUE = IDELAY_VALUE;

        wire cascade_out;
        wire cascade_return;

        IDELAYE3 #(
            .CASCADE            (CASCADE_ENABLE ? "MASTER" : "NONE"),
            .DELAY_FORMAT       (FORMAT),
            .DELAY_TYPE         ("FIXED"),
            .DELAY_VALUE        (IDELAY_VALUE),
            .SIM_DEVICE         (SIM_DEVICE),
            .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
        ) idelay (
            .IDATAIN        (pre_delay_lanes[i]),
            .DATAIN         (1'b0),
            .DATAOUT        (post_delay_lanes[i]),
            .CASC_IN        (1'b0),
            .CASC_OUT       (cascade_out),
            .CASC_RETURN    (cascade_return),
            .CNTVALUEIN     (9'd0),
            .CNTVALUEOUT    (),
            .CE             (1'b0),
            .INC            (1'b0),
            .LOAD           (1'b0),
            .CLK            (clock),
            .RST            (!reset_n),
            .EN_VTC         (CALIBRATION_ACTIVE)
        );

        if (CASCADE_ENABLE) begin : cascade
            ODELAYE3 #(
                .CASCADE            ("SLAVE_END"),
                .DELAY_FORMAT       (FORMAT),
                .DELAY_TYPE         ("FIXED"),
                .DELAY_VALUE        (ODELAY_VALUE),
                .SIM_DEVICE         (SIM_DEVICE),
                .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
            ) odelay (
                .ODATAIN        (1'b0),
                .DATAOUT        (cascade_return),
                .CASC_IN        (cascade_out),
                .CASC_OUT       (),
                .CASC_RETURN    (1'b0),
                .CNTVALUEIN     (9'd0),
                .CNTVALUEOUT    (),
                .CE             (1'b0),
                .INC            (1'b0),
                .LOAD           (1'b0),
                .CLK            (clock),
                .RST            (!reset_n),
                .EN_VTC         (CALIBRATION_ACTIVE)
            );
        end
        else begin
            assign cascade_return = 1'b0;
        end
    end
endgenerate


localparam COUNTER_MAX    = (IDELAYCTRL_RELEASE_CYCLES > RDY_WAIT_CYCLES) ? IDELAYCTRL_RELEASE_CYCLES : RDY_WAIT_CYCLES;
localparam COUNTER_WIDTH  = $clog2(COUNTER_MAX + 1);

typedef enum
{
    S_HOLD_CONTROLLER_RESET,
    S_WAIT_READY,
    S_SETTLE,
    S_CALIBRATED
} state_type;

state_type                  _state;
state_type                  state;
logic   [COUNTER_WIDTH-1:0] _counter;
reg     [COUNTER_WIDTH-1:0] counter;
logic                       _idelayctrl_reset_hold;
reg                         idelayctrl_reset_hold;
logic                       _calibration_done;
reg                         calibration_done;

always_comb begin
    _state                  = state;
    _counter                = counter;
    _idelayctrl_reset_hold  = idelayctrl_reset_hold;
    _calibration_done       = calibration_done;

    case (state)
        S_HOLD_CONTROLLER_RESET: begin
            _idelayctrl_reset_hold  = 1;
            _calibration_done       = 0;
            _counter                = counter + 1;

            if (counter == IDELAYCTRL_RELEASE_CYCLES - 1) begin
                _counter                = 0;
                _idelayctrl_reset_hold  = 0;
                _state                  = S_WAIT_READY;
            end
        end
        S_WAIT_READY: begin
            _counter    = 0;

            if (idelayctrl_ready) begin
                _state  = S_SETTLE;
            end
        end
        S_SETTLE: begin
            _counter    = counter + 1;

            if (!idelayctrl_ready) begin
                _counter    = 0;
                _state      = S_WAIT_READY;
            end
            else if (counter == RDY_WAIT_CYCLES - 1) begin
                _counter            = 0;
                _calibration_done   = 1;
                _state              = S_CALIBRATED;
            end
        end
        S_CALIBRATED: begin
            //RDY lost after calibration, the controller has to be reset again
            if (!idelayctrl_ready) begin
                _counter                = 0;
                _calibration_done       = 0;
                _idelayctrl_reset_hold  = 1;
                _state                  = S_HOLD_CONTROLLER_RESET;
            end
        end
    endcase
end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        state                   <= S_HOLD_CONTROLLER_RESET;
        counter                 <= '0;
        idelayctrl_reset_hold   <= '1;
        calibration_done        <= '0;
    end
    else begin
        state                   <= _state;
        counter                 <= _counter;
        idelayctrl_reset_hold   <= _idelayctrl_reset_hold;
        calibration_done        <= _calibration_done;
    end
end


assign pre_delay_lanes              = {pre_delay_data_control, pre_delay_data};
assign post_delay_data_control      = post_delay_lanes[4];
assign post_delay_data              = post_delay_lanes[3:0];


assign ready                        = (FORMAT == "TIME" && IDELAYCTRL_ENABLE) ? calibration_done : 1'b1;
assign idelayctrl_reset             = idelayctrl_reset_hold;
assign idelayctlr_reference_clock   = clock;

endmodule