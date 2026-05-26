`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 11/13/2025
// Design Name: 
// Module Name: marvell_88E151x_reset_controller
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
module marvell_88E151x_reset_controller#(
    parameter       CLOCK_FREQUENCY     = 50_000_000,
    parameter bit   SIMULATION          = 0
)(
    input   wire    clock,
    input   wire    reset_n,
    input   wire    reset_request,

    output  reg     reset
);

localparam CLOCK_PERIOD_MS      =  1e3/CLOCK_FREQUENCY;
localparam RESET_HOLD_CYCLES    =  (SIMULATION) ? 10 : int'(10/CLOCK_PERIOD_MS); //10 ms is required by the PHY
localparam COUNTER_WIDTH        =  ($clog2(RESET_HOLD_CYCLES) > 4) ? $clog2(RESET_HOLD_CYCLES): 4;


typedef enum
{
    S_WAIT,
    S_RELEASE,
    S_HOLD,
    S_IDLE
} state_type;

state_type                  _state;
state_type                  state;

reg     [COUNTER_WIDTH-1:0] counter;
logic   [COUNTER_WIDTH-1:0] _counter;
logic                       _local_reset;
reg                         local_reset;
logic                       _reset;


always_comb begin
    _state          = state;
    _counter        = counter;
    _local_reset    = local_reset;
    _reset          = local_reset;

    case (state)
        S_WAIT: begin
            _local_reset    = 1;
            _counter        = counter + 1;

            if (counter == 9) begin
                _counter = 0;
                _state   = S_RELEASE;
            end

            if (reset_request) begin
                _counter = 0;
                _state  = S_WAIT;
            end
        end
        S_RELEASE: begin
            _local_reset    = 0;
            _counter        = counter + 1;

            if (counter == 9) begin
                _counter = 0;
                _state   = S_HOLD;
            end

            if (reset_request) begin
                _counter = 0;
                _state  = S_WAIT;
            end
        end
        S_HOLD: begin
            _local_reset    = 1;
            _counter        = counter + 1;

            if (counter == RESET_HOLD_CYCLES) begin
                _state   = S_IDLE;
            end

            if (reset_request) begin
                _counter = 0;
                _state  = S_WAIT;
            end
        end
        S_IDLE: begin
            _local_reset    = 0;
            _counter        = 0;

            if (reset_request) begin
                _state  = S_WAIT;
            end
        end
    endcase
end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        state       <= S_WAIT;
        counter     <= '0;
        local_reset <= '1;
        reset       <= '1;
    end
    else begin
        state       <= _state;
        counter     <= _counter;
        local_reset <= _local_reset;
        reset       <= _reset;
    end
end

endmodule