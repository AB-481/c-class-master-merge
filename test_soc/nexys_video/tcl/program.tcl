set curdir [ file dirname [ file normalize [ info script ] ] ]
source $curdir/env.tcl

set jobs [lindex $argv 0]
open_project $core_project_dir/$core_project.xpr

set top_module [get_property TOP [get_filesets sources_1]]

set bit $core_project_dir/$core_project.runs/core_impl_1/$top_module.bit
set device [lindex $argv 1]

puts "BITSTREAM: $bit"

open_hw
connect_hw_server
open_hw_target
set_property PROGRAM.FILE $bit [lindex [get_hw_devices xc7a200t_0] 0]
program_hw_devices [get_hw_devices xc7a200t_0]
refresh_hw_device [lindex [get_hw_devices xc7a200t_0] 0]
close_hw_target 
disconnect_hw_server
puts "INFO: FPGA has been programmed with the given bitstream"
exit

