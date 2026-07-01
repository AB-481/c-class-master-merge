#set curdir [ file dirname [ file normalize [ info script ] ] ]
#source $curdir/env.tcl
#
#open_project $ip_project_dir/$ip_project.xpr
#set_property "simulator_language" "Mixed" [current_project]
#set_property "target_language" "Verilog" [current_project]


puts "\nDEBUG: Creating MIG IP for DDR3 \n"
if { [get_ips -quiet mig_7series_0] eq "" } {
    create_ip -name mig_7series -vendor xilinx.com -library ip -module_name mig_ddr3
} else {
    reset_run mig_synth_1
}


if { $axibuswidth eq "BUS_WIDTH128" } {
	set_property CONFIG.XML_INPUT_FILE [file normalize $home_dir/tcl/video_mig_128.prj] [get_ips mig_ddr3]
}
if { $axibuswidth eq "BUS_WIDTH64" } {
    set_property CONFIG.XML_INPUT_FILE [file normalize $home_dir/tcl/video_mig_64.prj] [get_ips mig_ddr3]
}
if { $axibuswidth eq "BUS_WIDTH32" } {
    set_property CONFIG.XML_INPUT_FILE [file normalize $home_dir/tcl/video_mig_32.prj] [get_ips mig_ddr3]
}
#set_property CONFIG.XML_INPUT_FILE [file normalize $home_dir/tcl/video_mig.prj] [get_ips mig_ddr3]
generate_target {instantiation_template} [get_ips mig_ddr3]
create_ip_run [get_ips mig_ddr3]
#launch_run mig_7series_0_synth_1
#wait_on_run mig_7series_0_synth_1
