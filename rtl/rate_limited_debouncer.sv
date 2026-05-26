`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 09/13/2025
// Design Name: 
// Module Name: rate_limited_debouncer
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
module rate_limited_debouncer#(
    parameter   COUNTER_WIDTH   = 8
)(
    input   wire    clock,
    input   wire    reset_n,
    input   wire    enable,

    output  reg     debounced_enable
);

logic   [COUNTER_WIDTH-1:0] _counter;
reg     [COUNTER_WIDTH-1:0] counter;
logic   [2:0]               _delayed_enable;
reg     [2:0]               delayed_enable;
logic                       _debounced_enable;
logic                       enable_rising_edge;
logic                       enable_falling_edge;
logic                       _ignore_bounces;
reg                         ignore_bounces;

always_comb begin
    _debounced_enable       = 0;
    _ignore_bounces         = ignore_bounces;
    _counter                = counter;
    _delayed_enable[0]      = enable;
    _delayed_enable[2:1]    = delayed_enable[1:0];
    enable_rising_edge      = delayed_enable[1] && !delayed_enable[2];
    enable_falling_edge     = !delayed_enable[1] && delayed_enable[2];


    if (enable_rising_edge && !ignore_bounces) begin
        _debounced_enable   = 1;
        _ignore_bounces     = 1;
        _counter            = '1;
    end

    if (ignore_bounces) begin
        if (enable_rising_edge || enable_falling_edge) begin
            _counter = '1;
        end
        else begin
            _counter = counter - 1;
        end
    end

    if (counter == 0) begin
        _counter    = '1;
        
        if (&delayed_enable) begin
            _debounced_enable   = 1;
            _ignore_bounces     = 1;
        end
        else begin
            _ignore_bounces = 0;
        end    
    end
end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        counter             <=  '1;
        delayed_enable      <=  '0;
        debounced_enable    <=  '0;
        ignore_bounces      <=  '0;
    end
    else begin
        counter             <= _counter;
        delayed_enable      <= _delayed_enable;
        debounced_enable    <= _debounced_enable;
        ignore_bounces      <= _ignore_bounces;
    end
end


endmodule