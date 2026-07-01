create_clock -period 50.000 -name tck -waveform {0.000 25.000} -add [get_nets pin_tck]

set_multicycle_path -setup 5 -from [get_clocks tck] -to [get_clocks clk_out1_clk_divider] -end
set_multicycle_path -hold 4 -from [get_clocks tck] -to [get_clocks clk_out1_clk_divider] -start
set_multicycle_path -setup 5 -from [get_clocks clk_out1_clk_divider] -to [get_clocks tck] -start
set_multicycle_path -hold 4 -from [get_clocks clk_out1_clk_divider] -to [get_clocks tck] -start

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pin_tck_IBUF]

#set_property -dict { PACKAGE_PIN AV16  IOSTANDARD LVCMOS18  } [get_ports {pin_tck}]; #PMOD0_4
#set_property -dict { PACKAGE_PIN AU16  IOSTANDARD LVCMOS18  PULLUP TRUE } [get_ports {pin_tms}]; #PMOD0_5
#set_property -dict { PACKAGE_PIN AT15  IOSTANDARD LVCMOS18  } [get_ports {pin_tdi}]; #PMOD0_6
#set_property -dict { PACKAGE_PIN AT16  IOSTANDARD LVCMOS18  PULLDOWN TRUE } [get_ports {pin_trst}]; #PMOD0_7
#set_property -dict { PACKAGE_PIN AY14  IOSTANDARD LVCMOS18  } [get_ports {pin_tdo}]; #PMOD0_0

#set_property -dict { PACKAGE_PIN M31 IOSTANDARD LVCMOS18  PULLUP TRUE } [get_ports { pin_tms             }]; #PMOD1_6
##set_property PULLUP   true [get_ports { pin_tms  }]; 
#set_property -dict { PACKAGE_PIN R29   IOSTANDARD LVCMOS18  PULLUP TRUE } [get_ports { pin_tdi             }]; #PMOD1_7
#set_property -dict { PACKAGE_PIN P30   IOSTANDARD LVCMOS12  PULLDOWN TRUE  } [get_ports { pin_trst            }]; #PMOD1_3
#set_property PULLDOWN true [get_ports { pin_trst }]; 
#set_property -dict { PACKAGE_PIN P29   IOSTANDARD LVCMOS18  PULLUP TRUE } [get_ports { pin_tdo             }]; #PMOD1_4
#set_property -dict { PACKAGE_PIN L31   IOSTANDARD LVCMOS18  PULLUP TRUE } [get_ports { pin_tck             }]; #PMOD1_5

set_property PACKAGE_PIN AL36     [get_ports "pin_trst"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_trst"] ;
set_property PULLDOWN true [get_ports pin_trst];
#FMC J2.H34
set_property PACKAGE_PIN AJ30     [get_ports "pin_tdi"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdi"] ;
#FMC J2.H35
set_property PACKAGE_PIN AJ31     [get_ports "pin_tms"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tms"] ;
set_property PULLUP true [get_ports pin_tms];
#FMC J2.H37
set_property PACKAGE_PIN AG31     [get_ports "pin_tck"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tck"] ;
#FMC J2.H38
set_property PACKAGE_PIN AH31     [get_ports "pin_tdo"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "pin_tdo"] ;
