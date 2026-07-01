// See LICENSE.iitm for license details
/*
Author: IIT Madras
Created on: Tuesday 22 June 2021 01:48:12 PM

*/
/*doc:overview:
This package includes a semi-parameterized function which can be used to performing bypass of
operands from variable sources to a single sink

compile-macros:
- bypass_noinline: When set, causes each function to be synthesized as a separate verilog file.
*/
package bypass ;
  import FIFOF        :: * ;
  import Vector       :: * ;
`ifdef async_rst
  import SpecialFIFOs_Modified :: * ;
`else
  import SpecialFIFOs :: * ;
`endif
  import FIFOF        :: * ;

  `include "Logger.bsv"

  import ccore_types  :: * ;

  `ifdef bypass_noinline
  (*noinline*)
  `endif
  /*doc:func: This function performs the operand bypass logic. Inputs are the requesting operand
   * (address, id, etc) and the downstream ISBs head information */
`ifdef DUAL_ISSUE
  function Tuple2#(Bool, Bit#(`elen)) fn_bypass (BypassReq req, 
                  Vector#(`bypass_sources, Vector#(`num_issue, FwdType)) pipe_fwd, FwdType rf_fwd);
    //Vector#(`bypass_sources, Bit#(`num_issue)) choice = 0;
    Bit#(TMul#(`bypass_sources, `num_issue)) choice = 0;
    Bool inst_in_pipe = req.sb_lock == 1;
    for (Integer i = 0; i<`bypass_sources ; i = i + 1) begin
      for (Integer j = 0; j<`num_issue; j=j+1) begin
        choice[2*i+j] = pack(pipe_fwd[i][j].valid && pipe_fwd[i][j].addr == req.rd && pipe_fwd[i][j].epochs == req.epochs
                          `ifdef no_wawstalls && pipe_fwd[i][j].id == req.id `endif
                          `ifdef spfpu && pipe_fwd[i][j].rdtype == req.rdtype `endif );
      end
    end
    Bool inst_in_bypass = unpack(|choice);
    Bool available = inst_in_bypass || !inst_in_pipe;
    //TODO The below case is hardcoded for dual issue core. Can be paramterized into multi-issue. Later
    Bit#(`elen) fwd_data = case(choice) matches
      'b??1?: pipe_fwd[0][1].data;
      'b??01: pipe_fwd[0][0].data;
      'b1?00: pipe_fwd[1][1].data;
      'b0100: pipe_fwd[1][0].data;
      default: rf_fwd.data;
    endcase;
    
    return tuple2(available, fwd_data);
  endfunction:fn_bypass

`else
  function Tuple2#(Bool, Bit#(`elen)) fn_bypass (BypassReq req, 
                  Vector#(TAdd#(`bypass_sources ,1), FwdType) fwd);
    Bit#(`bypass_sources) choice = 0;
    Bool inst_in_pipe = req.sb_lock == 1;
    for (Integer i = 0; i<`bypass_sources ; i = i + 1) begin
      choice[i] = pack(fwd[i].valid && fwd[i].addr == req.rd && fwd[i].epochs == req.epochs
                        `ifdef no_wawstalls && fwd[i].id == req.id `endif
                        `ifdef spfpu && fwd[i].rdtype == req.rdtype `endif );
    end
    Bool available = unpack(|choice[1:0]) || !inst_in_pipe;
    Bit#(`elen) fwd_data = case(choice) matches
      'b?1: fwd[0].data;
      'b10: fwd[1].data;
      default: fwd[2].data;
    endcase;
    
    return tuple2(available, fwd_data);
  endfunction:fn_bypass
`endif
endpackage: bypass

