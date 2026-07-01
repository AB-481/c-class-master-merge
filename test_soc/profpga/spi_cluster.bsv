// See LICENSE.iitm for license details

package spi_cluster;
	import AXI4_Lite_Types:: *;
	import AXI4_Lite_Fabric:: *;
  import sspi::*;
  import err_slave::*;
  import Connectable:: *;
  import GetPut:: *;
  
  `include "Soc.defines"
  `define axil_buswidth 32

  function Bit#(TLog#(`SPICluster_Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);
    Bool slave_exist = True;
    Bit#(TLog#(`SPICluster_Num_Slaves)) slave_num = 0;
    if(     addr>= `SPI0Base && addr<= `SPI0End )
      slave_num =  `SPI0_slave_num;
    else if(addr>= `SPI1Base && addr<= `SPI1End )
      slave_num =  `SPI1_slave_num;
    /*else if(addr>= `SPI2Base && addr<= `SPI2End )
      slave_num =  `SPI2_slave_num;*/
    else
      slave_num = `SPICluster_err_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map

  interface Ifc_spi_cluster;
    interface Ifc_sspi_io spi0_io;
    interface Ifc_sspi_io spi1_io;
//    interface Ifc_sspi_io spi2_io;
    (*always_ready, always_enabled*)
    method Bit#(1) spi0_sb_interrupt;
    (*always_ready, always_enabled*)
    method Bit#(1) spi1_sb_interrupt;
    interface AXI4_Lite_Slave_IFC#(`paddr, `axil_buswidth, `USERSPACE) slave;
  endinterface

  (*synthesize*)
  module mkspi(Ifc_sspi_axi4lite#(`paddr, `axil_buswidth, `USERSPACE));
    let ifc();
    mksspi_axi4lite _temp(ifc);
    return ifc;
  endmodule

  (*synthesize*)
  module mkspi_cluster(Ifc_spi_cluster);
    let curr_clk<- exposeCurrentClock;
    let curr_reset <- exposeCurrentReset;
		AXI4_Lite_Master_Xactor_IFC #(`paddr, `axil_buswidth, `USERSPACE) c2m_xactor <- mkAXI4_Lite_Master_Xactor;
		AXI4_Lite_Slave_Xactor_IFC #(`paddr, `axil_buswidth, `USERSPACE) c2s_xactor <- mkAXI4_Lite_Slave_Xactor;
    AXI4_Lite_Fabric_IFC #(`SPICluster_Num_Masters, `SPICluster_Num_Slaves, `paddr, `axil_buswidth, `USERSPACE) 
                                                    fabric <- mkAXI4_Lite_Fabric(fn_slave_map);
    let spi0 <- mkspi();
    let spi1 <- mkspi();
//    let spi2 <- mkspi();
    Ifc_err_slave_axi4lite#(`paddr, `axil_buswidth, `USERSPACE ) err_slave <- mkerr_slave_axi4lite;
   	
   	mkConnection(c2m_xactor.axi_side, fabric.v_from_masters[0]);

    mkConnection(c2s_xactor.o_wr_addr,c2m_xactor.i_wr_addr);
    mkConnection(c2s_xactor.o_wr_data,c2m_xactor.i_wr_data);
    mkConnection(c2m_xactor.o_wr_resp,c2s_xactor.i_wr_resp);
    mkConnection(c2s_xactor.o_rd_addr,c2m_xactor.i_rd_addr);
    mkConnection(c2m_xactor.o_rd_data,c2s_xactor.i_rd_data);
		
 	  mkConnection (fabric.v_to_slaves [`SPI0_slave_num ],spi0.slave);
 	  mkConnection (fabric.v_to_slaves [`SPI1_slave_num ],spi1.slave);
// 	  mkConnection (fabric.v_to_slaves [`SPI2_slave_num ],spi2.slave);
    mkConnection (fabric.v_to_slaves [`SPICluster_err_slave_num ] , err_slave.slave);

    interface spi0_io=spi0.io;
    interface spi1_io=spi1.io;
    method spi0_sb_interrupt = spi0.sb_sspi_interrupt;
    method spi1_sb_interrupt = spi1.sb_sspi_interrupt;
//    interface spi2_io=spi2.io;
    interface slave= c2s_xactor.axi_side;
  endmodule
endpackage

