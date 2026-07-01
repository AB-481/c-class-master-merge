set curdir [ file dirname [ file normalize [ info script ] ] ]
source $curdir/env.tcl

if { $argc != 1 } {
  puts "ERROR: Please provide the numbers of jobs as an argument"
  exit 2
}

set jobs [lindex $argv 0]
open_project $core_project_dir/$core_project.xpr

reset_run core_synth_1
reset_run core_impl_1

launch_runs core_synth_1 -jobs $jobs
wait_on_run core_synth_1
open_run core_synth_1 -name core_synth_1
report_utilization -hierarchical -file $core_project_dir/core_syn_area.txt
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose\
  -max_paths 10 -input_pins -file $core_project_dir/core_syn_timing.txt

launch_runs core_impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run core_impl_1
#
exit 

