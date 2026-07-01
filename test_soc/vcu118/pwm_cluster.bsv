// See LICENSE.iitm for license details

package pwm_cluster;
	import AXI4_Lite_Types:: *;
	import AXI4_Lite_Fabric:: *;
  import pwm::*;
  import err_slave::*;
  import Connectable:: *;
  import GetPut:: *;
  
  `include "Soc.defines"

  function Bit#(TLog#(`PWMCluster_Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);
    Bool slave_exist = True;
    Bit#(TLog#(`PWMCluster_Num_Slaves)) slave_num = 0;
    if(     addr>= `PWM0Base && addr<= `PWM0End )
      slave_num =  `PWM0_slave_num;
    else
      slave_num = `PWMCluster_err_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map

  interface Ifc_pwm_cluster;
    method Bit#(1) pwm0_io;
    method Bit#(1) pwm1_io;
    method Bit#(1) pwm2_io;
    method Bit#(1) pwm3_io;
    method Bit#(1) pwm4_io;
    method Bit#(1) pwm5_io;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm0_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm1_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm2_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm3_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm4_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) pwm5_sb_interrupt;
    interface AXI4_Lite_Slave_IFC#(`paddr, `buswidth, `USERSPACE) slave;
  endinterface

  (*synthesize*)
  module mkpwm(Ifc_pwm_axi4lite#(`paddr, `buswidth, `USERSPACE, 32, 6));
	  let core_clock<-exposeCurrentClock;
  	let core_reset<-exposeCurrentReset;
    let ifc();
    mkpwm_axi4lite#(core_clock, core_reset) _temp(ifc);
    return ifc;
  endmodule

  (*synthesize*)
  module mkpwm_cluster(Ifc_pwm_cluster);
    let curr_clk<- exposeCurrentClock;
    let curr_reset <- exposeCurrentReset;
		AXI4_Lite_Master_Xactor_IFC #(`paddr, `buswidth, `USERSPACE) c2m_xactor <- mkAXI4_Lite_Master_Xactor;
		AXI4_Lite_Slave_Xactor_IFC #(`paddr, `buswidth, `USERSPACE) c2s_xactor <- mkAXI4_Lite_Slave_Xactor;
    AXI4_Lite_Fabric_IFC #(`PWMCluster_Num_Masters, `PWMCluster_Num_Slaves, `paddr, `buswidth, `USERSPACE) 
                                                    fabric <- mkAXI4_Lite_Fabric(fn_slave_map);
    let pwm0 <- mkpwm();
    Ifc_err_slave_axi4lite#(`paddr, `buswidth, `USERSPACE ) err_slave <- mkerr_slave_axi4lite;
   	
   	mkConnection(c2m_xactor.axi_side, fabric.v_from_masters[0]);

    mkConnection(c2s_xactor.o_wr_addr,c2m_xactor.i_wr_addr);
    mkConnection(c2s_xactor.o_wr_data,c2m_xactor.i_wr_data);
    mkConnection(c2m_xactor.o_wr_resp,c2s_xactor.i_wr_resp);
    mkConnection(c2s_xactor.o_rd_addr,c2m_xactor.i_rd_addr);
    mkConnection(c2m_xactor.o_rd_data,c2s_xactor.i_rd_data);
		
 	  mkConnection (fabric.v_to_slaves [`PWM0_slave_num ],pwm0.slave);
    mkConnection (fabric.v_to_slaves [`PWMCluster_err_slave_num ] , err_slave.slave);

    method pwm0_io=pwm0.io.pwm_o[0];
    method pwm1_io=pwm0.io.pwm_o[1];
    method pwm2_io=pwm0.io.pwm_o[2];
    method pwm3_io=pwm0.io.pwm_o[3];
    method pwm4_io=pwm0.io.pwm_o[4];
    method pwm5_io=pwm0.io.pwm_o[5];
    method pwm0_sb_interrupt=pwm0.sb_interrupt[0];
    method pwm1_sb_interrupt=pwm0.sb_interrupt[1];
    method pwm2_sb_interrupt=pwm0.sb_interrupt[2];
    method pwm3_sb_interrupt=pwm0.sb_interrupt[3];
    method pwm4_sb_interrupt=pwm0.sb_interrupt[4];
    method pwm5_sb_interrupt=pwm0.sb_interrupt[5];
    interface slave= c2s_xactor.axi_side;
  endmodule
endpackage

