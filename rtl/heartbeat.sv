`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 09/13/2025
// Design Name: 
// Module Name: heartbeat
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
module heartbeat#(
    parameter   COUNTER_WIDTH   = 32,
    parameter   COUNTER_INDEX   = 24
)(
    input   wire    clock,
    input   wire    reset_n,

    output  reg     status
);

logic   [COUNTER_WIDTH-1:0] _counter;
reg     [COUNTER_WIDTH-1:0] counter;
logic                       _status;
logic   [COUNTER_WIDTH-1:0] _counter_delayed;
reg     [COUNTER_WIDTH-1:0] counter_delayed;

always_comb begin
    _counter            = counter + 1;
    _counter_delayed    = counter;
    _status             = counter_delayed[COUNTER_INDEX];
end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        counter         <=  '0;
        status          <=  '0;
        counter_delayed <= '0;
    end
    else begin
        counter         <=  _counter;
        status          <=  _status;
        counter_delayed <= _counter_delayed;
    end
end


endmodule