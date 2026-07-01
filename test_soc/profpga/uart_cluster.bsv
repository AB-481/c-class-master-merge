// See LICENSE.iitm for license details

package uart_cluster;
	import AXI4_Lite_Types:: *;
	import AXI4_Lite_Fabric:: *;
  import uart::*;
  import err_slave::*;
  import Connectable:: *;
  import GetPut:: *;
  
  `include "Soc.defines"
  `define axil_buswidth 32

  function Bit#(TLog#(`UARTCluster_Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);
    Bool slave_exist = True;
    Bit#(TLog#(`UARTCluster_Num_Slaves)) slave_num = 0;
    if(     addr>= `UART0Base && addr<= `UART0End )
      slave_num =  `UART0_slave_num;
    else if(addr>= `UART1Base && addr<= `UART1End )
      slave_num =  `UART1_slave_num;
    else if(addr>= `UART2Base && addr<= `UART2End )
      slave_num =  `UART2_slave_num;
    else
      slave_num = `UARTCluster_err_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map

  interface Ifc_uart_cluster;
    interface RS232 uart0_io;
    interface RS232 uart1_io;
    interface RS232 uart2_io;
    interface AXI4_Lite_Slave_IFC#(`paddr, `axil_buswidth, `USERSPACE) slave;
    method Bit#(3) uart_interrupts;
  endinterface

  (*synthesize*)
  module mkuart(Ifc_uart_axi4lite#(`paddr, `axil_buswidth, `USERSPACE, 16));
	  let core_clock<-exposeCurrentClock;
  	let core_reset<-exposeCurrentReset;
    let ifc();
    `ifdef simulate
      mkuart_axi4lite#(core_clock, core_reset, 5, `USERSPACE, 0) _temp(ifc);
    `else
        mkuart_axi4lite#(core_clock, core_reset, 163, `USERSPACE, 0) _temp(ifc);
    `endif
    return ifc;
  endmodule

  (*synthesize*)
  module mkuart_cluster(Ifc_uart_cluster);
    let curr_clk<- exposeCurrentClock;
    let curr_reset <- exposeCurrentReset;
		AXI4_Lite_Master_Xactor_IFC #(`paddr, `axil_buswidth, `USERSPACE) c2m_xactor <- mkAXI4_Lite_Master_Xactor;
		AXI4_Lite_Slave_Xactor_IFC #(`paddr, `axil_buswidth, `USERSPACE) c2s_xactor <- mkAXI4_Lite_Slave_Xactor;
    AXI4_Lite_Fabric_IFC #(`UARTCluster_Num_Masters, `UARTCluster_Num_Slaves, `paddr, `axil_buswidth, `USERSPACE) 
                                                    fabric <- mkAXI4_Lite_Fabric(fn_slave_map);
    let uart0 <- mkuart();
    let uart1 <- mkuart();
    let uart2 <- mkuart();
    Ifc_err_slave_axi4lite#(`paddr, `axil_buswidth, `USERSPACE ) err_slave <- mkerr_slave_axi4lite;
   	
   	mkConnection(c2m_xactor.axi_side, fabric.v_from_masters[0]);

    mkConnection(c2s_xactor.o_wr_addr,c2m_xactor.i_wr_addr);
    mkConnection(c2s_xactor.o_wr_data,c2m_xactor.i_wr_data);
    mkConnection(c2m_xactor.o_wr_resp,c2s_xactor.i_wr_resp);
    mkConnection(c2s_xactor.o_rd_addr,c2m_xactor.i_rd_addr);
    mkConnection(c2m_xactor.o_rd_data,c2s_xactor.i_rd_data);
		
 	  mkConnection (fabric.v_to_slaves [`UART0_slave_num ],uart0.slave);
 	  mkConnection (fabric.v_to_slaves [`UART1_slave_num ],uart1.slave);
 	  mkConnection (fabric.v_to_slaves [`UART2_slave_num ],uart2.slave);
    mkConnection (fabric.v_to_slaves [`UARTCluster_err_slave_num ] , err_slave.slave);

    interface uart0_io=uart0.io;
    interface uart1_io=uart1.io;
    interface uart2_io=uart2.io;
    interface slave= c2s_xactor.axi_side;
		method Bit#(3) uart_interrupts;
			return {1'b0, uart1.interrupt, uart0.interrupt};
			//return {uart2.interrupt, uart1.interrupt, uart0.interrupt};
		endmethod
  endmodule
endpackage

