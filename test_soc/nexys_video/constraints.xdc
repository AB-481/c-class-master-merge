## Clock Signal
#set_property -dict { PACKAGE_PIN R4    IOSTANDARD LVCMOS33 } [get_ports { sys_clk }]; #IO_L13P_T2_MRCC_34 Sch=sysclk
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sys_clk]

set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS15 } [get_ports { sys_rst }]; #IO_L12N_T1_MRCC_35 Sch=cpu_resetn

### UART
set_property -dict { PACKAGE_PIN AA19  IOSTANDARD LVCMOS33 } [get_ports { uart0_SOUT }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=uart_rx_out
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { uart0_SIN }]; #IO_L14P_T2_SRCC_14 Sch=uart_tx_in# set_property -dict {PACKAGE_PIN AD20 IOSTANDARD LVCMOS18} [get_ports CLK];

### Pmod header JA
set_property -dict { PACKAGE_PIN AB22  IOSTANDARD LVCMOS33 } [get_ports { i2c0_sda }]; #IO_L10N_T1_D15_14 Sch=ja[1]
set_property -dict { PACKAGE_PIN AB21  IOSTANDARD LVCMOS33 } [get_ports { i2c0_scl }]; #IO_L10P_T1_D14_14 Sch=ja[2]
set_property -dict { PACKAGE_PIN AB20  IOSTANDARD LVCMOS33 } [get_ports { i2c1_sda }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=ja[3]
set_property -dict { PACKAGE_PIN AB18  IOSTANDARD LVCMOS33 } [get_ports { i2c1_scl }]; #IO_L17N_T2_A13_D29_14 Sch=ja[4]

set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports { spi0_mosi }]; #IO_L9P_T1_DQS_14 Sch=ja[7]
set_property -dict { PACKAGE_PIN AA21  IOSTANDARD LVCMOS33 } [get_ports { spi0_sclk }]; #IO_L8N_T1_D12_14 Sch=ja[8]
set_property -dict { PACKAGE_PIN AA20  IOSTANDARD LVCMOS33 } [get_ports { spi0_nss} ]; #IO_L8P_T1_D11_14 Sch=ja[9]
set_property -dict { PACKAGE_PIN AA18  IOSTANDARD LVCMOS33 } [get_ports { spi0_miso }]; #IO_L17P_T2_A14_D30_14 Sch=ja[10]


# ## Pmod header JB
set_property -dict { PACKAGE_PIN V9    IOSTANDARD LVCMOS33 } [get_ports { io10_cell }]; #IO_L21P_T3_DQS_34 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports { io12_cell }]; #IO_L21N_T3_DQS_34 Sch=jb_n[1]
set_property -dict { PACKAGE_PIN V7    IOSTANDARD LVCMOS33 } [get_ports { io13_cell }]; #IO_L19P_T3_34 Sch=jb_p[2]
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports { io16_cell }]; #IO_L19N_T3_VREF_34 Sch=jb_n[2]
set_property -dict { PACKAGE_PIN W9    IOSTANDARD LVCMOS33 } [get_ports { io7_cell }]; #IO_L24P_T3_34 Sch=jb_p[3]
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { io8_cell }]; #IO_L24N_T3_34 Sch=jb_n[3]
set_property -dict { PACKAGE_PIN Y8    IOSTANDARD LVCMOS33 } [get_ports { io9_cell }]; #IO_L23P_T3_34 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN Y7    IOSTANDARD LVCMOS33 } [get_ports { io17_cell }]; #IO_L23N_T3_34 Sch=jb_n[4]

## OLED Display
#set_property -dict { PACKAGE_PIN W22   IOSTANDARD LVCMOS33 } [get_ports { io10_cell }]; #IO_L7N_T1_D10_14 Sch=oled_dc
#set_property -dict { PACKAGE_PIN U21   IOSTANDARD LVCMOS33 } [get_ports { io7_cell }]; #IO_L4N_T0_D05_14 Sch=oled_res
#set_property PULLUP true [get_ports { io7_cell }];
#set_property -dict { PACKAGE_PIN W21   IOSTANDARD LVCMOS33 } [get_ports { spi0_sclk }]; #IO_L7P_T1_D09_14 Sch=oled_sclk
#set_property -dict { PACKAGE_PIN Y22   IOSTANDARD LVCMOS33 } [get_ports { spi0_mosi }]; #IO_L9N_T1_DQS_D13_14 Sch=oled_sdin
#set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { io8_cell }]; #IO_0_14 Sch=oled_vbat
#set_property PULLUP true [get_ports { io8_cell }];
#set_property -dict { PACKAGE_PIN V22   IOSTANDARD LVCMOS33 } [get_ports { io9_cell }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=oled_vdd
#set_property PULLUP true [get_ports { io9_cell }];

#### Pmod header JC
#set_property -dict { PACKAGE_PIN Y6    IOSTANDARD LVCMOS33 } [get_ports { io18_cell }]; #IO_L18P_T2_34 Sch=jc_p[1]
#set_property -dict { PACKAGE_PIN AA6   IOSTANDARD LVCMOS33 } [get_ports { io19_cell }]; #IO_L18N_T2_34 Sch=jc_n[1]
#set_property -dict { PACKAGE_PIN AA8   IOSTANDARD LVCMOS33 } [get_ports { io20_cell }]; #IO_L22P_T3_34 Sch=jc_p[2]

set_property -dict { PACKAGE_PIN AB8   IOSTANDARD LVCMOS33 } [get_ports { gpio_4 }]; #IO_L22N_T3_34 Sch=jc_n[2]
set_property PULLDOWN true [get_ports { gpio_4 }]; 
set_property -dict { PACKAGE_PIN R6    IOSTANDARD LVCMOS33 } [get_ports { gpio_7 }]; #IO_L17P_T2_34 Sch=jc_p[3]
set_property PULLDOWN true [get_ports { gpio_7 }]; 
set_property -dict { PACKAGE_PIN T6    IOSTANDARD LVCMOS33 } [get_ports { gpio_8 }]; #IO_L17N_T2_34 Sch=jc_n[3]
set_property PULLDOWN true [get_ports { gpio_8 }]; 
set_property -dict { PACKAGE_PIN AB7   IOSTANDARD LVCMOS33 } [get_ports { gpio_14 }]; #IO_L20P_T3_34 Sch=jc_p[4]
set_property PULLDOWN true [get_ports { gpio_14 }]; 
set_property -dict { PACKAGE_PIN AB6   IOSTANDARD LVCMOS33 } [get_ports { gpio_15 }]; #IO_L20N_T3_34 Sch=jc_n[4]
set_property PULLDOWN true [get_ports { gpio_15 }]; 

    
### LEDs
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS25 } [get_ports { gpio_16 }]; #IO_L15P_T2_DQS_13 Sch=led[0]
set_property PULLDOWN true [get_ports { gpio_16 }]; 
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS25 } [get_ports { gpio_17 }]; #IO_L15N_T2_DQS_13 Sch=led[1]
set_property PULLDOWN true [get_ports { gpio_17 }]; 
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS25 } [get_ports { gpio_18 }]; #IO_L17P_T2_13 Sch=led[2]
set_property PULLDOWN true [get_ports { gpio_18 }]; 
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS25 } [get_ports { gpio_19 }]; #IO_L17N_T2_13 Sch=led[3]
set_property PULLDOWN true [get_ports { gpio_19 }]; 
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS25 } [get_ports { gpio_20 }]; #IO_L14N_T2_SRCC_13 Sch=led[4]
set_property PULLDOWN true [get_ports { gpio_20 }]; 
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS25 } [get_ports { gpio_21 }]; #IO_L16N_T2_13 Sch=led[5]
set_property PULLDOWN true [get_ports { gpio_21 }]; 
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS25 } [get_ports { gpio_22 }]; #IO_L16P_T2_13 Sch=led[6]
set_property PULLDOWN true [get_ports { gpio_22 }]; 
set_property -dict { PACKAGE_PIN Y13   IOSTANDARD LVCMOS25 } [get_ports { gpio_23 }]; #IO_L5P_T0_13 Sch=led[7]
set_property PULLDOWN true [get_ports { gpio_23 }]; 



## FMC
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS12 } [get_ports { gpio_24 }]; #IO_L16N_T2_A27_15 Sch=fmc_la_n[02]
set_property PULLDOWN true [get_ports { gpio_24 }]; 
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS12 } [get_ports { gpio_25 }]; #IO_L16P_T2_A28_15 Sch=fmc_la_p[02]
set_property PULLDOWN true [get_ports { gpio_25 }]; 
set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS12 } [get_ports { gpio_26 }]; #IO_L17N_T2_A25_15 Sch=fmc_la_n[03]
set_property PULLDOWN true [get_ports { gpio_26 }]; 
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS12 } [get_ports { gpio_27 }]; #IO_L17P_T2_A26_15 Sch=fmc_la_p[03]
set_property PULLDOWN true [get_ports { gpio_27 }]; 
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS12 } [get_ports { gpio_28 }]; #IO_L18N_T2_A23_15 Sch=fmc_la_n[04]
set_property PULLDOWN true [get_ports { gpio_28 }]; 
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS12 } [get_ports { gpio_29 }]; #IO_L18P_T2_A24_15 Sch=fmc_la_p[04]
set_property PULLDOWN true [get_ports { gpio_29 }]; 
set_property -dict { PACKAGE_PIN L21   IOSTANDARD LVCMOS12 } [get_ports { gpio_30 }]; #IO_L10N_T1_AD11N_15 Sch=fmc_la_n[05]
set_property PULLDOWN true [get_ports { gpio_30 }]; 
set_property -dict { PACKAGE_PIN M21   IOSTANDARD LVCMOS12 } [get_ports { gpio_31 }]; #IO_L10P_T1_AD11P_15 Sch=fmc_la_p[05]
set_property PULLDOWN true [get_ports { gpio_31 }]; 

#set_property -dict { PACKAGE_PIN M22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[06] }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=fmc_la_n[06]
#set_property -dict { PACKAGE_PIN N22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[06] }]; #IO_L15P_T2_DQS_15 Sch=fmc_la_p[06]
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[07] }]; #IO_L20N_T3_A19_15 Sch=fmc_la_n[07]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[07] }]; #IO_L20P_T3_A20_15 Sch=fmc_la_p[07]
#set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[08] }]; #IO_L24N_T3_RS0_15 Sch=fmc_la_n[08]
#set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[08] }]; #IO_L24P_T3_RS1_15 Sch=fmc_la_p[08]
#set_property -dict { PACKAGE_PIN G20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[09] }]; #IO_L8N_T1_AD10N_15 Sch=fmc_la_n[09]
#set_property -dict { PACKAGE_PIN H20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[09] }]; #IO_L8P_T1_AD10P_15 Sch=fmc_la_p[09]
#set_property -dict { PACKAGE_PIN K22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[10] }]; #IO_L9N_T1_DQS_AD3N_15 Sch=fmc_la_n[10]
#set_property -dict { PACKAGE_PIN K21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[10] }]; #IO_L9P_T1_DQS_AD3P_15 Sch=fmc_la_p[10]


# SD card
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { io20_cell }]; #IO_L12P_T1_MRCC_14 Sch=sd_cclk
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { sd_cd }]; #IO_L20N_T3_A07_D23_14 Sch=sd_cd
set_property -dict { PACKAGE_PIN W20   IOSTANDARD LVCMOS33 } [get_ports { io18_cell }]; #IO_L12N_T1_MRCC_14 Sch=sd_cmd
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { io19_cell }]; #IO_L14N_T2_SRCC_14 Sch=sd_d[0]
#set_property -dict { PACKAGE_PIN T21   IOSTANDARD LVCMOS33 } [get_ports { sd_d[1] }]; #IO_L4P_T0_D04_14 Sch=sd_d[1]
#set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { sd_d[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sd_d[2]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { io17_cell }]; #IO_L18N_T2_A11_D27_14 Sch=sd_d[3]
#set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { sd_reset }]; #IO_L11N_T1_SRCC_14 Sch=sd_reset
