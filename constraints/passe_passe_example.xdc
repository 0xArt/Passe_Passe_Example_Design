#////////////////////////////////////////////////////////////////////////////////
# Top level ports
#////////////////////////////////////////////////////////////////////////////////

set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS33} [get_ports {vadj_level[0]}]
set_property -dict {PACKAGE_PIN AC13 IOSTANDARD LVCMOS33} [get_ports {vadj_level[1]}]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS18} [get_ports vadj_auton]
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS18} [get_ports reset_button]
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS18} [get_ports udp_test_button]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports led]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports system_heartbeat_led]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports ethernet_heartbeat_led]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports system_clock_p]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports system_clock_n]
set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data_control[0]}]
set_property -dict {PACKAGE_PIN L7 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_clock[0]}]
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data_control[1]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_clock[1]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[0][1]}]
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[0][0]}]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[0][3]}]
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[0][2]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_clock[0]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[0][0]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_reset_n[0]}]
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[1][0]}]
set_property -dict {PACKAGE_PIN J9 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data_control[0]}]
set_property -dict {PACKAGE_PIN K9 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[0][3]}]
set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[0][2]}]
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[0][1]}]
set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[1][3]}]
set_property -dict {PACKAGE_PIN M8 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[1][1]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_receive_data[1][2]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_clock[1]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[1][1]}]
set_property -dict {PACKAGE_PIN H7 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[1][0]}]
set_property -dict {PACKAGE_PIN N7 IOSTANDARD LVCMOS18} [get_ports system_clock_enable]
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data_control[1]}]
set_property -dict {PACKAGE_PIN K7 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[1][3]}]
set_property -dict {PACKAGE_PIN K8 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_transmit_data[1][2]}]
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS18} [get_ports {rgmii_phy_reset_n[1]}]
set_property slew FAST [get_ports [list {rgmii_phy_transmit_data[*][*]}  {rgmii_phy_transmit_data_control[*]} {rgmii_phy_transmit_clock[*]}]]

#////////////////////////////////////////////////////////////////////////////////
# Clocking
#////////////////////////////////////////////////////////////////////////////////

set uncertainty_jitter 0.1
set uncertainty_multiplier 1.10
set uncertainty_hold 0.03

set rgmii_clock_uncertainty [expr 8 - ( 8 - $uncertainty_jitter) / ($uncertainty_multiplier)]

create_clock -period 8.000 -name rgmii_0_rx_clock -waveform {0.000 4.000} -add [get_ports {rgmii_phy_receive_clock[0]}]
set_clock_uncertainty -setup $rgmii_clock_uncertainty [get_clocks rgmii_0_rx_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_0_rx_clock]

create_clock -period 8.000 -name rgmii_1_rx_clock -waveform {0.000 4.000} -add [get_ports {rgmii_phy_receive_clock[1]}]
set_clock_uncertainty -setup $rgmii_clock_uncertainty [get_clocks rgmii_1_rx_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_1_rx_clock]

create_clock -period 8.000 -name rgmii_transmit_clock -waveform {0.000 4.000} -add [get_pins main_system_clock_wiz/clk_out3]
set_clock_uncertainty -setup $rgmii_clock_uncertainty [get_clocks rgmii_transmit_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_transmit_clock]

set system_clock_uncertainty [expr 4 - ( 4 - $uncertainty_jitter) / ($uncertainty_multiplier)]

create_clock -period 4.000 -name system_clock -waveform {0.000 2.000} -add [get_pins main_system_clock_wiz/clk_out1]
set_clock_uncertainty -setup $system_clock_uncertainty [get_clocks system_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks system_clock]

create_clock -period 3.330 -name delay_calibration_clock -waveform {0.000 1.670} -add [get_pins main_system_clock_wiz/clk_out2]

set_property CLOCK_REGION X1Y1 [get_cells {genblk2[1].BUFG_RGMII}]
set_property USER_CLOCK_ROOT {X1Y1} [get_nets {reset_synchronizer_rgmii_1_clock}]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {rgmii_phy_receive_clock_IBUF[1]_inst/O}]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets {reset_synchronizer_rgmii_1_clock}]

#////////////////////////////////////////////////////////////////////////////////
# Input Delays
#////////////////////////////////////////////////////////////////////////////////

set_input_delay -clock rgmii_0_rx_clock -max -add_delay 1.9 [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -min -add_delay 1.8 [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -clock_fall -max -add_delay 1.9 [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -clock_fall -min -add_delay 1.8 [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]

set_input_delay -clock rgmii_1_rx_clock -max -add_delay 2.8 [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -min -add_delay 2.6 [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -clock_fall -max -add_delay 2.8 [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -clock_fall -min -add_delay 2.6 [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]

create_clock -name virtual_clk -period 10
set_input_delay -max 2.0 -clock virtual_clk [get_ports reset_button]
set_input_delay -min 0.5 -clock virtual_clk [get_ports reset_button]
set_input_delay -max 2.0 -clock virtual_clk [get_ports udp_test_button]
set_input_delay -min 0.5 -clock virtual_clk [get_ports udp_test_button]

#////////////////////////////////////////////////////////////////////////////////
# Output Delays
#////////////////////////////////////////////////////////////////////////////////

#set_output_delay -clock [get_clocks rgmii_transmit_clock] -clock_fall -max 0.75 [get_ports {rgmii_phy_transmit_data[*][*] rgmii_phy_transmit_data_control[*] rgmii_phy_transmit_clock[*]}]
#set_output_delay -clock [get_clocks rgmii_transmit_clock] -clock_fall -min -0.7 [get_ports {rgmii_phy_transmit_data[*][*] rgmii_phy_transmit_data_control[*] rgmii_phy_transmit_clock[*]}]
#set_output_delay -clock [get_clocks rgmii_transmit_clock] -max 0.75 [get_ports {rgmii_phy_transmit_data[*][*] rgmii_phy_transmit_data_control[*] rgmii_phy_transmit_clock[*]}]
#set_output_delay -clock [get_clocks rgmii_transmit_clock] -min -0.7 [get_ports {rgmii_phy_transmit_data[*][*] rgmii_phy_transmit_data_control[*] rgmii_phy_transmit_clock[*]}]


set_output_delay -clock [get_clocks system_clock] -min  0.5 [get_ports {rgmii_phy_reset_n[*]}]
set_output_delay -clock [get_clocks system_clock] -max   1 [get_ports {rgmii_phy_reset_n[*]}]

set_output_delay -clock [get_clocks rgmii_transmit_clock] -min  0.5 [get_ports ethernet_heartbeat_led]
set_output_delay -clock [get_clocks rgmii_transmit_clock] -max  2 [get_ports ethernet_heartbeat_led]

#////////////////////////////////////////////////////////////////////////////////
# False Paths
#////////////////////////////////////////////////////////////////////////////////

set_false_path -from [get_pins marvell_88E151x_reset_controller/reset_reg/C] -to [get_ports {rgmii_phy_reset_n[*]}]
set_false_path -from [get_pins ethernet_heartbeat/status_reg/C] -to [get_ports ethernet_heartbeat_led]
set_false_path -from [get_ports reset_button]
set_false_path -from [get_ports udp_test_button]

set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_1/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_0/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_transmit/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_system/internal_reset_n_reg[*]/CLR}]

#////////////////////////////////////////////////////////////////////////////////
# ILA
#////////////////////////////////////////////////////////////////////////////////

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list clock]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 38 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[0]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[1]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[2]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[3]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[4]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[5]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[6]} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_delayed[7]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[0]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[1]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[2]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[3]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[4]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[5]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[6]} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_delayed[7]} {switch_core/genblk3[0].rgmii_port/inbound_fifo_full} {switch_core/genblk3[0].rgmii_port/phy_received_bytes_fifo_full} {switch_core/genblk3[1].rgmii_port/ethernet_packet_parser/drop_packet_active} {switch_core/genblk3[1].rgmii_port/ethernet_packet_parser/bad_packet_active} {switch_core/genblk3[0].rgmii_port/que_slot_receieve_handler/next_que_slot_fifo_full} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/sync_error} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_error_delayed} {switch_core/genblk3[0].rgmii_port/rgmii_byte_packager/data_enable_delayed} {switch_core/genblk3[0].rgmii_port/ethernet_packet_parser/drop_packet_active} {switch_core/genblk3[0].rgmii_port/ethernet_packet_parser/bad_packet_active} {switch_core/genblk3[1].rgmii_port/que_slot_receieve_handler/next_que_slot_fifo_full} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/sync_error} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_enable_delayed} {switch_core/genblk3[1].rgmii_port/rgmii_byte_packager/data_error_delayed} {switch_core/genblk3[1].rgmii_port/inbound_fifo_full} {switch_core/genblk3[1].rgmii_port/phy_received_bytes_fifo_full} switch_core/cam_table_no_match switch_core/core_data_orchestrator/transmit_buffers_ready_delay switch_core/core_data_orchestrator/transmit_buffers_ready {switch_core/core_data_orchestrator_port_transmit_data_enable[0]} {switch_core/core_data_orchestrator_port_transmit_data_enable[1]} {switch_core/core_data_orchestrator_port_transmit_data_enable[2]}]]
#set_property C_CLK_INPUT_FREQ_HZ 250000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets main_system_clock_wiz/clk_out1]