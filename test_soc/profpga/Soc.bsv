// See LICENSE.iitm for license details

package Soc;
  // project related imports
  import Semi_FIFOF:: *;
  import AXI4_Types:: *;
  import AXI4_Fabric:: *;
  import AXI4_Lite_Types:: *;
  import AXI4_Lite_Fabric:: *;
  import axi2axil :: * ;
  import ccore:: * ;
  import Clocks :: *;
  import ccore_types::*;
  import GetPut :: * ;
  import Connectable :: * ;
  `include "Soc.defines"
  `define axil_buswidth 32

  // peripheral imports
  import clint::*;
  import err_slave::*;
  import uart_cluster :: * ;
  import spi_cluster :: * ;
  import mixed_cluster :: * ;
  import uart :: *;
  import sspi :: *;
  import csrbox :: * ;
   `ifdef etrace_support
       import instruction_encoder :: * ;
       import EthStream::*;
   `endif
  import bram :: *;
`ifdef debug
  import debug_types::*;     
`endif
  import pinmux::*;
  import pinmux_axi4lite :: * ;                

  import Vector :: *;

  `ifdef simulate
    import sign_dump :: *;
  `endif

  import pipe_ifcs::*;

  function Bit#(TLog#(`Num_Fast_Slaves)) fn_slave_map_fast (Bit#(`paddr) addr);
    Bit#(TLog#(`Num_Fast_Slaves)) slave_num = 0;
    if(addr >= `MemoryBase && addr<= `MemoryEnd)
      slave_num = `Memory_slave_num;
    else if(addr >= `ClintBase && addr <= `ClintEnd)
      slave_num = `Clint_slave_num;
  `ifdef debug
    else if(addr >= `DebugBase && addr <= `DebugEnd)
  `endif
      slave_num = `Debug_slave_num;
    else if(addr >= `BootBase && addr <= `BootEnd)
      slave_num = `Boot_slave_num;
    else if(addr >= `SlowBase && addr <= `SlowEnd)
      slave_num = `Slow_fabric_slave_num;
    else if(addr >= `PLICBase && addr <= `PLICEnd)
      slave_num = `Slow_fabric_slave_num;
    `ifdef simulate
      else if(addr >= `SignBase && addr <= `SignEnd)
        slave_num = `Sign_slave_num;
    `endif
    `ifdef etrace_support 
      else if(addr>= `TraceBase && addr<= `TraceEnd)
        slave_num =  `Trace_slave_num;
      else if(addr >= `MemtraceBase && addr<= `MemtraceEnd)
        slave_num = `Memtrace_slave_num;
    `endif
    else
      slave_num = `FastErr_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map_fast
  
  function Bit#(TLog#(`Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);
    Bit#(TLog#(`Num_Slaves)) slave_num = 0;
    if(addr >= `UARTClusterBase && addr <= `UARTClusterEnd)
      slave_num = `UARTCluster_slave_num;
    else if(addr >= `SPIClusterBase && addr <= `SPIClusterEnd)
      slave_num = `SPICluster_slave_num;
    else if(addr >= `MixedClusterBase && addr <= `MixedClusterEnd)
      slave_num = `MixedCluster_slave_num;
    else if(addr >= `PLICBase && addr <= `PLICEnd)
      slave_num = `MixedCluster_slave_num;
    else if (addr >= `EthBase && addr <= `EthEnd)
      slave_num = `Eth_slave_num;
    else
      slave_num = `Err_slave_num;
      
    return slave_num;
  endfunction:fn_slave_map

  interface Ifc_chip_io;
    interface Ifc_sspi_io spi0_io;
    interface RS232 uart0_io;
    (*always_ready, always_enabled*)
    interface AXI4_Lite_Master_IFC#(`paddr, `axil_buswidth, `USERSPACE) eth_master;
    //interface AXI4_Lite_Slave_IFC#(`paddr, 32, `USERSPACE) to_eth_slave;
    interface AXI4_Master_IFC#(`paddr,  `axi4_id_width, `buswidth, `USERSPACE) mem_master;
    interface IOCellSide iocell_io;
    (*always_ready, always_enabled*)
    method Action ext_interrupts(Bit#(2) i);
   endinterface   

  interface Ifc_soc_sb;
  `ifdef rtldump
    interface Sbread sbread;
    method Maybe#(CommitLogPacket) commitlog;
  `endif
  `ifdef debug
    interface AXI4_Slave_IFC#(`paddr,`axi4_id_width, `buswidth, `USERSPACE) to_debug_master;
    interface AXI4_Master_IFC#(`paddr,`axi4_id_width, `buswidth, `USERSPACE) to_debug_slave;
    method Action ma_hart_interrupts (Bit#(`num_harts) i);
    method Bit#(`num_harts) mv_harts_have_reset;
    method Bit#(`num_harts) mv_core_debugenable;
  `endif
  endinterface


  interface Ifc_Soc;
    interface Ifc_chip_io chip_io;
    interface Ifc_soc_sb soc_sb;
  endinterface

  typedef (TAdd#(TSub#(TMul#(`num_harts,2),1), `ifdef debug 1 `else 0 `endif )) Debug_master_num;
  typedef (TAdd#(Debug_master_num, 1)) Num_Fast_Masters;


  (*synthesize*)
  module mkSoc `ifdef debug #(Vector#(`num_harts, Reset) hartresets ) `endif (Ifc_Soc);
    let curr_clk<-exposeCurrentClock;
    let curr_reset<-exposeCurrentReset;

    Reset core_reset [`num_harts];
    for (Integer i = 0; i<`num_harts; i = i + 1) begin
    `ifdef debug
      core_reset[i]<- mkResetEither(hartresets[i],curr_reset);     // OR default and new_rst
    `else
      core_reset[i] = curr_reset;
    `endif
    end
		
    Ifc_ccore_axi4 ccore <- mkccore_axi4(`resetpc, 0);

    AXI4_Fabric_IFC #(`Num_Fast_Masters, `Num_Fast_Slaves, `paddr,`axi4_id_width, `buswidth, `USERSPACE) 
                                                    fabric <- mkAXI4_Fabric(fn_slave_map_fast);
                                               
    Ifc_clint_axi4#(`paddr,`axi4_id_width, `buswidth, `USERSPACE, 1, 512) clint <- mkclint_axi4();
    Ifc_err_slave_axi4#(`paddr,`axi4_id_width,`buswidth, `USERSPACE) fast_err_slave <- mkerr_slave_axi4;

    AXI4_Lite_Fabric_IFC #(`Num_Masters, `Num_Slaves, `paddr, `axil_buswidth, `USERSPACE) 
                                                        slow_fabric <- mkAXI4_Lite_Fabric(fn_slave_map);

    Ifc_uart_cluster uart_cluster <- mkuart_cluster;
    Ifc_spi_cluster spi_cluster <- mkspi_cluster;
    Ifc_mixed_cluster mixed_cluster <- mkmixed_cluster;
    Ifc_err_slave_axi4lite#(`paddr,`axil_buswidth, `USERSPACE) err_slave <- mkerr_slave_axi4lite;
    Ifc_bram_axi4#(`paddr,`axi4_id_width, `buswidth, `USERSPACE,  15) boot <- mkbram_axi4('h1000, "boot.mem","BOOT");
    `ifdef simulate
      Ifc_sign_dump signature <- mksign_dump();
    `endif
    Wire#(Bit#(2)) wr_ext_interrupts <- mkWire();
   `ifdef etrace_support 
    Ifc_trace_axi4#(`paddr,`axi4_id_width ,`buswidth,`USERSPACE) trace <- mktrace_axi4(`MemtraceBase, `MemtraceEnd);
    Ifc_bram_axi4#(`paddr,`axi4_id_width, `buswidth, `USERSPACE, `Addr_space) main_memory_trace <- mkbram_axi4(`MemtraceBase,
                                                "trace.mem", "TraceMEM");
    Ifc_ethstream ethStream <- mkEthStream;                          
   `endif


  `ifdef debug
    Bit#(`num_harts) lv_haveresets=0;
    Bit#(`num_harts) lv_debugenable=0;
    Wire#(Bit#(`num_harts)) wr_hart_interrupts <- mkWire();
    for (Integer i = 0; i<`num_harts; i = i + 1) begin
      lv_haveresets[i] = ccore.mv_core_is_reset;
      lv_debugenable[i] = ccore.mv_core_debugenable;
      /*doc:rule: */
      rule rl_connect_debug_interrupt;
        ccore.ma_debug_interrupt(wr_hart_interrupts[i]);
      endrule:rl_connect_debug_interrupt
      /*doc:rule: */
      rule rl_connect_available; 
        ccore.ma_debugger_available(1);
      endrule:rl_connect_available
    end
    mkConnection(clint.ma_stop_count,ccore.mv_stop_timer);
  `endif

		//Rule to connect PLIC interrupt to the core's sideband
		rule rl_core_plic_connection;
			ccore.sb_plic_meip(mixed_cluster.sb_ext_interrupt[0]);
		endrule
		rule rl_core_plic_c1_connection;
			ccore.sb_plic_seip(mixed_cluster.sb_ext_interrupt[1]);
		endrule

    rule connect_interrupt_lines;
      mixed_cluster.interrupts({spi_cluster.spi0_sb_interrupt,
                                spi_cluster.spi1_sb_interrupt,
                                wr_ext_interrupts, uart_cluster.uart_interrupts});


    endrule 


      
    // ------------------------------------------------------------------------------------------/
   	mkConnection(ccore.master_d,	fabric.v_from_masters[`Mem_master_num]);
   	mkConnection(ccore.master_i, fabric.v_from_masters[`Fetch_master_num]);
    `ifdef simulate
      mkConnection(signature.master, fabric.v_from_masters[`Sign_master_num]);
    `endif

    `ifdef etrace_support 
       mkConnection (trace.master, fabric.v_from_masters[valueOf(`Trace_master_num) ]); 
       mkConnection(ethStream.master, fabric.v_from_masters[`EthStream_master_num]);
     `endif

  	mkConnection (fabric.v_to_slaves [`Clint_slave_num ],clint.slave);
    mkConnection (fabric.v_to_slaves [`FastErr_slave_num ] , fast_err_slave.slave);
  //`ifdef debug 
    // mkConnection (fabric.v_to_slaves [`Debug_slave_num ] , debug_memory.slave);
  //`endif
    mkConnection (fabric.v_to_slaves [`Slow_fabric_slave_num], slow_fabric.v_from_masters[0]);
    mkConnection (fabric.v_to_slaves [`Boot_slave_num], boot.slave);

    // sideband connection
    mkConnection(ccore.sb_clint_msip,clint.sb_clint_msip);
    mkConnection(ccore.sb_clint_mtip,clint.sb_clint_mtip);
    mkConnection(ccore.sb_clint_mtime,clint.sb_clint_mtime);

    //mkConnection (slow_fabric.v_to_slaves [`PWMCluster_slave_num], pwm_cluster.slave);
    mkConnection (slow_fabric.v_to_slaves [`UARTCluster_slave_num], uart_cluster.slave);
    mkConnection (slow_fabric.v_to_slaves [`SPICluster_slave_num], spi_cluster.slave);
    mkConnection (slow_fabric.v_to_slaves [`MixedCluster_slave_num], mixed_cluster.slave);
    mkConnection (slow_fabric.v_to_slaves [`Err_slave_num ] , err_slave.slave);
    `ifdef simulate
      mkConnection (fabric.v_to_slaves [`Sign_slave_num ] , signature.slave);
    `endif


     `ifdef etrace_support 	
       mkConnection(fabric.v_to_slaves[`Trace_slave_num]   , trace.slave); 
       mkConnection(fabric.v_to_slaves[`Memtrace_slave_num]
       , main_memory_trace.slave);         

       rule ing_in;
       trace.trace_interface(
             zeroExtend(ccore.etrace_ingress_port.itype),
                         ccore.etrace_ingress_port.cause,
                         ccore.etrace_ingress_port.tval,
              zeroExtend(ccore.etrace_ingress_port.priv),
                         ccore.etrace_ingress_port.iaddr,
              zeroExtend(ccore.etrace_ingress_port.iretire),
                       ccore.etrace_ingress_port.ilastsize);  

               /*$display( "in_soc_val:= %d,%d,%h,%d,%h,0,0,%d,%d",
                         ccore[i].etrace_ingress_port.itype,
                         ccore[i].etrace_ingress_port.cause,
                         ccore[i].etrace_ingress_port.tval,
                         ccore[i].etrace_ingress_port.priv,
                         ccore[i].etrace_ingress_port.iaddr,
                         ccore[i].etrace_ingress_port.iretire,
                         ccore[i].etrace_ingress_port.ilastsize  )  ;    */  
       endrule
       
       Reg#(Bool) started <- mkReg(False);
       rule start_stream (!started);
          ethStream.start(`MemoryBase, `MemoryBase + 'h500, 128);
           started <= True;
       endrule
      
       `endif
      
    rule connect_pinmux_peripheral_output_lines;

       mixed_cluster.pinmuxtop_peripheral_side.pwm0.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.pwm1.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.pwm2.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.pwm3.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.pwm4.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.pwm5.out.put(0);
       mixed_cluster.pinmuxtop_peripheral_side.gpioa.out.put(0);
    	 mixed_cluster.pinmuxtop_peripheral_side.gpioa.out_en.put(0);


		   mixed_cluster.pinmuxtop_peripheral_side.mspi.clk_out.put(spi_cluster.spi1_io.sclk_out);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.clk_outen.put(spi_cluster.spi1_io.sclk_outen);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.nss_out.put(spi_cluster.spi1_io.ncs_out0);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.nss_outen.put(spi_cluster.spi1_io.ncs_outen0);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.mosi_out.put(spi_cluster.spi1_io.mosi_out);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.mosi_outen.put(spi_cluster.spi1_io.mosi_outen);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.miso_out.put(spi_cluster.spi1_io.miso_out);
		   mixed_cluster.pinmuxtop_peripheral_side.mspi.miso_outen.put(spi_cluster.spi1_io.miso_outen);

		   mixed_cluster.pinmuxtop_peripheral_side.uart1.tx.put(uart_cluster.uart1_io.sout);
		   mixed_cluster.pinmuxtop_peripheral_side.uart2.tx.put(uart_cluster.uart2_io.sout);
    endrule

    rule connect_pinmux_peripheral_input_lines;
		   let pinmux_gpio_in <- (mixed_cluster.pinmuxtop_peripheral_side.gpioa.in.get);
		   let pinmux_spi1_miso <- mixed_cluster.pinmuxtop_peripheral_side.mspi.miso_in.get;
		   let pinmux_spi1_mosi <- mixed_cluster.pinmuxtop_peripheral_side.mspi.mosi_in.get;
		   let pinmux_spi1_clk <- mixed_cluster.pinmuxtop_peripheral_side.mspi.clk_in.get;
		   let pinmux_spi1_nss <- mixed_cluster.pinmuxtop_peripheral_side.mspi.nss_in.get;
		   spi_cluster.spi1_io.miso_in(pinmux_spi1_miso);
		   spi_cluster.spi1_io.mosi_in(pinmux_spi1_mosi);
		   spi_cluster.spi1_io.sclk_in(pinmux_spi1_clk);
		   spi_cluster.spi1_io.ncs_in0(pinmux_spi1_nss);

		   let pinmux_uart1_rx <- (mixed_cluster.pinmuxtop_peripheral_side.uart1.rx.get);
		   uart_cluster.uart1_io.sin(pinmux_uart1_rx);
		   let pinmux_uart2_rx <- (mixed_cluster.pinmuxtop_peripheral_side.uart2.rx.get);
		   uart_cluster.uart2_io.sin(pinmux_uart2_rx);
    endrule


    interface soc_sb = interface Ifc_soc_sb
    `ifdef rtldump
      interface commitlog= ccore.commitlog;
      interface sbread = ccore.sbread;
    `endif
      interface to_debug_master = fabric.v_from_masters[`Debug_master_num];
      interface to_debug_slave = fabric.v_to_slaves[`Debug_slave_num];
      method Action ma_hart_interrupts (Bit#(`num_harts) i);
        wr_hart_interrupts <= i;
      endmethod
      method mv_harts_have_reset = lv_haveresets;
      method mv_core_debugenable = lv_debugenable;
    endinterface;

  interface chip_io = interface Ifc_chip_io
     interface spi0_io = spi_cluster.spi0_io;
    interface uart0_io = uart_cluster.uart0_io;
    interface iocell_io = mixed_cluster.pinmuxtop_iocell_side;						//GPIO IO interface
    interface eth_master= slow_fabric.v_to_slaves[`Eth_slave_num];
    interface mem_master = fabric.v_to_slaves [`Memory_slave_num];
    method Action ext_interrupts(Bit#(2) i);
      wr_ext_interrupts <= i;
    endmethod
  endinterface;

  endmodule: mkSoc
endpackage: Soc
