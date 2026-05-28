`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 12/20/2024
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
`include "./case_000/case_000.svh"
`include "./case_001/case_001.svh"
`include "./case_002/case_002.svh"
`include "./case_003/case_003.svh"


module testbench;

localparam  DATA_WIDTH              = 8;
localparam  CLOCK_FREQUENCY         = 125_000_000;
localparam  CLOCK_PERIOD            = 1e9/CLOCK_FREQUENCY;
localparam  RGMII_CLOCK_FREQUENCY   = 125_000_000;
localparam  RGMII_CLOCK_PERIOD      = 1e9/RGMII_CLOCK_FREQUENCY;
localparam  NUMBER_OF_RGMII_PORTS   = 2;
localparam  LOOPBACK                = 1;

reg         clock                       = 0;
reg         reset_n                     = 0;
logic       rgmii_clock_0               = 0;
logic [3:0] rgmii_data_0                = 0;
logic       rgmii_data_control_0        = 0;
logic       rgmii_clock_1               = 0;
logic [3:0] rgmii_data_1                = 0;
logic       rgmii_data_control_1        = 0;
logic [7:0] ethernet_message_0 [0:1500];
logic [7:0] ethernet_message_1 [0:1500];

wire                                        passe_passe_example_top_clock;
wire                                        passe_passe_example_top_reset_button;
wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    passe_passe_example_top_rgmii_phy_receive_data;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         passe_passe_example_top_rgmii_phy_receive_data_control;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         passe_passe_example_top_rgmii_phy_receive_clock;
logic                                       passe_passe_example_top_udp_test_button;

wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    passe_passe_example_top_rgmii_phy_transmit_data;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         passe_passe_example_top_rgmii_phy_transmit_data_control;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         passe_passe_example_top_rgmii_phy_transmit_data_clock;

passe_passe_example_top #(
    .SIMULATION             (1),
    .NUMBER_OF_RGMII_PORTS  (NUMBER_OF_RGMII_PORTS)
) passe_passe_example_top(
    .system_clock_p                 (passe_passe_example_top_clock_p),
    .system_clock_n                 (passe_passe_example_top_clock_n),
    .reset_button                   (passe_passe_example_top_reset_button),
    .rgmii_phy_receive_data         (passe_passe_example_top_rgmii_phy_receive_data),
    .rgmii_phy_receive_data_control (passe_passe_example_top_rgmii_phy_receive_data_control),
    .rgmii_phy_receive_clock        (passe_passe_example_top_rgmii_phy_receive_clock),
    .udp_test_button                (passe_passe_example_top_udp_test_button),

    .rgmii_phy_transmit_data        (passe_passe_example_top_rgmii_phy_transmit_data),
    .rgmii_phy_transmit_data_control(passe_passe_example_top_rgmii_phy_transmit_data_control),
    .rgmii_phy_transmit_clock       (passe_passe_example_top_rgmii_phy_transmit_data_clock)
);






//clock generation
initial begin
    clock   = 0;
    
    forever begin
        #(CLOCK_PERIOD/2);
        clock   = ~clock;
    end
end


initial begin
    rgmii_clock_0   = 0;

    forever begin
        #(RGMII_CLOCK_PERIOD/2);
        rgmii_clock_0   = ~rgmii_clock_0;
    end
end

initial begin
    rgmii_clock_1   = 0;
    #50ns;

    forever begin
        #(RGMII_CLOCK_PERIOD/2);
        rgmii_clock_1   = ~rgmii_clock_1;
    end
end

initial begin
    passe_passe_example_top_udp_test_button = 0;
    reset_n = 0;
    #10ns;
    @(posedge clock);
    reset_n = 1;
    wait(testbench.passe_passe_example_top.reset_n == 1);
    #1000ns;
    /*
    for (int j = 0; j < 50; j = j + 1) begin
        @(posedge clock)
        case_000();
        #100ns;
    end
    */

    case_003();
    //passe_passe_example_top_udp_test_button = 1;
    //wait(testbench.passe_passe_example_top.rate_limited_debouncer_debounced_enable)
    //@(posedge clock);
    //passe_passe_example_top_udp_test_button = 0;
    //#1ms;
    //@(posedge clock);
    $display("Tests have finsihed");

    $stop();
end


function logic [31:0] calc_crc(input logic [7:0] cmd [0:1500], input logic [15:0] number_of_bytes);
    automatic logic [31:0]  crc                 = '1;
    automatic logic [31:0]  crc_binary_reversed = 0;
    automatic logic [31:0]  c                   = '1;
    automatic logic [31:0]  result              = 0;
    automatic logic [7:0]   d                   = 0;
    automatic int           i                   = 0;
    automatic int           j                   = 0;

    //$display("CRC32 Number of Bytes: %d",number_of_bytes);

    for (i=8; i<number_of_bytes; i++) begin
        for (j=0; j<8; j=j+1) begin
            d[j] = cmd[i][7-j];
        end
        c           = crc;
        crc[0]      = d[7] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[7];
        crc[1]      = d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6];
        crc[2]      = d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6];
        crc[3]      = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7];
        crc[4]      = d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4];
        crc[5]      = d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5];
        crc[6]      = d[6] ^ d[5] ^ d[4] ^ c[4] ^ c[5] ^ c[6];
        crc[7]      = d[7] ^ d[6] ^ d[5] ^ c[5] ^ c[6] ^ c[7];
        crc[0]      = c[24] ^ c[30] ^ d[0] ^ d[6];
        crc[1]      = c[24] ^ c[25] ^ c[30] ^ c[31] ^ d[0] ^ d[1] ^ d[6] ^ d[7];
        crc[2]      = c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31] ^ d[0] ^ d[1] ^ d[2] ^ d[6] ^ d[7];
        crc[3]      = c[25] ^ c[26] ^ c[27] ^ c[31] ^ d[1] ^ d[2] ^ d[3] ^ d[7];
        crc[4]      = c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ d[0] ^ d[2] ^ d[3] ^ d[4] ^ d[6];
        crc[5]      = c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31] ^ d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[5] ^ d[6] ^ d[7];
        crc[6]      = c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31] ^ d[1] ^ d[2] ^ d[4] ^ d[5] ^ d[6] ^ d[7];
        crc[7]      = c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31] ^ d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[7];
        crc[8]      = c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ d[0] ^ d[1] ^ d[3] ^ d[4];
        crc[9]      = c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ d[1] ^ d[2] ^ d[4] ^ d[5];
        crc[10]     = c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ d[0] ^ d[2] ^ d[3] ^ d[5];
        crc[11]     = c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ d[0] ^ d[1] ^ d[3] ^ d[4];
        crc[12]     = c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ d[0] ^ d[1] ^ d[2] ^ d[4] ^ d[5] ^ d[6];
        crc[13]     = c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31] ^ d[1] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[7];
        crc[14]     = c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31] ^ d[2] ^ d[3] ^ d[4] ^ d[6] ^ d[7];
        crc[15]     = c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31] ^ d[3] ^ d[4] ^ d[5] ^ d[7];
        crc[16]     = c[8] ^ c[24] ^ c[28] ^ c[29] ^ d[0] ^ d[4] ^ d[5];
        crc[17]     = c[9] ^ c[25] ^ c[29] ^ c[30] ^ d[1] ^ d[5] ^ d[6];
        crc[18]     = c[10] ^ c[26] ^ c[30] ^ c[31] ^ d[2] ^ d[6] ^ d[7];
        crc[19]     = c[11] ^ c[27] ^ c[31] ^ d[3] ^ d[7];
        crc[20]     = c[12] ^ c[28] ^ d[4];
        crc[21]     = c[13] ^ c[29] ^ d[5];
        crc[22]     = c[14] ^ c[24] ^ d[0];
        crc[23]     = c[15] ^ c[24] ^ c[25] ^ c[30] ^ d[0] ^ d[1] ^ d[6];
        crc[24]     = c[16] ^ c[25] ^ c[26] ^ c[31] ^ d[1] ^ d[2] ^ d[7];
        crc[25]     = c[17] ^ c[26] ^ c[27] ^ d[2] ^ d[3];
        crc[26]     = c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30] ^ d[0] ^ d[3] ^ d[4] ^ d[6];
        crc[27]     = c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31] ^ d[1] ^ d[4] ^ d[5] ^ d[7];
        crc[28]     = c[20] ^ c[26] ^ c[29] ^ c[30] ^ d[2] ^ d[5] ^ d[6];
        crc[29]     = c[21] ^ c[27] ^ c[30] ^ c[31] ^ d[3] ^ d[6] ^ d[7];
        crc[30]     = c[22] ^ c[28] ^ c[31] ^ d[4] ^ d[7];
        crc[31]     = c[23] ^ c[29] ^ d[5];
    end

    crc = crc ^ 32'hFFFF_FFFF;

    for (i=0;i<32;i++) begin
        crc_binary_reversed[i]   = crc[31-i];
    end

    result = {crc_binary_reversed[7:0],crc_binary_reversed[15:8], crc_binary_reversed[23:16], crc_binary_reversed[31:24]};

    //$display("CRC32 Result: %h",result);
    return result;
endfunction


assign passe_passe_example_top_clock_p                              = clock;
assign passe_passe_example_top_clock_n                              = !clock;
assign passe_passe_example_top_reset_button                         = !reset_n;
assign passe_passe_example_top_uart_serial_receive                  = 0;
assign passe_passe_example_top_rgmii_phy_receive_data[0]            = rgmii_data_0;
assign passe_passe_example_top_rgmii_phy_receive_data_control[0]    = rgmii_data_control_0;
assign passe_passe_example_top_rgmii_phy_receive_clock[0]           = rgmii_clock_0;
assign passe_passe_example_top_rgmii_phy_receive_data[1]            = rgmii_data_1;
assign passe_passe_example_top_rgmii_phy_receive_data_control[1]    = rgmii_data_control_1;
assign passe_passe_example_top_rgmii_phy_receive_clock[1]           = rgmii_clock_1;

endmodule