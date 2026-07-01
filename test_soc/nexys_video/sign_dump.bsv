// See LICENSE.iitm for license details

package sign_dump;
  import Vector::*;
  import FIFOF::*;
  import DReg::*;
  import SpecialFIFOs::*;
  import BRAMCore::*;
  import FIFO::*;

  import ccore_types::*;
  `include "ccore_params.defines"
	import AXI4_Types:: *;
	import AXI4_Fabric:: *;
	import Semi_FIFOF:: *;

  interface Ifc_sign_dump;
		interface AXI4_Master_IFC#(`paddr, `buswidth, `USERSPACE) master;
		interface AXI4_Slave_IFC#(`paddr, `buswidth, `USERSPACE) slave;
  endinterface

  (*synthesize*)
  module mksign_dump(Ifc_sign_dump);
    let word_count = 128/valueOf(`buswidth);

    Reg#(Bool) rg_start<- mkReg(False);
    Reg#(Bit#(TLog#(TDiv#(128,`buswidth)))) rg_word_count <- mkReg(fromInteger(word_count-1));
    Reg#(Bit#(`paddr)) rg_total_count <- mkReg(0);
		AXI4_Master_Xactor_IFC #(`paddr, `buswidth, `USERSPACE) m_xactor <- mkAXI4_Master_Xactor;
		AXI4_Slave_Xactor_IFC #(`paddr, `buswidth, `USERSPACE) s_xactor <- mkAXI4_Slave_Xactor;
    
    FIFOF#(Bit#(TLog#(TDiv#(`buswidth,8)))) ff_lower_order_bits <- mkSizedFIFOF(8);

    Reg#(Bit#(`paddr)) rg_start_address<- mkReg(0);    // 0x2000
    Reg#(Bit#(`paddr)) rg_end_address<- mkReg(0);      // 0x2008


    Reg#(Bit#(32)) dataarray[word_count];
    for(Integer i=0;i<word_count;i=i+1)
      dataarray[i]<-mkReg(0);
    Reg#(Bit#(5)) rg_cnt <-mkReg(0);
 	  let dump <- mkReg(InvalidFile) ;
    rule open_file(rg_cnt<5);
      String dumpFile = "signature" ;
    	File lfh <- $fopen( dumpFile, "w" ) ;
    	if ( lfh == InvalidFile )begin
    	  $display("cannot open %s", dumpFile); 
    	  $finish(0);
    	end
    	dump <= lfh ;
    	rg_cnt <= rg_cnt+1 ;
    endrule

    rule configure_registers(!rg_start);
      let aw <- pop_o (s_xactor.o_wr_addr);
      let w  <- pop_o (s_xactor.o_wr_data);
	    let b = AXI4_Wr_Resp {bresp: AXI4_SLVERR, buser: aw.awuser, bid:aw.awid};
      if (aw.awaddr[3:0]=='h0) begin
        rg_start_address<=truncate(w.wdata);
        b.bresp=AXI4_OKAY;
      end
      else if (aw.awaddr[3:0]=='h8) begin
        rg_end_address<=truncate(w.wdata);
        b.bresp=AXI4_OKAY;
        Bit#(`paddr) total_bytes=truncate(w.wdata)-rg_start_address;
        rg_total_count<=total_bytes>>2;
        if(rg_start_address != truncate(w.wdata))
          rg_start<=True;
      end
      else if (aw.awaddr[3:0]=='hc) begin
        $finish(0);        
      end
  	  s_xactor.i_wr_resp.enq (b);
    endrule
    
    rule send_request(rg_start);
      if(rg_start_address<rg_end_address) begin
  			AXI4_Rd_Addr#(`paddr,`axi4_id_width, `USERSPACE) read_request = AXI4_Rd_Addr {araddr: rg_start_address, aruser: ?, 
          arlen:0, arsize: 2, arburst: 'b01, arid:2, arprot: ?}; // arburst: 00-FIXED 01-INCR 10-WRAP
  			m_xactor.i_rd_addr.enq(read_request);	
        rg_start_address<=rg_start_address+4;
        ff_lower_order_bits.enq(truncate(rg_start_address));
      end
    endrule

    rule receive_response(rg_cnt>=5 && rg_start);
			let response <- pop_o (m_xactor.o_rd_data);	
      ff_lower_order_bits.deq();
			Bit#(TLog#(TDiv#(ELEN,8))) lower_addr_bits= ff_lower_order_bits.first();
			Bit#(TAdd#(TLog#(TDiv#(ELEN,8)),3)) lv_shift = {lower_addr_bits,3'd0};
			let lv_data= response.rdata >> lv_shift;
    	$fwrite(dump,"%4h\n", lv_data[31:0]); 
      rg_total_count<=rg_total_count-1;
      if (response.rresp!=AXI4_OKAY)begin
        $display($time, "\tSIGNATUREDUMP got Bus Error");
        $finish(0);
      end
      if(rg_total_count==1)
        rg_start<=False;
    endrule
    interface master=m_xactor.axi_side;
    interface slave=s_xactor.axi_side;
  endmodule
endpackage

