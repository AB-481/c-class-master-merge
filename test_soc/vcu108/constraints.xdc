#set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
#set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
#CLOCK
set_property PACKAGE_PIN G22   [get_ports "sys_clk_p"] ;# Bank  50 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_50
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "sys_clk_p"] ;# Bank  50 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_50
set_property PACKAGE_PIN G21    [get_ports "sys_clk_n"] ;# Bank  50 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_50
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "sys_clk_n"] ;# Bank  50 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_50

set_property PACKAGE_PIN G31    [get_ports "c0_sys_clk_p"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_70
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "c0_sys_clk_p"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_70
set_property PACKAGE_PIN F31  [get_ports "c0_sys_clk_n"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_70
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "c0_sys_clk_n"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_70


#RESET
set_property PACKAGE_PIN E36      [get_ports "sys_rst"] ;# Bank  49 VCCO - VCC1V2_FPGA - IO_T1U_N12_49
set_property IOSTANDARD  LVCMOS12 [get_ports "sys_rst"] ;# Bank  49 VCCO - VCC1V2_FPGA - IO_T1U_N12_49

#USB-UART
set_property PACKAGE_PIN BC24     [get_ports "uart_SIN"] ;# Bank  94 VCCO - VCC1V8_FPGA - IO_T0U_N12_94 TX
set_property IOSTANDARD  LVCMOS18 [get_ports "uart_SIN"] ;# Bank  94 VCCO - VCC1V8_FPGA - IO_T0U_N12_94  TX
set_property PACKAGE_PIN BE24     [get_ports "uart_SOUT"] ;# Bank  94 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_94 RX
set_property IOSTANDARD  LVCMOS18 [get_ports "uart_SOUT"] ;# Bank  94 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_94 RX

set_property PACKAGE_PIN E33      [get_ports "c0_ddr4_act_n"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_act_n"]
set_property PACKAGE_PIN C30      [get_ports "c0_ddr4_adr[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[0]"]
set_property PACKAGE_PIN A31      [get_ports "c0_ddr4_adr[10]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[10]"]
set_property PACKAGE_PIN A33      [get_ports "c0_ddr4_adr[11]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[11]"]
set_property PACKAGE_PIN F29      [get_ports "c0_ddr4_adr[12]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[12]"]
set_property PACKAGE_PIN B32      [get_ports "c0_ddr4_adr[13]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[13]"]
set_property PACKAGE_PIN D29      [get_ports "c0_ddr4_adr[14]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[14]"]
set_property PACKAGE_PIN B31      [get_ports "c0_ddr4_adr[15]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[15]"]
set_property PACKAGE_PIN B33      [get_ports "c0_ddr4_adr[16]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[16]"]
set_property PACKAGE_PIN D32      [get_ports "c0_ddr4_adr[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[1]"]
set_property PACKAGE_PIN B30      [get_ports "c0_ddr4_adr[2]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[2]"]
set_property PACKAGE_PIN C33      [get_ports "c0_ddr4_adr[3]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[3]"]
set_property PACKAGE_PIN E32      [get_ports "c0_ddr4_adr[4]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[4]"]
set_property PACKAGE_PIN A29      [get_ports "c0_ddr4_adr[5]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[5]"]
set_property PACKAGE_PIN C29      [get_ports "c0_ddr4_adr[6]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[6]"]
set_property PACKAGE_PIN E29      [get_ports "c0_ddr4_adr[7]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[7]"]
set_property PACKAGE_PIN A30      [get_ports "c0_ddr4_adr[8]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "0_ddr4_adr[8]"]
set_property PACKAGE_PIN C32      [get_ports "c0_ddr4_adr[9]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_adr[9]"]
set_property PACKAGE_PIN G30      [get_ports "c0_ddr4_ba[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_ba[0]"]
set_property PACKAGE_PIN F30      [get_ports "c0_ddr4_ba[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_ba[1]"]
set_property PACKAGE_PIN F33      [get_ports "c0_ddr4_bg[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_bg[0]"]
set_property PACKAGE_PIN D31      [get_ports "c0_ddr4_ck_c[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "c0_ddr4_ck_c[0]"]
set_property PACKAGE_PIN E31      [get_ports "c0_ddr4_ck_t[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN K29      [get_ports "c0_ddr4_cke[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D30      [get_ports "c0_ddr4_cs_n[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN J39      [get_ports "c0_ddr4_dm_dbi_n[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F34      [get_ports "c0_ddr4_dm_dbi_n[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E39      [get_ports "c0_ddr4_dm_dbi_n[2]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D37      [get_ports "c0_ddr4_dm_dbi_n[3]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN T26      [get_ports "c0_ddr4_dm_dbi_n[4]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN M27      [get_ports "c0_ddr4_dm_dbi_n[5]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G26      [get_ports "c0_ddr4_dm_dbi_n[6]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D27      [get_ports "c0_ddr4_dm_dbi_n[7]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]

set_property PACKAGE_PIN J37      [get_ports "c0_ddr4_dq[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F35      [get_ports "c0_ddr4_dq[10]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN J35      [get_ports "c0_ddr4_dq[11]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G37      [get_ports "c0_ddr4_dq[12]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H35      [get_ports "c0_ddr4_dq[13]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G36      [get_ports "c0_ddr4_dq[14]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H37      [get_ports "c0_ddr4_dq[15]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C39      [get_ports "c0_ddr4_dq[16]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A38      [get_ports "c0_ddr4_dq[17]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B40      [get_ports "c0_ddr4_dq[18]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D40      [get_ports "c0_ddr4_dq[19]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H40      [get_ports "c0_ddr4_dq[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E38      [get_ports "c0_ddr4_dq[20]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B38      [get_ports "c0_ddr4_dq[21]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E37      [get_ports "c0_ddr4_dq[22]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C40      [get_ports "c0_ddr4_dq[23]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C34      [get_ports "c0_ddr4_dq[24]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A34      [get_ports "c0_ddr4_dq[25]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D34      [get_ports "c0_ddr4_dq[26]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A35      [get_ports "c0_ddr4_dq[27]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A36      [get_ports "c0_ddr4_dq[28]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C35      [get_ports "c0_ddr4_dq[29]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F38      [get_ports "c0_ddr4_dq[2]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B35      [get_ports "c0_ddr4_dq[30]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D35      [get_ports "c0_ddr4_dq[31]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN N27      [get_ports "c0_ddr4_dq[32]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN R27      [get_ports "c0_ddr4_dq[33]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN N24      [get_ports "c0_ddr4_dq[34]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN R24      [get_ports "c0_ddr4_dq[35]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN P24      [get_ports "c0_ddr4_dq[36]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN P26      [get_ports "c0_ddr4_dq[37]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN P27      [get_ports "c0_ddr4_dq[38]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN T24      [get_ports "c0_ddr4_dq[39]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H39      [get_ports "c0_ddr4_dq[3]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN K27      [get_ports "c0_ddr4_dq[40]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN L26      [get_ports "c0_ddr4_dq[41]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN J27      [get_ports "c0_ddr4_dq[42]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN K28      [get_ports "c0_ddr4_dq[43]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN K26      [get_ports "c0_ddr4_dq[44]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN M25      [get_ports "c0_ddr4_dq[45]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN J26      [get_ports "c0_ddr4_dq[46]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN L28      [get_ports "c0_ddr4_dq[47]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E27      [get_ports "c0_ddr4_dq[48]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E28      [get_ports "c0_ddr4_dq[49]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN K37      [get_ports "c0_ddr4_dq[4]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN E26      [get_ports "c0_ddr4_dq[50]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H27      [get_ports "c0_ddr4_dq[51]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F25      [get_ports "c0_ddr4_dq[52]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F28      [get_ports "c0_ddr4_dq[53]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G25      [get_ports "c0_ddr4_dq[54]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G27      [get_ports "c0_ddr4_dq[55]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B28      [get_ports "c0_ddr4_dq[56]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A28      [get_ports "c0_ddr4_dq[57]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B25      [get_ports "c0_ddr4_dq[58]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B27      [get_ports "c0_ddr4_dq[59]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G40      [get_ports "c0_ddr4_dq[5]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D25      [get_ports "c0_ddr4_dq[60]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C27      [get_ports "c0_ddr4_dq[61]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN C25      [get_ports "c0_ddr4_dq[62]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN D26      [get_ports "c0_ddr4_dq[63]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]

set_property PACKAGE_PIN F39      [get_ports "c0_ddr4_dq[6]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F40      [get_ports "c0_ddr4_dq[7]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN F36      [get_ports "c0_ddr4_dq[8]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN J36      [get_ports "c0_ddr4_dq[9]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G38      [get_ports "c0_ddr4_dqs_c[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G35      [get_ports "c0_ddr4_dqs_c[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A40      [get_ports "c0_ddr4_dqs_c[2]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B37      [get_ports "c0_ddr4_dqs_c[3]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN N25      [get_ports "c0_ddr4_dqs_c[4]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN L25      [get_ports "c0_ddr4_dqs_c[5]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN G28      [get_ports "c0_ddr4_dqs_c[6]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A26      [get_ports "c0_ddr4_dqs_c[7]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]

set_property PACKAGE_PIN H38      [get_ports "c0_ddr4_dqs_t[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H34      [get_ports "c0_ddr4_dqs_t[1]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN A39      [get_ports "c0_ddr4_dqs_t[2]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B36      [get_ports "c0_ddr4_dqs_t[3]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN P25      [get_ports "c0_ddr4_dqs_t[4]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN L24      [get_ports "c0_ddr4_dqs_t[5]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN H28      [get_ports "c0_ddr4_dqs_t[6]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN B26      [get_ports "c0_ddr4_dqs_t[7]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]

set_property PACKAGE_PIN J31      [get_ports "c0_ddr4_odt[0]"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]
set_property PACKAGE_PIN M28      [get_ports "c0_ddr4_reset_n"] ;
#set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "uart_SOUT"]

#FMC
set_property PACKAGE_PIN BE10     [get_ports "io7_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io7_cell"] ;
set_property PACKAGE_PIN BE9      [get_ports "io8_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io8_cell"] ;

set_property PACKAGE_PIN BE14     [get_ports "io9_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io9_cell"] ;
set_property PACKAGE_PIN BF14      [get_ports "io10_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io10_cell"] ;

set_property PACKAGE_PIN BB13     [get_ports "io12_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io12_cell"] ;
set_property PACKAGE_PIN BB12      [get_ports "io13_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io13_cell"] ;

set_property PACKAGE_PIN AP13     [get_ports "io16_cell"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "io16_cell"] ;
#set_property PACKAGE_PIN AR13      [get_ports "io17_cell"] ;
#set_property IOSTANDARD  LVCMOS18 [get_ports "io17_cell"] ;

#set_property PACKAGE_PIN AN14     [get_ports "io18_cell"] ;
#set_property IOSTANDARD  LVCMOS18 [get_ports "io18_cell"] ;
#set_property PACKAGE_PIN AN13      [get_ports "io19_cell"] ;
#set_property IOSTANDARD  LVCMOS18 [get_ports "io19_cell"] ;

#set_property PACKAGE_PIN BC10     [get_ports "io20_cell"] ;
#set_property IOSTANDARD  LVCMOS18 [get_ports "io20_cell"] ;
set_property PACKAGE_PIN BD10      [get_ports "gpio_4"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_4"] ;

set_property PACKAGE_PIN BF12     [get_ports "gpio_7"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_7"] ;
set_property PACKAGE_PIN BF11      [get_ports "gpio_8"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_8"] ;

set_property PACKAGE_PIN BD13     [get_ports "gpio_14"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_14"] ;
set_property PACKAGE_PIN BE13      [get_ports "gpio_15"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_15"] ;

set_property PACKAGE_PIN BA14     [get_ports "gpio_16"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_16"] ;
set_property PACKAGE_PIN BB14      [get_ports "gpio_17"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_17"] ;

set_property PACKAGE_PIN AV14     [get_ports "gpio_18"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_18"] ;
set_property PACKAGE_PIN AV13      [get_ports "gpio_19"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_19"] ;

set_property PACKAGE_PIN AT16     [get_ports "gpio_20"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_20"] ;
set_property PACKAGE_PIN AT15      [get_ports "gpio_21"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_21"] ;

set_property PACKAGE_PIN AL14     [get_ports "gpio_22"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_22"] ;
set_property PACKAGE_PIN AM14      [get_ports "gpio_23"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_23"] ;

set_property PACKAGE_PIN AY9     [get_ports "gpio_24"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_24"] ;
set_property PACKAGE_PIN BA9      [get_ports "gpio_25"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_25"] ;

set_property PACKAGE_PIN BD8     [get_ports "gpio_26"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_26"] ;
set_property PACKAGE_PIN BD7      [get_ports "gpio_27"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_27"] ;

set_property PACKAGE_PIN BF10     [get_ports "gpio_28"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_28"] ;
set_property PACKAGE_PIN BF9      [get_ports "gpio_29"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_29"] ;

set_property PACKAGE_PIN BE15     [get_ports "gpio_30"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_30"] ;
set_property PACKAGE_PIN BF15      [get_ports "gpio_31"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "gpio_31"] ;

set_property PACKAGE_PIN AY8     [get_ports "i2c0_sda"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c0_sda"] ;
set_property PACKAGE_PIN AY7      [get_ports "i2c0_scl"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c0_scl"] ;

set_property PACKAGE_PIN AY15     [get_ports "i2c1_sda"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c1_sda"] ;
set_property PACKAGE_PIN AY14      [get_ports "i2c1_scl"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "i2c1_scl"] ;

set_property PACKAGE_PIN AN15     [get_ports "spi0_mosi"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_mosi"] ;
set_property PACKAGE_PIN AP15      [get_ports "spi0_sclk"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_sclk"] ;

set_property PACKAGE_PIN AM13     [get_ports "spi0_nss"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_nss"] ;
set_property PACKAGE_PIN AM12      [get_ports "spi0_miso"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "spi0_miso"] ;

#PMOD J52
#PMOD0_0 (J52.1) CS
set_property PACKAGE_PIN BC14     [get_ports "io17_cell"] ; #CS
set_property IOSTANDARD  LVCMOS18 [get_ports "io17_cell"] ;
set_property PULLUP true [get_ports { io17_cell }]; 

#PMOD0_1 (J52.3) MOSI
set_property PACKAGE_PIN BA10      [get_ports "io18_cell"] ;#MOSI
set_property IOSTANDARD  LVCMOS18 [get_ports "io18_cell"] ;
set_property PULLUP true [get_ports { io18_cell }]; 

#PMOD0_2 (J52.5) SCK
set_property PACKAGE_PIN AW16     [get_ports "io20_cell"] ;#SCK
set_property IOSTANDARD  LVCMOS18 [get_ports "io20_cell"] ;
set_property PULLUP true [get_ports { io20_cell }]; 

#PMOD0_3 (J52.7) MISO
set_property PACKAGE_PIN BB16      [get_ports "io19_cell"] ;#MISO
set_property IOSTANDARD  LVCMOS18 [get_ports "io19_cell"] ;
set_property PULLUP true [get_ports { io19_cell }]; 

