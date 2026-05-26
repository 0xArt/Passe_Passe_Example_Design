#Create output directory and clear contents
set outputdir ./project
file mkdir $outputdir
set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0} {
    puts "deleting contents of $outputdir"
    file delete -force {*}[glob -directory $outputdir *]; # clear folder contents
} else {
    puts "$outputdir is empty"
}

#Create project
create_project -part xczu3eg-sfvc784-1-e passe_passe_example- $outputdir

#add source files to Vivado project
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/block_ram/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/fifo/synchronous_fifo/rtl/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/fifo/synchronous_fifo/rtl/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/fifo/asynchronous_fifo/rtl/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/rgmii/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/virtual_port/udp/*.sv]
add_files [glob ./rtl/submodules/Passe_Passe_Network_Switch/rtl/*.sv]
add_files [glob ./rtl/*.sv]

add_files -fileset constrs_1 ./constraints/passe_passe_example.xdc
add_files -fileset sim_1 ./test/testbench.sv
add_files -fileset sim_1 ./test/case_000/case_000.svh
add_files -fileset sim_1 ./test/case_001/case_001.svh
add_files -fileset sim_1 ./test/case_002/case_002.svh
import_ip ./vivado_ip/power_on_reset.xci
generate_target all [get_files *power_on_reset.xci]
import_ip ./vivado_ip/rgmii_pll_clock_wiz.xci
generate_target all [get_files *rgmii_pll_clock_wiz.xci]
import_ip ./vivado_ip/main_system_clock_wiz.xci
generate_target all [get_files *main_system_clock_wiz.xci]
set_property top passe_passe_example_top [current_fileset]
set_property top testbench [get_filesets sim_1]