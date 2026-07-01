set_property PACKAGE_PIN G31 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]

set_property PACKAGE_PIN F31 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_n]

set_property PACKAGE_PIN E12 [get_ports c0_sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_p]

set_property PACKAGE_PIN D12 [get_ports c0_sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_n]
#create_clock -period 4.000 [get_ports sys_clk_p]

#set_input_jitter [get_clocks -of_objects [get_ports c0_sys_clk_p]] 0.05

# CPU_RESET
set_property -dict { PACKAGE_PIN L19 IOSTANDARD LVCMOS12 } [get_ports {sys_rst}];

# UART ports
set_property IOB TRUE [get_ports uart_SOUT]
set_property IOB TRUE [get_ports uart_SIN]

set_property -dict {PACKAGE_PIN BB21 IOSTANDARD LVCMOS18 } [get_ports {uart_SOUT}];# Bank  64 VCCO -VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_64
set_property -dict {PACKAGE_PIN AW25 IOSTANDARD LVCMOS18 } [get_ports {uart_SIN}];# Bank  64 VCCO -VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_64

#set_property -dict {PACKAGE_PIN AT32 IOSTANDARD LVCMOS12 } [get_ports {locked}]; # LED0

## connecting external interrupts to dip switches
#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS12 } [get_ports {ext_interrupts[0]}];
#set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS12 } [get_ports {ext_interrupts[1]}];
#set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS12 } [get_ports {ext_interrupts[2]}];
#set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS12 } [get_ports {ext_interrupts[3]}];

#set_property -dict {PACKAGE_PIN AV34 IOSTANDARD LVCMOS12 } [get_ports {c0_init_calib_complete}]; # LED0
set_property PACKAGE_PIN E13      [get_ports "c0_ddr4_act_n"] ;
set_property PACKAGE_PIN D14      [get_ports "c0_ddr4_adr[0]"] ;
set_property PACKAGE_PIN C12      [get_ports "c0_ddr4_adr[10]"] ;
set_property PACKAGE_PIN B13      [get_ports "c0_ddr4_adr[11]"] ;
set_property PACKAGE_PIN C13      [get_ports "c0_ddr4_adr[12]"] ;
set_property PACKAGE_PIN D15      [get_ports "c0_ddr4_adr[13]"] ;
set_property PACKAGE_PIN H14      [get_ports "c0_ddr4_adr[14]"] ;
set_property PACKAGE_PIN H15      [get_ports "c0_ddr4_adr[15]"] ;
set_property PACKAGE_PIN F15      [get_ports "c0_ddr4_adr[16]"] ;
set_property PACKAGE_PIN B15      [get_ports "c0_ddr4_adr[1]"] ;
set_property PACKAGE_PIN B16      [get_ports "c0_ddr4_adr[2]"] ;
set_property PACKAGE_PIN C14      [get_ports "c0_ddr4_adr[3]"] ;
set_property PACKAGE_PIN C15      [get_ports "c0_ddr4_adr[4]"] ;
set_property PACKAGE_PIN A13      [get_ports "c0_ddr4_adr[5]"] ;
set_property PACKAGE_PIN A14      [get_ports "c0_ddr4_adr[6]"] ;
set_property PACKAGE_PIN A15      [get_ports "c0_ddr4_adr[7]"] ;
set_property PACKAGE_PIN A16      [get_ports "c0_ddr4_adr[8]"] ;
set_property PACKAGE_PIN B12      [get_ports "c0_ddr4_adr[9]"] ;
set_property PACKAGE_PIN G15      [get_ports "c0_ddr4_ba[0]"] ;
set_property PACKAGE_PIN G13      [get_ports "c0_ddr4_ba[1]"] ;
set_property PACKAGE_PIN H13      [get_ports "c0_ddr4_bg[0]"] ;
set_property PACKAGE_PIN E14      [get_ports "c0_ddr4_ck_c[0]"] ;
set_property PACKAGE_PIN F14      [get_ports "c0_ddr4_ck_t[0]"] ;
set_property PACKAGE_PIN A10      [get_ports "c0_ddr4_cke[0]"] ;
set_property PACKAGE_PIN F13      [get_ports "c0_ddr4_cs_n[0]"] ;
set_property PACKAGE_PIN G11      [get_ports "c0_ddr4_dm_dbi_n[0]"] ;
set_property PACKAGE_PIN R18      [get_ports "c0_ddr4_dm_dbi_n[1]"] ;
set_property PACKAGE_PIN K17      [get_ports "c0_ddr4_dm_dbi_n[2]"] ;
set_property PACKAGE_PIN G18      [get_ports "c0_ddr4_dm_dbi_n[3]"] ;
set_property PACKAGE_PIN B18      [get_ports "c0_ddr4_dm_dbi_n[4]"] ;
set_property PACKAGE_PIN P20      [get_ports "c0_ddr4_dm_dbi_n[5]"] ;
set_property PACKAGE_PIN L23      [get_ports "c0_ddr4_dm_dbi_n[6]"] ;
set_property PACKAGE_PIN G22      [get_ports "c0_ddr4_dm_dbi_n[7]"] ;

set_property PACKAGE_PIN F11      [get_ports "c0_ddr4_dq[0]"] ;
set_property PACKAGE_PIN M18      [get_ports "c0_ddr4_dq[10]"] ;
set_property PACKAGE_PIN M17      [get_ports "c0_ddr4_dq[11]"] ;
set_property PACKAGE_PIN N19      [get_ports "c0_ddr4_dq[12]"] ;
set_property PACKAGE_PIN N18      [get_ports "c0_ddr4_dq[13]"] ;
set_property PACKAGE_PIN N17      [get_ports "c0_ddr4_dq[14]"] ;
set_property PACKAGE_PIN M16      [get_ports "c0_ddr4_dq[15]"] ;
set_property PACKAGE_PIN L16      [get_ports "c0_ddr4_dq[16]"] ;
set_property PACKAGE_PIN K16      [get_ports "c0_ddr4_dq[17]"] ;
set_property PACKAGE_PIN L18      [get_ports "c0_ddr4_dq[18]"] ;
set_property PACKAGE_PIN K18      [get_ports "c0_ddr4_dq[19]"] ;
set_property PACKAGE_PIN E11      [get_ports "c0_ddr4_dq[1]"] ;
set_property PACKAGE_PIN J17      [get_ports "c0_ddr4_dq[20]"] ;
set_property PACKAGE_PIN H17      [get_ports "c0_ddr4_dq[21]"] ;
set_property PACKAGE_PIN H19      [get_ports "c0_ddr4_dq[22]"] ;
set_property PACKAGE_PIN H18      [get_ports "c0_ddr4_dq[23]"] ;
set_property PACKAGE_PIN F19      [get_ports "c0_ddr4_dq[24]"] ;
set_property PACKAGE_PIN F18      [get_ports "c0_ddr4_dq[25]"] ;
set_property PACKAGE_PIN E19      [get_ports "c0_ddr4_dq[26]"] ;
set_property PACKAGE_PIN E18      [get_ports "c0_ddr4_dq[27]"] ;
set_property PACKAGE_PIN G20      [get_ports "c0_ddr4_dq[28]"] ;
set_property PACKAGE_PIN F20      [get_ports "c0_ddr4_dq[29]"] ;
set_property PACKAGE_PIN F10      [get_ports "c0_ddr4_dq[2]"] ;
set_property PACKAGE_PIN E17      [get_ports "c0_ddr4_dq[30]"] ;
set_property PACKAGE_PIN D16      [get_ports "c0_ddr4_dq[31]"] ;
set_property PACKAGE_PIN D17      [get_ports "c0_ddr4_dq[32]"] ;
set_property PACKAGE_PIN C17      [get_ports "c0_ddr4_dq[33]"] ;
set_property PACKAGE_PIN C19      [get_ports "c0_ddr4_dq[34]"] ;
set_property PACKAGE_PIN C18      [get_ports "c0_ddr4_dq[35]"] ;
set_property PACKAGE_PIN D20      [get_ports "c0_ddr4_dq[36]"] ;
set_property PACKAGE_PIN D19      [get_ports "c0_ddr4_dq[37]"] ;
set_property PACKAGE_PIN C20      [get_ports "c0_ddr4_dq[38]"] ;
set_property PACKAGE_PIN B20      [get_ports "c0_ddr4_dq[39]"] ;
set_property PACKAGE_PIN F9      [get_ports "c0_ddr4_dq[3]"] ;
set_property PACKAGE_PIN N23      [get_ports "c0_ddr4_dq[40]"] ;
set_property PACKAGE_PIN M23      [get_ports "c0_ddr4_dq[41]"] ;
set_property PACKAGE_PIN R21      [get_ports "c0_ddr4_dq[42]"] ;
set_property PACKAGE_PIN P21      [get_ports "c0_ddr4_dq[43]"] ;
set_property PACKAGE_PIN R22      [get_ports "c0_ddr4_dq[44]"] ;
set_property PACKAGE_PIN P22      [get_ports "c0_ddr4_dq[45]"] ;
set_property PACKAGE_PIN T23      [get_ports "c0_ddr4_dq[46]"] ;
set_property PACKAGE_PIN R23      [get_ports "c0_ddr4_dq[47]"] ;
set_property PACKAGE_PIN K24      [get_ports "c0_ddr4_dq[48]"] ;
set_property PACKAGE_PIN J24      [get_ports "c0_ddr4_dq[49]"] ;
set_property PACKAGE_PIN H12      [get_ports "c0_ddr4_dq[4]"] ;
set_property PACKAGE_PIN M21      [get_ports "c0_ddr4_dq[50]"] ;
set_property PACKAGE_PIN L21      [get_ports "c0_ddr4_dq[51]"] ;
set_property PACKAGE_PIN K21      [get_ports "c0_ddr4_dq[52]"] ;
set_property PACKAGE_PIN J21      [get_ports "c0_ddr4_dq[53]"] ;
set_property PACKAGE_PIN K22      [get_ports "c0_ddr4_dq[54]"] ;
set_property PACKAGE_PIN J22      [get_ports "c0_ddr4_dq[55]"] ;
set_property PACKAGE_PIN H23      [get_ports "c0_ddr4_dq[56]"] ;
set_property PACKAGE_PIN H22      [get_ports "c0_ddr4_dq[57]"] ;
set_property PACKAGE_PIN E23      [get_ports "c0_ddr4_dq[58]"] ;
set_property PACKAGE_PIN E22      [get_ports "c0_ddr4_dq[59]"] ;
set_property PACKAGE_PIN G12      [get_ports "c0_ddr4_dq[5]"] ;
set_property PACKAGE_PIN F21      [get_ports "c0_ddr4_dq[60]"] ;
set_property PACKAGE_PIN E21      [get_ports "c0_ddr4_dq[61]"] ;
set_property PACKAGE_PIN F24      [get_ports "c0_ddr4_dq[62]"] ;
set_property PACKAGE_PIN F23      [get_ports "c0_ddr4_dq[63]"] ;

set_property PACKAGE_PIN E9      [get_ports "c0_ddr4_dq[6]"] ;
set_property PACKAGE_PIN D9      [get_ports "c0_ddr4_dq[7]"] ;
set_property PACKAGE_PIN R19      [get_ports "c0_ddr4_dq[8]"] ;
set_property PACKAGE_PIN P19      [get_ports "c0_ddr4_dq[9]"] ;
set_property PACKAGE_PIN D10      [get_ports "c0_ddr4_dqs_c[0]"] ;
set_property PACKAGE_PIN P16      [get_ports "c0_ddr4_dqs_c[1]"] ;
set_property PACKAGE_PIN J19      [get_ports "c0_ddr4_dqs_c[2]"] ;
set_property PACKAGE_PIN E16      [get_ports "c0_ddr4_dqs_c[3]"] ;
set_property PACKAGE_PIN A18      [get_ports "c0_ddr4_dqs_c[4]"] ;
set_property PACKAGE_PIN M22      [get_ports "c0_ddr4_dqs_c[5]"] ;
set_property PACKAGE_PIN L20      [get_ports "c0_ddr4_dqs_c[6]"] ;
set_property PACKAGE_PIN G23      [get_ports "c0_ddr4_dqs_c[7]"] ;

set_property PACKAGE_PIN D11      [get_ports "c0_ddr4_dqs_t[0]"] ;
set_property PACKAGE_PIN P17      [get_ports "c0_ddr4_dqs_t[1]"] ;
set_property PACKAGE_PIN K19      [get_ports "c0_ddr4_dqs_t[2]"] ;
set_property PACKAGE_PIN F16      [get_ports "c0_ddr4_dqs_t[3]"] ;
set_property PACKAGE_PIN A19      [get_ports "c0_ddr4_dqs_t[4]"] ;
set_property PACKAGE_PIN N22      [get_ports "c0_ddr4_dqs_t[5]"] ;
set_property PACKAGE_PIN M20      [get_ports "c0_ddr4_dqs_t[6]"] ;
set_property PACKAGE_PIN H24      [get_ports "c0_ddr4_dqs_t[7]"] ;

set_property PACKAGE_PIN C8      [get_ports "c0_ddr4_odt[0]"] ;
set_property PACKAGE_PIN N20      [get_ports "c0_ddr4_reset_n"] ;

set_property PACKAGE_PIN BD13     [get_ports "io7_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io7_cell"] ;
set_property PACKAGE_PIN BE13      [get_ports "io8_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io8_cell"] ;

set_property PACKAGE_PIN BB13     [get_ports "io9_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io9_cell"] ;
set_property PACKAGE_PIN BB12      [get_ports "io10_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io10_cell"] ;

set_property PACKAGE_PIN AW8     [get_ports "io12_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io12_cell"] ;
set_property PACKAGE_PIN AW7      [get_ports "io13_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io13_cell"] ;

set_property PACKAGE_PIN AP12     [get_ports "io16_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io16_cell"] ;
# set_property PACKAGE_PIN AR12      [get_ports "io17_cell"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "io17_cell"] ;

# set_property PACKAGE_PIN AN15     [get_ports "io18_cell"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "io18_cell"] ;
# set_property PACKAGE_PIN AP15      [get_ports "io19_cell"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "io19_cell"] ;

# set_property PACKAGE_PIN BF10     [get_ports "io20_cell"] ;
# set_property IOSTANDARD  LVCMOS18 [get_ports "io20_cell"] ;
set_property PACKAGE_PIN BF9      [get_ports "gpio_4"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_4"] ;

set_property PACKAGE_PIN BE14     [get_ports "gpio_7"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_7"] ;
set_property PACKAGE_PIN BF14      [get_ports "gpio_8"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_8"] ;

set_property PACKAGE_PIN BA14     [get_ports "gpio_14"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_14"] ;
set_property PACKAGE_PIN AM13      [get_ports "gpio_15"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_15"] ;

set_property PACKAGE_PIN AY8     [get_ports "gpio_16"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_16"] ;
set_property PACKAGE_PIN AY7      [get_ports "gpio_17"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_17"] ;

set_property PACKAGE_PIN AR14     [get_ports "gpio_18"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_18"] ;
set_property PACKAGE_PIN AT14      [get_ports "gpio_19"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_19"] ;

set_property PACKAGE_PIN AN16     [get_ports "gpio_20"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_20"] ;
set_property PACKAGE_PIN AP16      [get_ports "gpio_21"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_21"] ;

set_property PACKAGE_PIN AK15     [get_ports "gpio_22"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_22"] ;
set_property PACKAGE_PIN AL15      [get_ports "gpio_23"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_23"] ;

set_property PACKAGE_PIN AY9     [get_ports "gpio_24"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_24"] ;
set_property PACKAGE_PIN BA9      [get_ports "gpio_25"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_25"] ;

set_property PACKAGE_PIN BD12     [get_ports "gpio_26"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_26"] ;
set_property PACKAGE_PIN BE12      [get_ports "gpio_27"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_27"] ;

set_property PACKAGE_PIN BE15     [get_ports "gpio_28"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_28"] ;
set_property PACKAGE_PIN BF15      [get_ports "gpio_29"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_29"] ;

set_property PACKAGE_PIN BC14     [get_ports "gpio_30"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_30"] ;
set_property PACKAGE_PIN BC13      [get_ports "gpio_31"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_31"] ;

set_property PACKAGE_PIN AV9     [get_ports "i2c0_sda"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c0_sda"] ;
set_property PACKAGE_PIN AV8      [get_ports "i2c0_scl"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c0_scl"] ;

set_property PACKAGE_PIN AW11     [get_ports "i2c1_sda"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c1_sda"] ;
set_property PACKAGE_PIN AY10      [get_ports "i2c1_scl"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c1_scl"] ;

set_property PACKAGE_PIN AW13     [get_ports "spi0_mosi"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_mosi"] ;
set_property PACKAGE_PIN AY13      [get_ports "spi0_sclk"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_sclk"] ;

set_property PACKAGE_PIN AT12     [get_ports "spi0_nss"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_nss"] ;
set_property PACKAGE_PIN AU12      [get_ports "spi0_miso"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_miso"] ;

#PMOD J52
#PMOD0_0 (J52.1) CS
set_property PACKAGE_PIN AY14     [get_ports "io17_cell"] ; #CS
set_property IOSTANDARD  LVCMOS18 [get_ports "io17_cell"] ;
set_property PULLDOWN true [get_ports { io17_cell }]; 

#PMOD0_1 (J52.3) MOSI
set_property PACKAGE_PIN AY15      [get_ports "io18_cell"] ;#MOSI
set_property IOSTANDARD  LVCMOS18 [get_ports "io18_cell"] ;
set_property PULLDOWN true [get_ports { io18_cell }]; 

#PMOD0_2 (J52.5) SCK
set_property PACKAGE_PIN AW15     [get_ports "io20_cell"] ;#SCK
set_property IOSTANDARD  LVCMOS18 [get_ports "io20_cell"] ;
set_property PULLDOWN true [get_ports { io20_cell }]; 

#PMOD0_3 (J52.7) MISO
set_property PACKAGE_PIN AV15      [get_ports "io19_cell"] ;#MISO
set_property IOSTANDARD  LVCMOS18 [get_ports "io19_cell"] ;
set_property PULLDOWN true [get_ports { io19_cell }]; 

