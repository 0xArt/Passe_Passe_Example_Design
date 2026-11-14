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

# RGMII receive clocks. 8 ns is the 1000 Mbps case; 10/100 (40 ns / 400 ns) only add margin.
# No period derating on these: their setup uncertainty lands directly on the IDDR capture
# window, so only the PHY's real RXC jitter is applied (check the 88E151x datasheet).
set rgmii_rx_clock_jitter 0.1

create_clock -period 8.000 -name rgmii_0_rx_clock -waveform {0.000 4.000} [get_ports {rgmii_phy_receive_clock[0]}]
set_input_jitter [get_clocks rgmii_0_rx_clock] $rgmii_rx_clock_jitter
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_0_rx_clock]

create_clock -period 8.000 -name rgmii_1_rx_clock -waveform {0.000 4.000} [get_ports {rgmii_phy_receive_clock[1]}]
set_input_jitter [get_clocks rgmii_1_rx_clock] $rgmii_rx_clock_jitter
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_1_rx_clock]

# MMCM outputs: rename the clocks Vivado derives from the clock wizard instead of redefining
# them with create_clock, which would drop the MMCM's insertion delay, phase and jitter.
create_generated_clock -name system_clock            [get_pins main_system_clock_wiz/inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name delay_calibration_clock [get_pins main_system_clock_wiz/inst/mmcme4_adv_inst/CLKOUT1]
create_generated_clock -name rgmii_transmit_clock    [get_pins main_system_clock_wiz/inst/mmcme4_adv_inst/CLKOUT2]

set system_clock_uncertainty [expr 16 - ( 16 - $uncertainty_jitter) / ($uncertainty_multiplier)]
set_clock_uncertainty -setup $system_clock_uncertainty [get_clocks system_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks system_clock]

set rgmii_clock_uncertainty [expr 8 - ( 8 - $uncertainty_jitter) / ($uncertainty_multiplier)]
set_clock_uncertainty -setup $rgmii_clock_uncertainty [get_clocks rgmii_transmit_clock]
set_clock_uncertainty -hold $uncertainty_hold [get_clocks rgmii_transmit_clock]

# RGMII transmit: forwarded clocks at the TXC pins. TXC and TXD/TX_CTL leave through ODDRE1s
# (OSERDESE3) on the same rgmii_transmit_clock edge, so the interface is edge aligned and the
# PHY's internal TX delay (88E151x page 2 reg 21 bit 4) centers it. Valid while
# PHASE_SHIFT_TX_CLOCK_ENABLE = 0 and the RGMII ODELAYs are disabled.
create_generated_clock -name rgmii_0_tx_clock -multiply_by 1 -source [get_pins {switch_core/genblk3[0].rgmii_port/data_clock_ddr_output_buffer/genblk1[0].ddr_output/CLK}] [get_ports {rgmii_phy_transmit_clock[0]}]
create_generated_clock -name rgmii_1_tx_clock -multiply_by 1 -source [get_pins {switch_core/genblk3[1].rgmii_port/data_clock_ddr_output_buffer/genblk1[0].ddr_output/CLK}] [get_ports {rgmii_phy_transmit_clock[1]}]

# pin the RX clock roots so the RXC insertion delay (and the IDELAY settings tuned
# against it) does not move from build to build
set_property USER_CLOCK_ROOT {X1Y1} [get_nets {reset_synchronizer_rgmii_0_clock}]

set_property CLOCK_REGION X1Y1 [get_cells {genblk2[1].BUFG_RGMII}]
set_property USER_CLOCK_ROOT {X1Y1} [get_nets {reset_synchronizer_rgmii_1_clock}]
# port 1 RXC reaches its BUFGCE over general routing (H4 is not a GC pin), so keep its clock
# tree as short as possible: CLOCK_LOW_FANOUT places all its loads next to the BUFGCE,
# which minimizes (and steadies) the IDDR capture clock delay the IDELAY is tuned against
set_property CLOCK_LOW_FANOUT TRUE [get_nets {reset_synchronizer_rgmii_1_clock}]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {rgmii_phy_receive_clock_IBUF[1]_inst/O}]

#////////////////////////////////////////////////////////////////////////////////
# Input Delays
#////////////////////////////////////////////////////////////////////////////////
# Center aligned DDR inputs: the PHY adds the RX_CLK delay (88E151x page 2 reg 21 bit 5 = 1, the
# power on default), so RXD/RX_CTL are stable at least 1.2 ns before and 1.2 ns after every RXC
# edge at the PHY pins (88E151x datasheet Rev. G, Table 175).
# rgmii_rx_board_skew is the worst RXC vs RXD/RX_CTL mismatch at the FPGA die: Genesys ZU PCB
# (reference manual Table 10.2.2.2) + FMC card (rgmii_trace_lengths.xlsx) at 6.67 ps/mm, plus the
# xczu3eg-sfvc784 package pin delays, which Vivado does not include for these ports.
# Worst case is 24 ps (port 0, RXD[3] early), taken off both sides of the window.
set rgmii_rx_setup      1.2
set rgmii_rx_hold       1.2
set rgmii_rx_board_skew 0.025

set rgmii_rx_max [expr 4.0 - ($rgmii_rx_setup - $rgmii_rx_board_skew)]
set rgmii_rx_min [expr $rgmii_rx_hold - $rgmii_rx_board_skew]

set_input_delay -clock rgmii_0_rx_clock -max $rgmii_rx_max [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -min $rgmii_rx_min [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -clock_fall -max $rgmii_rx_max -add_delay [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]
set_input_delay -clock rgmii_0_rx_clock -clock_fall -min $rgmii_rx_min -add_delay [get_ports {{rgmii_phy_receive_data[0][*]} {rgmii_phy_receive_data_control[0]}}]

set_input_delay -clock rgmii_1_rx_clock -max $rgmii_rx_max [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -min $rgmii_rx_min [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -clock_fall -max $rgmii_rx_max -add_delay [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]
set_input_delay -clock rgmii_1_rx_clock -clock_fall -min $rgmii_rx_min -add_delay [get_ports {{rgmii_phy_receive_data[1][*]} {rgmii_phy_receive_data_control[1]}}]

# data launched on one RXC edge is captured on the opposite edge (setup) and must not disturb
# the edge it was launched on (hold); drop the same edge setup and opposite edge hold checks
set_false_path -setup -rise_from [get_clocks rgmii_0_rx_clock] -rise_to [get_clocks rgmii_0_rx_clock]
set_false_path -setup -fall_from [get_clocks rgmii_0_rx_clock] -fall_to [get_clocks rgmii_0_rx_clock]
set_false_path -hold  -rise_from [get_clocks rgmii_0_rx_clock] -fall_to [get_clocks rgmii_0_rx_clock]
set_false_path -hold  -fall_from [get_clocks rgmii_0_rx_clock] -rise_to [get_clocks rgmii_0_rx_clock]

set_false_path -setup -rise_from [get_clocks rgmii_1_rx_clock] -rise_to [get_clocks rgmii_1_rx_clock]
set_false_path -setup -fall_from [get_clocks rgmii_1_rx_clock] -fall_to [get_clocks rgmii_1_rx_clock]
set_false_path -hold  -rise_from [get_clocks rgmii_1_rx_clock] -fall_to [get_clocks rgmii_1_rx_clock]
set_false_path -hold  -fall_from [get_clocks rgmii_1_rx_clock] -rise_to [get_clocks rgmii_1_rx_clock]
create_clock -name virtual_clk -period 10
set_input_delay -max 2.0 -clock virtual_clk [get_ports reset_button]
set_input_delay -min 0.5 -clock virtual_clk [get_ports reset_button]
set_input_delay -max 2.0 -clock virtual_clk [get_ports udp_test_button]
set_input_delay -min 0.5 -clock virtual_clk [get_ports udp_test_button]

#////////////////////////////////////////////////////////////////////////////////
# Output Delays
#////////////////////////////////////////////////////////////////////////////////

# Edge aligned DDR outputs: the PHY adds the TX_CLK delay (88E151x page 2 reg 21 bit 4 = 1, the
# power on default), and its input requirement at the pins is then tsetup = -0.9 ns and
# thold = 2.7 ns (88E151x datasheet Rev. G, Table 173). So TXD/TX_CTL may switch up to
# 0.9 ns after a TXC edge and up to 4.0 - 2.7 = 1.3 ns before one.
# rgmii_tx_board_skew is the worst TXC vs TXD/TX_CTL mismatch at the PHY pins, from the same
# sources as rgmii_rx_board_skew: 51 ps (data late on both ports), taken off both sides.
set rgmii_tx_phy_setup  -0.9
set rgmii_tx_phy_hold   2.7
set rgmii_tx_board_skew 0.055

set rgmii_tx_after_edge  [expr -$rgmii_tx_phy_setup - $rgmii_tx_board_skew]
set rgmii_tx_before_edge [expr 4.0 - $rgmii_tx_phy_hold - $rgmii_tx_board_skew]

set_output_delay -clock rgmii_0_tx_clock -max [expr 4.0 - $rgmii_tx_after_edge] [get_ports {{rgmii_phy_transmit_data[0][*]} {rgmii_phy_transmit_data_control[0]}}]
set_output_delay -clock rgmii_0_tx_clock -min $rgmii_tx_before_edge [get_ports {{rgmii_phy_transmit_data[0][*]} {rgmii_phy_transmit_data_control[0]}}]
set_output_delay -clock rgmii_0_tx_clock -clock_fall -max [expr 4.0 - $rgmii_tx_after_edge] -add_delay [get_ports {{rgmii_phy_transmit_data[0][*]} {rgmii_phy_transmit_data_control[0]}}]
set_output_delay -clock rgmii_0_tx_clock -clock_fall -min $rgmii_tx_before_edge -add_delay [get_ports {{rgmii_phy_transmit_data[0][*]} {rgmii_phy_transmit_data_control[0]}}]

set_output_delay -clock rgmii_1_tx_clock -max [expr 4.0 - $rgmii_tx_after_edge] [get_ports {{rgmii_phy_transmit_data[1][*]} {rgmii_phy_transmit_data_control[1]}}]
set_output_delay -clock rgmii_1_tx_clock -min $rgmii_tx_before_edge [get_ports {{rgmii_phy_transmit_data[1][*]} {rgmii_phy_transmit_data_control[1]}}]
set_output_delay -clock rgmii_1_tx_clock -clock_fall -max [expr 4.0 - $rgmii_tx_after_edge] -add_delay [get_ports {{rgmii_phy_transmit_data[1][*]} {rgmii_phy_transmit_data_control[1]}}]
set_output_delay -clock rgmii_1_tx_clock -clock_fall -min $rgmii_tx_before_edge -add_delay [get_ports {{rgmii_phy_transmit_data[1][*]} {rgmii_phy_transmit_data_control[1]}}]

# skew check: setup against the opposite TXC edge (half period minus the late limit), hold
# against the same edge (early limit); drop the same edge setup and opposite edge hold checks
set_false_path -setup -rise_from [get_clocks rgmii_transmit_clock] -rise_to [get_clocks rgmii_0_tx_clock]
set_false_path -setup -fall_from [get_clocks rgmii_transmit_clock] -fall_to [get_clocks rgmii_0_tx_clock]
set_false_path -hold  -rise_from [get_clocks rgmii_transmit_clock] -fall_to [get_clocks rgmii_0_tx_clock]
set_false_path -hold  -fall_from [get_clocks rgmii_transmit_clock] -rise_to [get_clocks rgmii_0_tx_clock]

set_false_path -setup -rise_from [get_clocks rgmii_transmit_clock] -rise_to [get_clocks rgmii_1_tx_clock]
set_false_path -setup -fall_from [get_clocks rgmii_transmit_clock] -fall_to [get_clocks rgmii_1_tx_clock]
set_false_path -hold  -rise_from [get_clocks rgmii_transmit_clock] -fall_to [get_clocks rgmii_1_tx_clock]
set_false_path -hold  -fall_from [get_clocks rgmii_transmit_clock] -rise_to [get_clocks rgmii_1_tx_clock]
set_output_delay -clock [get_clocks system_clock] -min  0.5 [get_ports {rgmii_phy_reset_n[*]}]
set_output_delay -clock [get_clocks system_clock] -max   1 [get_ports {rgmii_phy_reset_n[*]}]

set_output_delay -clock [get_clocks rgmii_transmit_clock] -min  0.5 [get_ports ethernet_heartbeat_led]
set_output_delay -clock [get_clocks rgmii_transmit_clock] -max  2 [get_ports ethernet_heartbeat_led]

set_output_delay -clock [get_clocks delay_calibration_clock] -min  0.5 [get_ports led]
set_output_delay -clock [get_clocks delay_calibration_clock] -max  2 [get_ports led]

#////////////////////////////////////////////////////////////////////////////////
# False Paths
#////////////////////////////////////////////////////////////////////////////////

set_false_path -from [get_pins marvell_88E151x_reset_controller/reset_reg/C] -to [get_ports {rgmii_phy_reset_n[*]}]
set_false_path -from [get_pins ethernet_heartbeat/status_reg/C] -to [get_ports ethernet_heartbeat_led]
set_false_path -from [get_pins rgmii_0_idelay3/calibration_done_reg/C] -to [get_ports led]
set_false_path -from [get_ports reset_button]
set_false_path -from [get_ports udp_test_button]

set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_1/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_0/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_rgmii_transmit/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_system/internal_reset_n_reg[*]/CLR}]
set_false_path -from [get_pins {power_on_reset/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {reset_synchronizer_delay/internal_reset_n_reg[*]/CLR}]

#////////////////////////////////////////////////////////////////////////////////
# Clock Domain Crossings
#////////////////////////////////////////////////////////////////////////////////

# speed code (in band status from the RGMII receive clock) into the transmit and core domains.
# quasi static, only changes across a link renegotiation: bound the first stage to one receive
# clock period and keep the synchronizer flops packed together
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *speed_code_synchronizer/retimed_signal_reg*}]
set_max_delay -datapath_only -from [get_cells -hierarchical -filter {NAME =~ *rgmii_byte_packager/speed_code_reg*}] -to [get_cells -hierarchical -filter {NAME =~ *speed_code_synchronizer/retimed_signal_reg*}] 8.000

set_property ASYNC_REG TRUE [get_cells {reset_synchronizer_*/internal_reset_n_reg[*]}]

# RX delay calibration done (delay clock) into the system clock domain, where it holds the PHY
# reset controller in reset_request. quasi static: bound the first stage to one delay clock period
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *phy_delay_ready_synchronizer/retimed_signal_reg*}]
set_max_delay -datapath_only -from [get_cells rgmii_0_idelay3/calibration_done_reg] -to [get_cells -hierarchical -filter {NAME =~ *phy_delay_ready_synchronizer/retimed_signal_reg*}] 3.333

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