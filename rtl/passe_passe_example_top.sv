`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 12/18/2024
// Design Name: 
// Module Name: passe_passe_example_top
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
module passe_passe_example_top #(
    parameter SIMULATION            = 0,
    parameter NUMBER_OF_RGMII_PORTS = 2
)(
    input   wire                                        system_clock_p,
    input   wire                                        system_clock_n,
    input   wire                                        reset_button,
    input   wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    rgmii_phy_receive_data,
    input   wire    [NUMBER_OF_RGMII_PORTS-1:0]         rgmii_phy_receive_data_control,
    input   wire    [NUMBER_OF_RGMII_PORTS-1:0]         rgmii_phy_receive_clock,
    input   wire                                        udp_test_button,

    output  wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    rgmii_phy_transmit_data,
    output  wire    [NUMBER_OF_RGMII_PORTS-1:0]         rgmii_phy_transmit_data_control,
    output  wire    [NUMBER_OF_RGMII_PORTS-1:0]         rgmii_phy_transmit_clock,
    output  wire                                        led,
    output  wire    [1:0]                               vadj_level,
    output  wire                                        vadj_auton,
    output  wire                                        system_heartbeat_led,
    output  wire                                        ethernet_heartbeat_led,
    output  wire    [NUMBER_OF_RGMII_PORTS-1:0]         rgmii_phy_reset_n,
    output  wire                                        system_clock_enable
);


localparam  NUMBER_OF_RMII_PORTS        = 0;
localparam  NUMBER_OF_VIRTUAL_PORTS     = 1;
localparam  RECEIVE_QUEUE_SLOTS         = 4;
localparam  TECHNOLOGY                  = "ULTRASCALE";
localparam  ENABLE_RGMII_0_IDELAY       = 1;
localparam  ENABLE_RGMII_1_IDELAY       = 1;
localparam  ENABLE_RGMII_0_ODELAY       = 0;
localparam  ENABLE_RGMII_1_ODELAY       = 0;

genvar i;


wire    clock;
wire    delay_reference_clock;
wire    rgmii_transmit_clock_125;
wire    main_system_clock_wiz_locked;

main_system_clock_wiz main_system_clock_wiz(
    .clk_in1_p  (system_clock_p),
    .clk_in1_n  (system_clock_n),    
    
    .clk_out1   (clock),
    .clk_out2   (delay_reference_clock),
    .clk_out3   (rgmii_transmit_clock_125),
    .locked     (main_system_clock_wiz_locked)
);


wire    power_on_reset_slowest_sync_clk;
wire    power_on_reset_ext_reset_in;
wire    power_on_reset_aux_reset_in;
wire    power_on_reset_mb_debug_sys_rst;
wire    power_on_reset_dcm_locked;

wire    power_on_reset_mb_reset;
wire    power_on_reset_bus_struct_reset;
wire    power_on_reset_peripheral_reset;
wire    power_on_reset_interconnect_aresetn;
wire    power_on_reset_peripheral_aresetn;

power_on_reset power_on_reset(
    .slowest_sync_clk       (power_on_reset_slowest_sync_clk),
    .ext_reset_in           (power_on_reset_ext_reset_in),
    .aux_reset_in           (power_on_reset_aux_reset_in),
    .mb_debug_sys_rst       (power_on_reset_mb_debug_sys_rst),
    .dcm_locked             (power_on_reset_dcm_locked),

    .mb_reset               (power_on_reset_mb_reset),
    .bus_struct_reset       (power_on_reset_bus_struct_reset),
    .peripheral_reset       (power_on_reset_peripheral_reset),
    .interconnect_aresetn   (power_on_reset_interconnect_aresetn),
    .peripheral_aresetn     (power_on_reset_peripheral_aresetn)
);


wire reset_synchronizer_system_clock;
wire reset_synchronizer_system_async_reset_n;

wire reset_synchronizer_system_sync_reset_n;

reset_synchronizer reset_synchronizer_system(
    .clock          (reset_synchronizer_system_clock),
    .async_reset_n  (reset_synchronizer_system_async_reset_n),
    
    .sync_reset_n   (reset_synchronizer_system_sync_reset_n)
);


wire reset_synchronizer_rgmii_0_clock;
wire reset_synchronizer_rgmii_0_async_reset_n;

wire reset_synchronizer_rgmii_0_sync_reset_n;

reset_synchronizer reset_synchronizer_rgmii_0(
    .clock          (reset_synchronizer_rgmii_0_clock),
    .async_reset_n  (reset_synchronizer_rgmii_0_async_reset_n),
    
    .sync_reset_n   (reset_synchronizer_rgmii_0_sync_reset_n)
);


wire reset_synchronizer_rgmii_1_clock;
wire reset_synchronizer_rgmii_1_async_reset_n;

wire reset_synchronizer_rgmii_1_sync_reset_n;

reset_synchronizer reset_synchronizer_rgmii_1(
    .clock          (reset_synchronizer_rgmii_1_clock),
    .async_reset_n  (reset_synchronizer_rgmii_1_async_reset_n),
    
    .sync_reset_n   (reset_synchronizer_rgmii_1_sync_reset_n)
);


wire reset_synchronizer_rgmii_transmit_clock;
wire reset_synchronizer_rgmii_transmit_async_reset_n;

wire reset_synchronizer_rgmii_transmit_sync_reset_n;

reset_synchronizer reset_synchronizer_rgmii_transmit(
    .clock          (reset_synchronizer_rgmii_transmit_clock),
    .async_reset_n  (reset_synchronizer_rgmii_transmit_async_reset_n),
    
    .sync_reset_n   (reset_synchronizer_rgmii_transmit_sync_reset_n)
);


wire reset_synchronizer_delay_clock;
wire reset_synchronizer_delay_async_reset_n;

wire reset_synchronizer_delay_sync_reset_n;

reset_synchronizer reset_synchronizer_delay(
    .clock          (reset_synchronizer_delay_clock),
    .async_reset_n  (reset_synchronizer_delay_async_reset_n),

    .sync_reset_n   (reset_synchronizer_delay_sync_reset_n)
);


wire phy_delay_ready_synchronizer_clock;
wire phy_delay_ready_synchronizer_reset_n;
wire phy_delay_ready_synchronizer_source_signal;

wire phy_delay_ready_synchronizer_destination_signal;
wire phy_delay_ready_synchronizer_destination_signal_valid;

variable_stage_synchronizer #(
    .DATA_WIDTH (1)
) phy_delay_ready_synchronizer (
    .clock                      (phy_delay_ready_synchronizer_clock),
    .reset_n                    (phy_delay_ready_synchronizer_reset_n),
    .source_signal              (phy_delay_ready_synchronizer_source_signal),

    .destination_signal         (phy_delay_ready_synchronizer_destination_signal),
    .destination_signal_valid   (phy_delay_ready_synchronizer_destination_signal_valid)
);


wire rgmii_odelay3_clock;
wire rgmii_odelay3_reset_n;
wire rgmii_0_odelay3_ready;
wire rgmii_1_odelay3_ready;
wire rgmii_0_idelay3_ready;
wire rgmii_1_idelay3_ready;


wire rgmii_rx_delay_ready;


generate
    if (!SIMULATION) begin
        if (ENABLE_RGMII_0_ODELAY) begin
            rgmii_odelay3 #(
                .DATA_CLOCK_DELAY   (10),
                .DATA_0_DELAY       (10),
                .DATA_1_DELAY       (1),
                .DATA_2_DELAY       (2),
                .DATA_3_DELAY       (4),
                .DATA_CONTROL_DELAY (1),
                .FORMAT             ("COUNT"),
                .REFCLK_FREQUENCY   (300.0)
            )rgmii_0_odelay3(
                .clock                      (rgmii_odelay3_clock),
                .reset_n                    (rgmii_odelay3_reset_n),
                .pre_delay_data_clock       (switch_core_rgmii_phy_transmit_clock[0]),
                .pre_delay_data_control     (switch_core_rgmii_phy_transmit_data_control[0]),
                .pre_delay_data             (switch_core_rgmii_phy_transmit_data[0]),
            
                .post_delay_data_clock      (rgmii_phy_transmit_clock[0]),
                .post_delay_data_control    (rgmii_phy_transmit_data_control[0]),
                .post_delay_data            (rgmii_phy_transmit_data[0]),
                .ready                      (rgmii_0_odelay3_ready)
            );
        end

        if (ENABLE_RGMII_1_ODELAY) begin
            rgmii_odelay3 #(
                .DATA_CLOCK_DELAY   (5),
                .DATA_0_DELAY       (3),
                .DATA_1_DELAY       (5),
                .DATA_2_DELAY       (1),
                .DATA_3_DELAY       (1),
                .DATA_CONTROL_DELAY (1),
                .FORMAT             ("COUNT"),
                .REFCLK_FREQUENCY   (300.0)
            )rgmii_1_odelay3(
                .clock                      (rgmii_odelay3_clock),
                .reset_n                    (rgmii_odelay3_reset_n),
                .pre_delay_data_clock       (switch_core_rgmii_phy_transmit_clock[1]),
                .pre_delay_data_control     (switch_core_rgmii_phy_transmit_data_control[1]),
                .pre_delay_data             (switch_core_rgmii_phy_transmit_data[1]),
            
                .post_delay_data_clock      (rgmii_phy_transmit_clock[1]),
                .post_delay_data_control    (rgmii_phy_transmit_data_control[1]),
                .post_delay_data            (rgmii_phy_transmit_data[1]),
                .ready                      (rgmii_1_odelay3_ready)
            );
        end

        if (ENABLE_RGMII_0_IDELAY) begin
            rgmii_idelay3 #(
                .DATA_0_DELAY       (788),
                .DATA_1_DELAY       (780),
                .DATA_2_DELAY       (788),
                .DATA_3_DELAY       (802),
                .DATA_CONTROL_DELAY (787),
                .FORMAT             ("TIME"),
                .REFCLK_FREQUENCY   (300.0)
            )rgmii_0_idelay3(
                .clock                      (rgmii_odelay3_clock),
                .reset_n                    (rgmii_odelay3_reset_n),
                .pre_delay_data_control     (rgmii_phy_receive_data_control[0]),
                .pre_delay_data             (rgmii_phy_receive_data[0]),
            
                .post_delay_data_control    (switch_core_rgmii_phy_receive_data_control[0]),
                .post_delay_data            (switch_core_rgmii_phy_receive_data[0]),
                .ready                      (rgmii_0_idelay3_ready)
            );
        end

        if (ENABLE_RGMII_1_IDELAY) begin
            rgmii_idelay3 #(
                .DATA_0_DELAY       (999),
                .DATA_1_DELAY       (997),
                .DATA_2_DELAY       (1004),
                .DATA_3_DELAY       (1001),
                .DATA_CONTROL_DELAY (1012),
                .FORMAT             ("TIME"),
                .REFCLK_FREQUENCY   (300.0),
                .IDELAYCTRL_ENABLE  (0),
                .CASCADE_ENABLE     (1)
            )rgmii_1_idelay3(
                .clock                      (rgmii_odelay3_clock),
                .reset_n                    (rgmii_odelay3_reset_n),
                .pre_delay_data_control     (rgmii_phy_receive_data_control[1]),
                .pre_delay_data             (rgmii_phy_receive_data[1]),
            
                .post_delay_data_control    (switch_core_rgmii_phy_receive_data_control[1]),
                .post_delay_data            (switch_core_rgmii_phy_receive_data[1]),
                .ready                      (rgmii_1_idelay3_ready)
            );
        end
    end
endgenerate


wire [1:0]  rgmii_phy_receive_clock_pre_bufg;
wire [1:0]  rgmii_phy_receive_clock_post_bufg;

generate
    for (i = 0; i < NUMBER_OF_RGMII_PORTS; i = i + 1) begin
        BUFG BUFG_RGMII(
            .I      (rgmii_phy_receive_clock_pre_bufg[i]),

            .O      (rgmii_phy_receive_clock_post_bufg[i])
        );
    end
endgenerate


wire                                        switch_core_clock;
wire                                        switch_core_reset_n;
wire    [NUMBER_OF_VIRTUAL_PORTS-1:0]       switch_core_module_clock;
wire    [NUMBER_OF_VIRTUAL_PORTS-1:0]       switch_core_module_transmit_data_enable;
wire    [NUMBER_OF_VIRTUAL_PORTS-1:0][8:0]  switch_core_module_transmit_data;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_receive_clock_reset_n;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_transmit_clock_reset_n;
wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    switch_core_rgmii_phy_receive_data;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_receive_data_control;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_receive_data_clock;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_transmit_clock;

wire    [NUMBER_OF_VIRTUAL_PORTS-1:0][8:0]  switch_core_module_receive_data;
wire    [NUMBER_OF_VIRTUAL_PORTS-1:0]       switch_core_module_receive_data_valid;
wire    [NUMBER_OF_VIRTUAL_PORTS-1:0]       switch_core_module_transmit_data_ready;
wire    [NUMBER_OF_RGMII_PORTS-1:0][3:0]    switch_core_rgmii_phy_transmit_data;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_transmit_data_control;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_transmit_clock;
wire    [NUMBER_OF_RGMII_PORTS-1:0]         switch_core_rgmii_phy_transmit_clock_raw;

switch_core #(
    .NUMBER_OF_RMII_PORTS           (NUMBER_OF_RMII_PORTS),
    .NUMBER_OF_RGMII_PORTS          (NUMBER_OF_RGMII_PORTS),
    .NUMBER_OF_VIRTUAL_PORTS        (NUMBER_OF_VIRTUAL_PORTS),
    .RECEIVE_QUEUE_SLOTS            (RECEIVE_QUEUE_SLOTS),
    .TECHNOLOGY                     (TECHNOLOGY),
    .FABRIC_DATA_BYTES              (4),
    .CORE_CLOCK_FREQUENCY           (62_500_000),
    .PHASE_SHIFT_TX_CLOCK_ENABLE    (0)
)
switch_core(
    .clock                              (switch_core_clock),
    .reset_n                            (switch_core_reset_n),
    .rgmii_phy_receive_clock_reset_n    (switch_core_rgmii_phy_receive_clock_reset_n),
    .rgmii_phy_transmit_clock_reset_n   (switch_core_rgmii_phy_transmit_clock_reset_n),
    .rgmii_phy_receive_data             (switch_core_rgmii_phy_receive_data),
    .rgmii_phy_receive_data_control     (switch_core_rgmii_phy_receive_data_control),
    .rgmii_phy_receive_clock            (switch_core_rgmii_phy_receive_data_clock),
    .module_clock                       (switch_core_module_clock),
    .module_transmit_data_enable        (switch_core_module_transmit_data_enable),
    .module_transmit_data               (switch_core_module_transmit_data),
    .rgmii_transmit_clock               (switch_core_rgmii_transmit_clock),

    .module_receive_data                (switch_core_module_receive_data),
    .module_receive_data_valid          (switch_core_module_receive_data_valid),
    .module_transmit_data_ready         (switch_core_module_transmit_data_ready),
    .rgmii_phy_transmit_data            (switch_core_rgmii_phy_transmit_data),
    .rgmii_phy_transmit_data_control    (switch_core_rgmii_phy_transmit_data_control),
    .rgmii_phy_transmit_clock           (switch_core_rgmii_phy_transmit_clock),
    .rgmii_phy_transmit_clock_raw       (switch_core_rgmii_phy_transmit_clock_raw)
);


wire        udp_test_module_clock;
wire        udp_test_module_reset_n;
wire        udp_test_module_enable;
wire [8:0]  udp_test_module_data;
wire        udp_test_module_data_enable;
wire        udp_test_module_packet_data_enable;
wire [47:0] udp_test_module_mac_destination;
wire [31:0] udp_test_module_ipv4_destination;
wire [15:0] udp_test_module_udp_destination;

wire [8:0]  udp_test_module_packet_data;
wire        udp_test_module_packet_data_valid;
wire [8:0]  udp_test_mpdule_received_data;
wire        udp_test_module_received_data_valid;
wire        udp_test_module_blink;

udp_test_module#(
    .UDP_SOURCE         (16'h8888),
    .TECHNOLOGY         (TECHNOLOGY)
)udp_test_module(
    .clock              (udp_test_module_clock),
    .reset_n            (udp_test_module_reset_n),
    .enable             (udp_test_module_enable),
    .data               (udp_test_module_data),
    .data_enable        (udp_test_module_data_enable),
    .packet_data_enable (udp_test_module_packet_data_enable),
    .mac_destination    (udp_test_module_mac_destination),
    .ipv4_destination   (udp_test_module_ipv4_destination),
    .udp_destination    (udp_test_module_udp_destination),

    .packet_data        (udp_test_module_packet_data),
    .packet_data_valid  (udp_test_module_packet_data_valid),
    .blink              (udp_test_module_blink),
    .received_data      (udp_test_mpdule_received_data),
    .received_data_valid(udp_test_module_received_data_valid)
);


wire    rate_limited_debouncer_clock;
wire    rate_limited_debouncer_reset_n;
wire    rate_limited_debouncer_enable;

wire    rate_limited_debouncer_debounced_enable;

rate_limited_debouncer#(
    .COUNTER_WIDTH      (23)
)rate_limited_debouncer(
    .clock              (rate_limited_debouncer_clock),
    .reset_n            (rate_limited_debouncer_reset_n),
    .enable             (rate_limited_debouncer_enable),

    .debounced_enable   (rate_limited_debouncer_debounced_enable)
);


wire ethernet_heartbeat_clock;
wire ethernet_heartbeat_reset_n;

wire ethernet_heartbeat_status;

heartbeat ethernet_heartbeat(
    .clock              (ethernet_heartbeat_clock),
    .reset_n            (ethernet_heartbeat_reset_n),

    .status             (ethernet_heartbeat_status)
);


wire marvell_88E151x_reset_controller_clock;
wire marvell_88E151x_reset_controller_reset_n;
wire marvell_88E151x_reset_controller_reset_request;

wire marvell_88E151x_reset_controller_reset;

marvell_88E151x_reset_controller #(
    .CLOCK_FREQUENCY            (62_500_000),
    .SIMULATION                 (SIMULATION)
)marvell_88E151x_reset_controller(
    .clock          (marvell_88E151x_reset_controller_clock),
    .reset_n        (marvell_88E151x_reset_controller_reset_n),
    .reset_request  (marvell_88E151x_reset_controller_reset_request),

    .reset          (marvell_88E151x_reset_controller_reset)
);


assign rgmii_phy_receive_clock_pre_bufg[0]              = rgmii_phy_receive_clock[0];
assign rgmii_phy_receive_clock_pre_bufg[1]              = rgmii_phy_receive_clock[1];

assign switch_core_clock                                = clock;
assign switch_core_reset_n                              = reset_synchronizer_system_sync_reset_n;
assign switch_core_rgmii_phy_receive_clock_reset_n[0]   = reset_synchronizer_rgmii_0_sync_reset_n;
assign switch_core_rgmii_phy_receive_clock_reset_n[1]   = reset_synchronizer_rgmii_1_sync_reset_n;
assign switch_core_rgmii_phy_transmit_clock_reset_n[0]  = reset_synchronizer_rgmii_transmit_sync_reset_n;
assign switch_core_rgmii_phy_transmit_clock_reset_n[1]  = reset_synchronizer_rgmii_transmit_sync_reset_n;
assign switch_core_rgmii_transmit_clock[0]              = rgmii_transmit_clock_125;
assign switch_core_rgmii_transmit_clock[1]              = rgmii_transmit_clock_125;


assign switch_core_rgmii_phy_receive_data_clock[0]      = rgmii_phy_receive_clock_post_bufg[0];
assign switch_core_rgmii_phy_receive_data_clock[1]      = rgmii_phy_receive_clock_post_bufg[1];

generate
    if (SIMULATION || !ENABLE_RGMII_0_IDELAY) begin
        assign switch_core_rgmii_phy_receive_data[0]            = rgmii_phy_receive_data[0];
        assign switch_core_rgmii_phy_receive_data_control[0]    = rgmii_phy_receive_data_control[0];
    end
endgenerate

generate
    if (SIMULATION || !ENABLE_RGMII_1_IDELAY) begin
        assign switch_core_rgmii_phy_receive_data[1]            = rgmii_phy_receive_data[1];
        assign switch_core_rgmii_phy_receive_data_control[1]    = rgmii_phy_receive_data_control[1];
    end
endgenerate

assign switch_core_module_clock                         = clock;
assign switch_core_module_transmit_data                 = udp_test_module_packet_data;
assign switch_core_module_transmit_data_enable          = udp_test_module_packet_data_valid;

assign power_on_reset_slowest_sync_clk                  = clock;
assign power_on_reset_ext_reset_in                      = reset_button;
assign power_on_reset_aux_reset_in                      = '0;
assign power_on_reset_mb_debug_sys_rst                  = '0;
assign reset_n                                          = power_on_reset_peripheral_aresetn;
assign power_on_reset_dcm_locked                        = main_system_clock_wiz_locked;


assign udp_test_module_clock                            = clock;
assign udp_test_module_reset_n                          = reset_synchronizer_system_sync_reset_n;
assign udp_test_module_enable                           = rate_limited_debouncer_debounced_enable;
assign udp_test_module_data                             = switch_core_module_receive_data;
assign udp_test_module_data_enable                      = switch_core_module_receive_data_valid;
assign udp_test_module_packet_data_enable               = switch_core_module_transmit_data_ready;
assign udp_test_module_mac_destination                  = 48'hACDCBEEF0102;
assign udp_test_module_ipv4_destination                 = 32'h77884455;
assign udp_test_module_udp_destination                  = 16'h8888;


assign marvell_88E151x_reset_controller_clock           = clock;
assign marvell_88E151x_reset_controller_reset_n         = reset_synchronizer_system_sync_reset_n;
assign marvell_88E151x_reset_controller_reset_request   = !phy_delay_ready_synchronizer_destination_signal;


assign rate_limited_debouncer_clock                     = clock;
assign rate_limited_debouncer_reset_n                   = reset_synchronizer_system_sync_reset_n;
assign rate_limited_debouncer_enable                    = udp_test_button;

assign rgmii_odelay3_clock                              = delay_reference_clock;
assign rgmii_odelay3_reset_n                            = reset_synchronizer_delay_sync_reset_n;

assign ethernet_heartbeat_clock                         = clock;
assign ethernet_heartbeat_reset_n                       = reset_synchronizer_system_sync_reset_n;


generate
    if (SIMULATION) begin
        assign rgmii_phy_transmit_clock[0]              = switch_core_rgmii_phy_transmit_clock[0];
        assign rgmii_phy_transmit_data_control[0]       = switch_core_rgmii_phy_transmit_data_control[0];
        assign rgmii_phy_transmit_data[0]               = switch_core_rgmii_phy_transmit_data[0];
        assign rgmii_phy_transmit_data[1]               = switch_core_rgmii_phy_transmit_data[1];
        assign rgmii_phy_transmit_data_control[1]       = switch_core_rgmii_phy_transmit_data_control[1];
        assign rgmii_phy_transmit_clock[1]              = switch_core_rgmii_phy_transmit_clock[1];
    end
    else begin
        if (!ENABLE_RGMII_0_ODELAY) begin
            assign rgmii_phy_transmit_clock[0]              = switch_core_rgmii_phy_transmit_clock[0];
            assign rgmii_phy_transmit_data_control[0]       = switch_core_rgmii_phy_transmit_data_control[0];
            assign rgmii_phy_transmit_data[0]               = switch_core_rgmii_phy_transmit_data[0];
        end

        if (!ENABLE_RGMII_1_ODELAY) begin
            assign rgmii_phy_transmit_clock[1]              = switch_core_rgmii_phy_transmit_clock[1];
            assign rgmii_phy_transmit_data_control[1]       = switch_core_rgmii_phy_transmit_data_control[1];
            assign rgmii_phy_transmit_data[1]               = switch_core_rgmii_phy_transmit_data[1];
        end
    end
endgenerate


assign rgmii_phy_reset_n                                = {NUMBER_OF_RGMII_PORTS{!marvell_88E151x_reset_controller_reset}};

assign vadj_level                                       = 2'b11;
assign vadj_auton                                       = 1;

assign rgmii_rx_delay_ready                             = (SIMULATION) ? 1'b1 :
                                                          ((ENABLE_RGMII_0_IDELAY ? rgmii_0_idelay3_ready : 1'b1) &
                                                           (ENABLE_RGMII_1_IDELAY ? rgmii_1_idelay3_ready : 1'b1));

assign system_heartbeat_led                             = main_system_clock_wiz_locked;
assign ethernet_heartbeat_led                           = ethernet_heartbeat_status;
assign led                                              = rgmii_rx_delay_ready;
assign system_clock_enable                              = 1'b1;

assign reset_synchronizer_system_clock                  = clock;
assign reset_synchronizer_system_async_reset_n          = power_on_reset_peripheral_aresetn;

assign reset_synchronizer_rgmii_0_clock                 = rgmii_phy_receive_clock_post_bufg[0];
assign reset_synchronizer_rgmii_0_async_reset_n         = power_on_reset_peripheral_aresetn;

assign reset_synchronizer_rgmii_1_clock                 = rgmii_phy_receive_clock_post_bufg[1];
assign reset_synchronizer_rgmii_1_async_reset_n         = power_on_reset_peripheral_aresetn;

assign reset_synchronizer_rgmii_transmit_clock          = rgmii_transmit_clock_125;
assign reset_synchronizer_rgmii_transmit_async_reset_n  = power_on_reset_peripheral_aresetn;

assign reset_synchronizer_delay_clock                   = delay_reference_clock;
assign reset_synchronizer_delay_async_reset_n           = power_on_reset_peripheral_aresetn;

assign phy_delay_ready_synchronizer_clock               = clock;
assign phy_delay_ready_synchronizer_reset_n             = reset_synchronizer_system_sync_reset_n;
assign phy_delay_ready_synchronizer_source_signal       = rgmii_rx_delay_ready;

endmodule