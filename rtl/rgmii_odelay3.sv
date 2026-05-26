`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 09/16/2025
// Design Name: 
// Module Name: rgmii_odelay3
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
module rgmii_odelay3 #(
    parameter DATA_CLOCK_DELAY      = 0,
    parameter DATA_0_DELAY          = 0,
    parameter DATA_1_DELAY          = 0,
    parameter DATA_2_DELAY          = 0,
    parameter DATA_3_DELAY          = 0,
    parameter DATA_CONTROL_DELAY    = 0,
    parameter FORMAT                = "COUNT",
    parameter SIM_DEVICE            = "ULTRASCALE_PLUS",
    parameter REFCLK_FREQUENCY      = 300.0
)(
    input   wire                            clock,
    input   wire                            reset_n,
    input   wire                            pre_delay_data_clock,
    input   wire                            pre_delay_data_control,
    input   wire [3:0]                      pre_delay_data,

    output   wire                           post_delay_data_clock,
    output   wire                           post_delay_data_control,
    output   wire [3:0]                     post_delay_data,
    output   wire                           ready
);

localparam CALIBRATION_ACTIVE = (FORMAT == "TIME") ? 1'b1 : 1'b0;

wire idelayctrl_reset;
wire idelayctlr_reference_clock;

wire idelayctrl_ready;

generate
    if (FORMAT == "TIME") begin
        IDELAYCTRL #(
            .SIM_DEVICE     ("ULTRASCALE")
        ) IDELAYCTRL(
            .RST    (idelayctrl_reset),
            .REFCLK (idelayctlr_reference_clock),
            
            .RDY    (idelayctrl_ready)
        );
    end
endgenerate


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_CLOCK_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_clock (
    .ODATAIN        (pre_delay_data_clock),
    .DATAOUT        (post_delay_data_clock),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_CONTROL_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_control (
    .ODATAIN        (pre_delay_data_control),
    .DATAOUT        (post_delay_data_control),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_0_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_0 (
    .ODATAIN        (pre_delay_data[0]),
    .DATAOUT        (post_delay_data[0]),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_1_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_1 (
    .ODATAIN        (pre_delay_data[1]),
    .DATAOUT        (post_delay_data[1]),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_2_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_2 (
    .ODATAIN        (pre_delay_data[2]),
    .DATAOUT        (post_delay_data[2]),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);


ODELAYE3 #(
    .DELAY_FORMAT       (FORMAT),
    .DELAY_TYPE         ("FIXED"),
    .DELAY_VALUE        (DATA_3_DELAY),
    .SIM_DEVICE         (SIM_DEVICE),
    .REFCLK_FREQUENCY   (REFCLK_FREQUENCY)
) ODELAYE3_data_3 (
    .ODATAIN        (pre_delay_data[3]),
    .DATAOUT        (post_delay_data[3]),
    .CE             (1'b0),
    .INC            (1'b0),
    .LOAD           (1'b0),
    .CLK            (clock),
    .RST            (!reset_n),
    .EN_VTC         (CALIBRATION_ACTIVE)
);

assign ready                        = (FORMAT == "TIME") ? idelayctrl_ready : 1'b1;
assign idelayctrl_reset             = !reset_n;
assign idelayctlr_reference_clock   = clock;

endmodule