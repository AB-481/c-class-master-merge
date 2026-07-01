package EthStream;

import FIFO::*;
import FIFOF::*;
import Semi_FIFOF::*;
import GetPut::*;
import Connectable::*;

import AXI4_Types::*;
import AXI4_Fabric::*;

typedef Bit#(`paddr) Addr;


// ------------------------------------------------
// EthernetLite registers
// ------------------------------------------------

Addr ethBase     = 'h00044000;
Addr eth_tx_buf  = ethBase;
Addr eth_tx_len  = ethBase + 'h7F4;
Addr eth_tx_ctrl = ethBase + 'h7FC;


// ------------------------------------------------
// Interface
// ------------------------------------------------

interface Ifc_ethstream;

   interface AXI4_Master_IFC#(`paddr,`axi4_id_width,`buswidth,`USERSPACE) master;

   method Action start(Bit#(`paddr) memBase,
                       Bit#(`paddr) memEnd,
                       Bit#(32) bytes);

endinterface

// ------------------------------------------------
// Module
// ------------------------------------------------

module mkEthStream(Ifc_ethstream);

AXI4_Master_Xactor_IFC#(`paddr,`axi4_id_width,`buswidth,`USERSPACE)
   master_xactor <- mkAXI4_Master_Xactor;


// ------------------------------------------------
// Registers
// ------------------------------------------------

Reg#(Bit#(`paddr)) base_addr <- mkReg(0);
Reg#(Bit#(`paddr)) end_addr  <- mkReg(0);

Reg#(Bit#(`paddr)) src_addr <- mkReg(0);

Reg#(Bit#(32)) remaining <- mkReg(0);
Reg#(Bit#(32)) pkt_size  <- mkReg(0);

Reg#(Bit#(`paddr)) eth_addr <- mkReg(eth_tx_buf);

Reg#(Bit#(64)) data_buf <- mkReg(0);

Reg#(Bool) send_hi <- mkReg(False);
Reg#(Bool) running <- mkReg(False);

Reg#(Bit#(3)) header_count <- mkReg(0);

Reg#(Bool) len_written <- mkReg(False);
Reg#(Bool) tx_started <- mkReg(False);


// DDR payload FIFO
FIFOF#(Bit#(64)) ddr_fifo <- mkFIFOF;



// ------------------------------------------------
// Write Ethernet header
// ------------------------------------------------

rule write_header (running &&
                   header_count < 4 &&
                   master_xactor.i_wr_addr.notFull &&
                   master_xactor.i_wr_data.notFull);

   Bit#(32) header_word = 0;

   case (header_count)
      0 : header_word = 32'hFFFFFFFF; // Broadcast MAC: FF:FF:FF:FF:FF:FF
      1 : header_word = 32'hFFFF0200; // Src MAC: 02:00:00:00:00:01
      2 : header_word = 32'h00000001;
      3 : header_word = 32'h00001234; // eth.type: 0x1234 (custom type)
   endcase

   Bit#(1) sel = eth_addr[2];

   Bit#(64) wrdata;
   Bit#(8)  wrstrb;

   if (sel == 0) begin
      wrdata = zeroExtend(header_word);
      wrstrb = 8'h0F;
   end
   else begin
      wrdata = zeroExtend(header_word) << 32;
      wrstrb = 8'hF0;
   end

   AXI4_Wr_Addr#(`paddr,`axi4_id_width,`USERSPACE) wa =
   AXI4_Wr_Addr{
      awaddr  : eth_addr,
      awlen   : 0,
      awsize  : 2,
      awburst : 0,
      awid    : 0,
      awuser  : 0,
      awprot  : 0
   };

   AXI4_Wr_Data#(`axi4_id_width,`buswidth) wd =
   AXI4_Wr_Data{
      wdata : wrdata,
      wstrb : wrstrb,
      wlast : True
   };

   master_xactor.i_wr_addr.enq(wa);
   master_xactor.i_wr_data.enq(wd);

   eth_addr <= eth_addr + 4;
   header_count <= header_count + 1;

endrule



// ------------------------------------------------
// DDR read request to test 32bit write
// ------------------------------------------------

rule send_read (running &&
                header_count == 4 &&
                remaining > 0 &&
                ddr_fifo.notFull &&
                master_xactor.i_rd_addr.notFull);

   AXI4_Rd_Addr#(`paddr,`axi4_id_width,`USERSPACE) ra =
   AXI4_Rd_Addr{
      araddr  : src_addr,
      arlen   : 0,
      arsize  : 3,
      arburst : 0,
      arid    : 0,
      aruser  : 0,
      arprot  : 0
   };

   master_xactor.i_rd_addr.enq(ra);

   src_addr <= src_addr + 8;

endrule



// ------------------------------------------------
// Receive DDR data → FIFO
// ------------------------------------------------

rule recv_data (running &&
                header_count == 4 &&
                master_xactor.o_rd_data.notEmpty &&
                ddr_fifo.notFull);

   let r = master_xactor.o_rd_data.first;
   master_xactor.o_rd_data.deq;

   ddr_fifo.enq(r.rdata);

endrule



// ------------------------------------------------
// Write LOW 32 bits
// ------------------------------------------------

rule write_lo (running &&
               header_count == 4 &&
               remaining > 0 &&
               !send_hi &&
               ddr_fifo.notEmpty &&
               master_xactor.i_wr_addr.notFull &&
               master_xactor.i_wr_data.notFull);

   let d = ddr_fifo.first;
   ddr_fifo.deq;

   data_buf <= d;

   Bit#(32) lo = d[31:0];

   Bit#(1) sel = eth_addr[2];

   Bit#(64) wrdata;
   Bit#(8)  wrstrb;

   if (sel == 0) begin
      wrdata = zeroExtend(lo);
      wrstrb = 8'h0F;
   end
   else begin
      wrdata = zeroExtend(lo) << 32;
      wrstrb = 8'hF0;
   end

   AXI4_Wr_Addr#(`paddr,`axi4_id_width,`USERSPACE) wa =
   AXI4_Wr_Addr{
      awaddr  : eth_addr,
      awlen   : 0,
      awsize  : 2,
      awburst : 0,
      awid    : 0,
      awuser  : 0,
      awprot  : 0
   };

   AXI4_Wr_Data#(`axi4_id_width,`buswidth) wd =
   AXI4_Wr_Data{
      wdata : wrdata,
      wstrb : wrstrb,
      wlast : True
   };

   master_xactor.i_wr_addr.enq(wa);
   master_xactor.i_wr_data.enq(wd);

   eth_addr <= eth_addr + 4;
   send_hi <= True;

endrule



// ------------------------------------------------
// Write HIGH 32 bits
// ------------------------------------------------

rule write_hi (running &&
               header_count == 4 &&
               remaining > 0 &&
               send_hi &&
               master_xactor.i_wr_addr.notFull &&
               master_xactor.i_wr_data.notFull);
   Bit#(32) hi = data_buf[63:32];

   Bit#(1) sel = eth_addr[2];

   Bit#(64) wrdata;
   Bit#(8)  wrstrb;

   if (sel == 0) begin
      wrdata = zeroExtend(hi);
      wrstrb = 8'h0F;
   end
   else begin
      wrdata = zeroExtend(hi) << 32;
      wrstrb = 8'hF0;
   end

   AXI4_Wr_Addr#(`paddr,`axi4_id_width,`USERSPACE) wa =
   AXI4_Wr_Addr{
      awaddr  : eth_addr,
      awlen   : 0,
      awsize  : 2,
      awburst : 0,
      awid    : 0,
      awuser  : 0,
      awprot  : 0
   };

   AXI4_Wr_Data#(`axi4_id_width,`buswidth) wd =
   AXI4_Wr_Data{
      wdata : wrdata,
      wstrb : wrstrb,
      wlast : True
   };

   master_xactor.i_wr_addr.enq(wa);
   master_xactor.i_wr_data.enq(wd);

   eth_addr <= eth_addr + 4;

   remaining <= remaining - 8;

   send_hi <= False;

endrule



rule consume_bresp (master_xactor.o_wr_resp.notEmpty);
   master_xactor.o_wr_resp.deq;
endrule



// ------------------------------------------------
// Write TX length
// ------------------------------------------------

rule write_len (running &&
                header_count == 4 &&
                remaining == 0 &&
                !len_written &&
                master_xactor.i_wr_addr.notFull &&
                master_xactor.i_wr_data.notFull);

   Bit#(64) wrdata = zeroExtend(pkt_size + 14);
   Bit#(8)  wrstrb = 8'h0F;

   AXI4_Wr_Addr#(`paddr,`axi4_id_width,`USERSPACE) wa =
   AXI4_Wr_Addr{
      awaddr  : eth_tx_len,
      awlen   : 0,
      awsize  : 2,
      awburst : 0,
      awid    : 0,
      awuser  : 0,
      awprot  : 0
   };

   AXI4_Wr_Data#(`axi4_id_width,`buswidth) wd =
   AXI4_Wr_Data{
      wdata : wrdata,
      wstrb : wrstrb,
      wlast : True
   };

   master_xactor.i_wr_addr.enq(wa);
   master_xactor.i_wr_data.enq(wd);

   len_written <= True;

endrule



// ------------------------------------------------
// Start transmission
// ------------------------------------------------

rule tx_start (running &&
               len_written &&
               !tx_started &&
               master_xactor.i_wr_addr.notFull &&
               master_xactor.i_wr_data.notFull);

   Bit#(64) wrdata = zeroExtend(32'h1);
   Bit#(8)  wrstrb = 8'h0F;

   AXI4_Wr_Addr#(`paddr,`axi4_id_width,`USERSPACE) wa =
   AXI4_Wr_Addr{
      awaddr  : eth_tx_ctrl,
      awlen   : 0,
      awsize  : 2,
      awburst : 0,
      awid    : 0,
      awuser  : 0,
      awprot  : 0
   };

   AXI4_Wr_Data#(`axi4_id_width,`buswidth) wd =
   AXI4_Wr_Data{
      wdata : wrdata,
      wstrb : wrstrb,
      wlast : True
   };

   master_xactor.i_wr_addr.enq(wa);
   master_xactor.i_wr_data.enq(wd);

   tx_started <= True;

   header_count <= 0;
   remaining <= pkt_size;
   eth_addr <= eth_tx_buf;

   len_written <= False;

endrule



// ------------------------------------------------
// Start DMA
// ------------------------------------------------

method Action start(Bit#(`paddr) memBase,
                    Bit#(`paddr) memEnd,
                    Bit#(32) bytes);

   base_addr <= memBase;
   end_addr  <= memEnd;

   src_addr <= memBase;

   pkt_size <= bytes;
   remaining <= bytes;

   eth_addr <= eth_tx_buf;

   header_count <= 0;

   len_written <= False;
   tx_started <= False;

   running <= True;

endmethod



interface master = master_xactor.axi_side;

endmodule

endpackage