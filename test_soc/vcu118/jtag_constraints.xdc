create_clock -period 50.000 -name tck -waveform {0.000 25.000} -add [get_nets pin_tck]

set_multicycle_path -setup 5 -from [get_clocks tck] -to [get_clocks clk_out1_clk_divider] -end
set_multicycle_path -hold 4 -from [get_clocks tck] -to [get_clocks clk_out1_clk_divider] -start
set_multicycle_path -setup 5 -from [get_clocks clk_out1_clk_divider] -to [get_clocks tck] -start
set_multicycle_path -hold 4 -from [get_clocks clk_out1_clk_divider] -to [get_clocks tck] -start

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pin_tck_IBUF]

# ## JLINK (FMC-SDRAM VCU108 BOARD)
# #R1
# set_property PACKAGE_PIN AM14      [get_ports "pin_trst"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "pin_trst"] ;
# set_property PULLDOWN true [get_ports pin_trst]
# #R2
# set_property PACKAGE_PIN AL14     [get_ports "pin_tms"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tms"] ;
# set_property PULLUP true [get_ports pin_tms]
# #R6
# set_property PACKAGE_PIN BB14     [get_ports "pin_tck"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tck"] ;
# #R7
# set_property PACKAGE_PIN AY12      [get_ports "pin_tdi"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdi"] ;
# #R8
# set_property PACKAGE_PIN AW12     [get_ports "pin_tdo"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdo"] ;
#JTAG
#FMC J2.H32


set_property PACKAGE_PIN AW10     [get_ports "pin_trst"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_trst"] ;
set_property PULLDOWN true [get_ports pin_trst];
#FMC J2.H34
set_property PACKAGE_PIN AK12     [get_ports "pin_tdi"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdi"] ;
#FMC J2.H35
set_property PACKAGE_PIN AL12     [get_ports "pin_tms"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tms"] ;
set_property PULLUP true [get_ports pin_tms];
#FMC J2.H37
set_property PACKAGE_PIN AJ13     [get_ports "pin_tck"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tck"] ;
#FMC J2.H38
set_property PACKAGE_PIN AJ12     [get_ports "pin_tdo"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdo"] ;
