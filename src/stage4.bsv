// See LICENSE.iitm for license details
/*
Author: IIT Madras
Created on: Saturday 19 June 2021 08:22:34 PM

*/
/*doc:overview
This module acts as the capturing stage of all execution units and forwards them in program order to
the write-back stage. 

The module employs a basic polling technique which is governed by the value at the head of the FUid
ISB. The FUid indicates which Functional unit - muldiv, float, base-alu, trap, cache, etc - is
supposed to provide the next set instructino which can be forwarded to the write-back stage.

There can be multiple functional units which can be polled in this stage whose write-back function
is quite similar. Thus, this stage also tries to converge the various FUids to Commit Unit ids.
*/
package stage4;

  import FIFOF        :: * ;
  import Vector       :: * ;
`ifdef async_rst
  import SpecialFIFOs_Modified :: * ;
`else
  import SpecialFIFOs :: * ;
`endif
  import FIFOF        :: * ;
  import TxRx         :: * ;
  import GetPut       :: * ;

  import ccore_types  :: * ;
  import dcache_types :: * ;
  import pipe_ifcs    :: * ;

  `include "trap.defines"

  `include "Logger.bsv"

  interface Ifc_stage4;
    interface Ifc_s4_rx rx;
`ifdef DUAL_ISSUE
    interface Ifc_s4_perfmonitors perf;
`endif
    interface Ifc_s4_tx tx;
    interface Ifc_s4_cache cache;
  `ifdef muldiv
    interface Ifc_s4_muldiv s4_mbox;
  `endif
  `ifdef spfpu
  interface Ifc_s4_float s4_fbox;
`endif
  endinterface:Ifc_stage4

`ifdef stage4_noinline
`ifdef core_clkgate
  (*synthesize,gate_all_clocks*)
`else
  (*synthesize*)
`endif
`endif
// the following attributes are only required in simulation mode. They basically allows a rule to
// fire which indicates that a stall is observed.
`ifdef simulate
`ifdef spfpu
  (*preempts="rl_capture_float, rl_polling_check"*)
`endif
  (*preempts="rl_capture_muldiv, rl_polling_check"*)
  (*preempts="rl_fwd_baseout, rl_polling_check"*)
  (*preempts="rl_fwd_systemout, rl_polling_check"*)
  (*preempts="rl_fwd_trapout, rl_polling_check"*)
  (*preempts="rl_handle_memory, rl_polling_check"*)
`ifdef DUAL_ISSUE
  (*preempts="rl_1st_instruction_invalid, rl_polling_check"*)
`endif
`endif
`ifdef DUAL_ISSUE
  (*conflict_free="rl_fwd_baseout_1, rl_2nd_instruction_invalid"*)
`endif

  /*doc:module:*/
module mkstage4#(parameter Bit#(`xlen) hartid)(Ifc_stage4);
    /*doc:submodule: The following are the virtual FIFOs connected to the ISBs from the EXE stage*/
`ifdef DUAL_ISSUE
    //RX#(Vector#(`num_issue, BaseOut)) rx_baseout <- mkRX; 
    //RX#(Vector#(`num_issue, TrapOut)) rx_trapout <- mkRX;
    //RX#(Vector#(`num_issue, SystemOut)) rx_systemout <- mkRX;
    //RX#(Vector#(`num_issue, MemoryOut)) rx_memoryout <- mkRX;
    RX#(Vector#(`num_issue, FUid)) rx_fuid <- mkRX;
`else    
    RX#(BaseOut) rx_baseout <- mkRX; 
    RX#(TrapOut) rx_trapout <- mkRX;
    RX#(SystemOut) rx_systemout <- mkRX;
    RX#(MemoryOut) rx_memoryout <- mkRX;
    RX#(FUid) rx_fuid <- mkRX;
    
   `ifdef etrace_support 
    RX#(Bit#(14)) rx_ingress_opcode <- mkRX;
    `endif

`endif
  `ifdef rtldump
`ifdef DUAL_ISSUE
    RX#(Vector#(`num_issue, CommitLogPacket)) rx_commitlog <- mkRX;
`else
    RX#(CommitLogPacket) rx_commitlog <- mkRX;
`endif
  `endif
  `ifdef muldiv
    RX#(Bit#(`xlen)) rx_mbox <- mkRX;
    `ifdef arith_trap
      RX#(Tuple2#(Bool, Bit#(`causesize))) rx_mbox_arith_trap_output <- mkRX; 
    `endif
  `endif
  `ifdef spfpu
  RX#(XBoxOutput) rx_fbox <- mkRX;
`endif
  
    /*doc:submodule: Following are the virtual FIFOs connected to the ISBs feeding into the
     * write-back stage*/
`ifdef DUAL_ISSUE
    //TX#(Vector#(`num_issue, SystemOut)) tx_systemout <- mkTX;
    //TX#(Vector#(`num_issue, TrapOut))   tx_trapout <- mkTX;
    //TX#(Vector#(`num_issue, BaseOut))   tx_baseout <- mkTX;
    //TX#(Vector#(`num_issue, WBMemop))   tx_memio <- mkTX;
    TX#(Vector#(`num_issue, CUid))      tx_fuid <- mkTX;
`else
    TX#(SystemOut) tx_systemout <- mkTX;
    TX#(TrapOut)   tx_trapout <- mkTX;
    TX#(BaseOut)   tx_baseout <- mkTX;
    TX#(WBMemop)   tx_memio <- mkTX;
    TX#(CUid)      tx_fuid <- mkTX;
    `ifdef etrace_support 
    TX#(Bit#(14))  tx_ingress_opcode <- mkTX;
    `endif
`endif
  `ifdef rtldump
`ifdef DUAL_ISSUE
    TX#(Vector#(`num_issue, CommitLogPacket)) tx_commitlog <- mkTX;
`else
    TX#(CommitLogPacket) tx_commitlog <- mkTX;
`endif
  `endif

`ifdef DUAL_ISSUE
    Vector#(`num_issue, Wire#(CUid)) wr_fuid <- replicateM(mkWire());
    Vector#(`num_issue, Wire#(CommitLogPacket)) wr_commitlog <- replicateM(mkWire());
`endif

    // fifo to capture the response from the dmem subsystem
  FIFOF#(DMem_core_response#(`elen,1)) ff_memory_response <- mkBypassFIFOF();


  `ifdef simulate
    /*doc:rule: This rule is only available in simulation mode. If the FUid is available but the
     * respective functional unit's output is not available, then this rule will fire and print a stall
     * signal in the log*/
    rule rl_polling_check(rx_fuid.u.notEmpty);
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Waiting for FUnit:",hartid,fshow(rx_fuid.u.first.insttype)))
    endrule:rl_polling_check
  `endif

    /*doc:rule: This rule will simply bypass the results of instructinos which were executed in the
    * previous stage without any alteration*/
`ifdef DUAL_ISSUE
   for (Integer i=0; i<`num_issue; i=i+1) begin
    rule rl_fwd_baseout(rx_fuid.u.first[i].insttype == BASE && tx_fuid.u.notFull());
      //tx_baseout.u.enq(rx_baseout.u.first);
      //tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first, ?));
      wr_fuid[i] <= fn_fu2cu(rx_fuid.u.first[i], ?);
      //rx_baseout.u.deq;
      //rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Output: ",hartid,fshow(fn_fu2cu(rx_fuid.u.first[i], ?))), wr_simulate_log_start)
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering Base ALU Output",hartid), wr_simulate_log_start)
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first[i];
      CommitLogReg _pkt =?;
      if (clogpkt.inst_type matches tagged REG .r)
        _pkt = r;
      //_pkt.wdata = rx_baseout.u.first[0].rdvalue;
      if (rx_fuid.u.first[i].instpkt matches tagged BASE .baseout)
        _pkt.wdata = baseout.rdvalue;
      clogpkt.inst_type = tagged REG _pkt;
      wr_commitlog[i] <= clogpkt;
      //tx_commitlog.u.enq(clogpkt);
      //rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_baseout
  end
`else
    rule rl_fwd_baseout(rx_fuid.u.first.insttype == BASE);
      tx_baseout.u.enq(rx_baseout.u.first);
      tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first));
      rx_baseout.u.deq;
      rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering Base ALU Output",hartid))
      `ifdef etrace_support 
      let lv_opcode_ingress = rx_ingress_opcode.u.first;
     tx_ingress_opcode.u.enq(lv_opcode_ingress);
     rx_ingress_opcode.u.deq;
     `endif
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first;
      CommitLogReg _pkt =?;
      if (clogpkt.inst_type matches tagged REG .r)
        _pkt = r;
      _pkt.wdata = rx_baseout.u.first.rdvalue;
      clogpkt.inst_type = tagged REG _pkt;
      tx_commitlog.u.enq(clogpkt);
      rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_baseout
`endif

    /*doc:rule: This rule will bypass the system operation as is to the write-back stage where it
    * will be executed. No alteration required in this stage for system operations*/
`ifdef DUAL_ISSUE
    rule rl_fwd_systemout(rx_fuid.u.first[0].insttype == SYSTEM && tx_fuid.u.notFull());
      //tx_systemout.u.enq(rx_systemout.u.first);
      //tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first, ?));
      wr_fuid[0] <= fn_fu2cu(rx_fuid.u.first[0], ?);
      //rx_systemout.u.deq;
      //rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first[0].pc), wr_simulate_log_start)
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering System Output",hartid), wr_simulate_log_start)
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first[0];
      wr_commitlog[0] <= clogpkt;
      //tx_commitlog.u.enq(clogpkt);
      //rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_systemout

`else
    rule rl_fwd_systemout(rx_fuid.u.first.insttype == SYSTEM);
      tx_systemout.u.enq(rx_systemout.u.first);
      tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first));
      rx_systemout.u.deq;
      rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering System Output",hartid))
      `ifdef etrace_support 
      let lv_opcode_ingress = rx_ingress_opcode.u.first;
     tx_ingress_opcode.u.enq(lv_opcode_ingress);
     rx_ingress_opcode.u.deq;
     `endif
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first;
      tx_commitlog.u.enq(clogpkt);
      rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_systemout
`endif

    /*doc:rule: This rule will bypass an instructino that was tagged as a trap in the previous
    * stages to the write-back stage which will handle the traps accordingly*/
`ifdef DUAL_ISSUE
    rule rl_fwd_trapout(rx_fuid.u.first[0].insttype == TRAP && tx_fuid.u.notFull());
      //tx_trapout.u.enq(rx_trapout.u.first);
      //tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first, ?));
      wr_fuid[0] <= fn_fu2cu(rx_fuid.u.first[0], ?);
      //rx_trapout.u.deq;
      //rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first[0].pc), wr_simulate_log_start)
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering Trap Output",hartid), wr_simulate_log_start)
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first[0];
      wr_commitlog[0] <= clogpkt;
      //tx_commitlog.u.enq(clogpkt);
      //rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_trapout

`else
    rule rl_fwd_trapout(rx_fuid.u.first.insttype == TRAP);
      tx_trapout.u.enq(rx_trapout.u.first);
      tx_fuid.u.enq(fn_fu2cu(rx_fuid.u.first));
      rx_trapout.u.deq;
      rx_fuid.u.deq;
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Buffering Trap Output",hartid))
      `ifdef etrace_support 
      let lv_opcode_ingress = rx_ingress_opcode.u.first;
     tx_ingress_opcode.u.enq(lv_opcode_ingress);
     rx_ingress_opcode.u.deq;
     `endif
    `ifdef rtldump
      let clogpkt = rx_commitlog.u.first;
      tx_commitlog.u.enq(clogpkt);
      rx_commitlog.u.deq;
    `endif
    endrule:rl_fwd_trapout
`endif

    /*doc:rule: This rule handles the collection of the response from the data caches/memory
    * subsytems. 
    * If the memory subsytem indicates a trap then the tx_trapout ISB is enqueued with
    * the relevant information and FUid is now mapped to a TRAP CUid.
    * 
    * If the memory operation was a cached load, then this stage will enqueue the results into the
    * tx_baseout ISB which will simply udpate the registrfile with relevant values
    * 
    * In all other cases of the memory ops (store, atomic, io, etc). the result from the cache is
    * simply forwarded to the write-back where the final commit signal will be initiated.
    * 
    * if D extension is enabled, then nanboxing of single-precision values is also performed here.
    *
    * Note: In case of loads, thoug the CUid changes to base-out the commitLog packet is still
    * tagged as Memory for correct log-keeping
    */
`ifdef DUAL_ISSUE
    rule rl_handle_memory(rx_fuid.u.first[0].insttype == MEMORY && ff_memory_response.notEmpty && tx_fuid.u.notFull());
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first[0].pc), wr_simulate_log_start)
      let mem_response = ff_memory_response.first;
      ff_memory_response.deq;
      let epochs = rx_fuid.u.first[0].epochs;
      let fuid = rx_fuid.u.first;
      //let memop = rx_memoryout.u.first;
      MemoryOut memop;
      if (rx_fuid.u.first[0].instpkt matches tagged MEMORY .mem)
        memop = mem;
      else
        memop = ?;
      
      Bool trap = mem_response.trap;
      Bit#(`causesize) cause = mem_response.cause;

      if (mem_response.epochs != epochs) begin
        //`logLevel( stage4, 0, $format("[%2d]STAGE4: Dropping Mem response",hartid), wr_simulate_log_start)
      end
      else begin
        //rx_fuid.u.deq;
        //rx_memoryout.u.deq;
      `ifdef rtldump
        //rx_commitlog.u.deq;
        let clogpkt = rx_commitlog.u.first[0];
      `endif
        if (trap) begin
          fuid[0].insttype = TRAP;
          TrapOut trapout = TrapOut {cause   : cause, 
                                     is_microtrap: False,
                                     mtval : truncate(mem_response.word)
                                     `ifdef hypervisor
																	 	 , mtval2: zeroExtend(mem_response.mtval2)
                                      `endif
                                      };
          //tx_trapout.u.enq(unpack({0, pack(trapout)}));
          fuid[0].instpkt = tagged TRAP trapout;
          wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
          //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Memory responded with trap: ",hartid, fshow(trapout)), wr_simulate_log_start)
        `ifdef rtldump
          wr_commitlog[0] <= clogpkt;
          //tx_commitlog.u.enq(clogpkt);
        `endif
        end
        else if (mem_response.entry_alloc) begin
          let lv_memop = WBMemop{ memaccess: memop.memaccess , io: mem_response.is_io,
              sb_id : mem_response.sb_id
              `ifdef dpfpu ,nanboxing: unpack(memop.nanboxing) `endif
              `ifdef atomic ,atomic_rd_data: mem_response.word `endif };
          //tx_memio.u.enq(unpack({0, pack(lv_memop)}));
          fuid[0].insttype = MEMORY;
          //fuid[0].instpkt = tagged MEMORY lv_memop;
          //tx_fuid.u.enq(fn_fu2cu(fuid, unpack({?, pack(lv_memop)})));
          wr_fuid[0] <= fn_fu2cu(fuid[0], lv_memop);
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Mem response received:",hartid, fshow(lv_memop)), wr_simulate_log_start)
        `ifdef rtldump
          //tx_commitlog.u.enq(clogpkt);
          wr_commitlog[0] <= clogpkt;
        `endif
        end
        else begin
          `ifdef dpfpu if (memop.nanboxing == 1 ) mem_response.word[63:32] = '1; `endif
          fuid[0].insttype = BASE;
          let baseout = BaseOut {rd: rx_fuid.u.first[0].rd, rdvalue: mem_response.word, epochs: fuid[0].epochs
                            `ifdef spfpu        ,fflags: 0, rdtype: fuid[0].rdtype `endif };
        //`ifdef no_wawstalls
        //  baseout.id = fuid[0].id;
        //`endif
          //tx_baseout.u.enq(unpack({0, pack(baseout)}));
          fuid[0].instpkt = tagged BASE baseout;
          //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
          wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Memory responded with data:",hartid, fshow(baseout)), wr_simulate_log_start)
        `ifdef rtldump
          if (memop.memaccess == Atomic && !mem_response.entry_alloc && memop.atomicop=='b0111) begin
            clogpkt.inst_type = tagged REG (CommitLogReg{wdata: mem_response.word, rd:
                fuid[0].rd, irf: `ifdef spfpu (fuid[0].rdtype==IRF) `else True `endif });
          end
          else begin
            CommitLogMem _pkt = ?;
            if (clogpkt.inst_type matches tagged MEM .p)
              _pkt = p;
            _pkt.commit_data = baseout.rdvalue;
            clogpkt.inst_type = tagged MEM _pkt;
          end
          //tx_commitlog.u.enq(clogpkt);
          wr_commitlog[0] <= clogpkt;
        `endif
        end
      end
    endrule:rl_handle_memory


`else
    rule rl_handle_memory(rx_fuid.u.first.insttype == MEMORY && ff_memory_response.notEmpty);
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      let mem_response = ff_memory_response.first;
      ff_memory_response.deq;
      let epochs = rx_fuid.u.first.epochs;
      let fuid = fn_fu2cu(rx_fuid.u.first);
      let memop = rx_memoryout.u.first;
      
      Bool trap = mem_response.trap;
      Bit#(`causesize) cause = mem_response.cause;

      if (mem_response.epochs != epochs) begin
        //`logLevel( stage4, 0, $format("[%2d]STAGE4: Dropping Mem response",hartid))
      end
      else begin
        rx_fuid.u.deq;
        rx_memoryout.u.deq;
        `ifdef etrace_support 
        let lv_opcode_ingress = rx_ingress_opcode.u.first;
        rx_ingress_opcode.u.deq;
        `endif
      `ifdef rtldump
        rx_commitlog.u.deq;
        let clogpkt = rx_commitlog.u.first;
      `endif
        if (trap) begin
          fuid.insttype = TRAP;
          TrapOut trapout = TrapOut {cause   : cause, 
                                     is_microtrap: False,
                                     mtval : truncate(mem_response.word)
                                     `ifdef hypervisor
																	 	 , mtval2: zeroExtend(mem_response.mtval2)
                                      `endif
                                      };
          tx_trapout.u.enq(trapout);
          tx_fuid.u.enq(fuid);
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Memory responded with trap: ",hartid, fshow(trapout)))
          `ifdef etrace_support 
           tx_ingress_opcode.u.enq(lv_opcode_ingress);
           `endif
        `ifdef rtldump
          tx_commitlog.u.enq(clogpkt);
        `endif
        end
        else if (mem_response.entry_alloc) begin
          let lv_memop = WBMemop{ memaccess: memop.memaccess , io: mem_response.is_io,
              sb_id : mem_response.sb_id
              `ifdef dpfpu ,nanboxing: unpack(memop.nanboxing) `endif
              `ifdef atomic ,atomic_rd_data: mem_response.word `endif };
          tx_memio.u.enq(lv_memop);
          fuid.insttype = MEMORY;
          tx_fuid.u.enq(fuid);
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Mem response received:",hartid, fshow(lv_memop)))
          `ifdef etrace_support 
           tx_ingress_opcode.u.enq(lv_opcode_ingress);
           `endif
        `ifdef rtldump
          tx_commitlog.u.enq(clogpkt);
        `endif
        end
        else begin
          `ifdef dpfpu if (memop.nanboxing == 1 ) mem_response.word[63:32] = '1; `endif
          fuid.insttype = BASE;
          let baseout = BaseOut {rd: rx_fuid.u.first.rd, rdvalue: mem_response.word, epochs: fuid.epochs
                            `ifdef no_wawstalls ,id: ? `endif
                            `ifdef spfpu        ,fflags: 0, rdtype: fuid.rdtype `endif };
        `ifdef no_wawstalls
          baseout.id = fuid.id;
        `endif
          tx_baseout.u.enq(baseout);
          tx_fuid.u.enq(fuid);
          //`logLevel( stage4, 0, $format("[%2d]STAGE4: Memory responded with data:",hartid, fshow(baseout)))
          `ifdef etrace_support 
           tx_ingress_opcode.u.enq(lv_opcode_ingress);
           `endif
        `ifdef rtldump
          if (memop.memaccess == Atomic && !mem_response.entry_alloc && memop.atomicop=='b0111) begin
            clogpkt.inst_type = tagged REG (CommitLogReg{wdata: mem_response.word, rd:
                fuid.rd, irf: `ifdef spfpu (fuid.rdtype==IRF) `else True `endif });
          end
          else begin
            CommitLogMem _pkt = ?;
            if (clogpkt.inst_type matches tagged MEM .p)
              _pkt = p;
            _pkt.commit_data = baseout.rdvalue;
            clogpkt.inst_type = tagged MEM _pkt;
          end
          tx_commitlog.u.enq(clogpkt);
        `endif
        end
      end
    endrule:rl_handle_memory
`endif

  `ifdef muldiv
    /*doc:rule: This rule is fired when the FUid points to the muldiv operations. This rule is fired
     * when the mbox has a valid output. It is expected that the mbox provides output in the same
     * order the inputs were provided. 
     * The outputs from the mbox are transfered to the tx_baseout ISB for a regular commit in the
     * write-back stage
    */
`ifdef DUAL_ISSUE
   rule rl_capture_muldiv(rx_fuid.u.first[0].insttype == MULDIV && rx_mbox.u.notEmpty() `ifdef arith_trap && rx_mbox_arith_trap_output.u.notEmpty() `endif  && tx_fuid.u.notFull());
      let mbox_result = rx_mbox.u.first;
      let fuid = rx_fuid.u.first;
      rx_mbox.u.deq;
      `ifdef arith_trap
        let mbox_arith_trap_output = rx_mbox_arith_trap_output.u.first;
        rx_mbox_arith_trap_output.u.deq;
        if (tpl_1(mbox_arith_trap_output)) begin
          fuid[0].insttype = TRAP;
          TrapOut trapout = TrapOut {cause   : tpl_2(mbox_arith_trap_output), 
                                     is_microtrap: False,
                                     mtval : ?
                                    };
          //tx_trapout.u.enq(trapout);
          fuid[0].instpkt = tagged TRAP trapout;
          wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
          //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
          //rx_fuid.u.deq;
          `ifdef rtldump
            let clogpkt = rx_commitlog.u.first[0];
            wr_commitlog[0] <= clogpkt;
            //tx_commitlog.u.enq(clogpkt);
          `endif
        end
        else begin 
      `endif
        BaseOut baseout = BaseOut {rd: rx_fuid.u.first[0].rd, rdvalue: mbox_result, epochs: fuid[0].epochs
              `ifdef spfpu ,fflags: 0, rdtype: IRF `endif };
        fuid[0].instpkt = tagged BASE baseout;
        fuid[0].insttype = BASE;
        wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
        //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
        //rx_fuid.u.deq;
        `ifdef rtldump
          let clogpkt = rx_commitlog.u.first[0];
          CommitLogReg _pkt =?;
          if (clogpkt.inst_type matches tagged REG .r)
            _pkt = r;
          _pkt.wdata = mbox_result;
          clogpkt.inst_type = tagged REG _pkt;
          wr_commitlog[0] <= clogpkt;
          //tx_commitlog.u.enq(clogpkt);
          //rx_commitlog.u.deq;
        `endif
      `ifdef arith_trap
        end
      `endif

      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first[0].pc), wr_simulate_log_start)
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Enquing MULDIV Output: ",hartid, fshow(mbox_result)), wr_simulate_log_start)
      `ifdef arith_trap
        //`logLevel(stage4, 0, $format("[%2d]STAGE4: MBOX: ArithTrap: ", hartid, fshow(mbox_arith_trap_output)), wr_simulate_log_start)
      `endif
    endrule:rl_capture_muldiv

`else
   rule rl_capture_muldiv(rx_fuid.u.first.insttype == MULDIV && rx_mbox.u.notEmpty() `ifdef arith_trap && rx_mbox_arith_trap_output.u.notEmpty() `endif );
      let mbox_result = rx_mbox.u.first;
      let fuid = fn_fu2cu(rx_fuid.u.first);
      rx_mbox.u.deq;
      `ifdef arith_trap
        let mbox_arith_trap_output = rx_mbox_arith_trap_output.u.first;
        rx_mbox_arith_trap_output.u.deq;
        if (tpl_1(mbox_arith_trap_output)) begin
          fuid.insttype = TRAP;
          TrapOut trapout = TrapOut {cause   : tpl_2(mbox_arith_trap_output), 
                                     is_microtrap: False,
                                     mtval : ?
                                    };
          tx_trapout.u.enq(trapout);
          tx_fuid.u.enq(fuid);
          rx_fuid.u.deq;
          `ifdef etrace_support 
          let lv_opcode_ingress = rx_ingress_opcode.u.first;
          tx_ingress_opcode.u.enq(lv_opcode_ingress);
         rx_ingress_opcode.u.deq;
         `endif
          `ifdef rtldump
            let clogpkt = rx_commitlog.u.first;
            tx_commitlog.u.enq(clogpkt);
          `endif
        end
        else begin 
      `endif
        tx_baseout.u.enq(BaseOut {rd: rx_fuid.u.first.rd, rdvalue: mbox_result, epochs: fuid.epochs
              `ifdef no_wawstalls ,id: fuid.id `endif
              `ifdef spfpu ,fflags: 0, rdtype: IRF `endif });
        fuid.insttype = BASE;
        tx_fuid.u.enq(fuid);
        rx_fuid.u.deq;
        `ifdef etrace_support 
        let lv_opcode_ingress = rx_ingress_opcode.u.first;
        tx_ingress_opcode.u.enq(lv_opcode_ingress);
        rx_ingress_opcode.u.deq;
        `endif
        `ifdef rtldump
          let clogpkt = rx_commitlog.u.first;
          CommitLogReg _pkt =?;
          if (clogpkt.inst_type matches tagged REG .r)
            _pkt = r;
          _pkt.wdata = mbox_result;
          clogpkt.inst_type = tagged REG _pkt;
          tx_commitlog.u.enq(clogpkt);
          rx_commitlog.u.deq;
        `endif
      `ifdef arith_trap
        end
      `endif

      //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
      //`logLevel( stage4, 0, $format("[%2d]STAGE4: Enquing MULDIV Output: ",hartid, fshow(mbox_result)))
      `ifdef arith_trap
        //`logLevel(stage4, 0, $format("[%2d]STAGE4: MBOX: ArithTrap: ", hartid, fshow(mbox_arith_trap_output)))
      `endif
    endrule:rl_capture_muldiv
`endif
  `endif
  `ifdef spfpu
  /*doc:rule: This rule is fired when the FUid points to the muldiv operations. This rule is fired
   * when the fbox has a valid output. It is expected that the fbox provides output in the same
   * order the inputs were provided. 
   * The outputs from the fbox are transfered to the tx_baseout ISB for a regular commit in the
   * write-back stage
  */
`ifdef DUAL_ISSUE
    rule rl_capture_float(rx_fuid.u.first[0].insttype == FLOAT && rx_fbox.u.notEmpty() && tx_fuid.u.notFull());
    let _r = rx_fbox.u.first;
    let fuid = rx_fuid.u.first;
    rx_fbox.u.deq;
    `ifdef arith_trap
      Bool arith_trap = False;
      Bit#(`causesize) arith_cause = 0;
      if (_r.arith_trap_en == 1) begin
        if(_r.fflags!=0)
          arith_trap = True;
        if (_r.fflags[4]==1)
          arith_cause =`FP_invalid; //Invalid
        else if (_r.fflags[3]==1)
          arith_cause=`FP_divide_by_zero; //Divide_by_zero_float
        else if (_r.fflags[2]==1)
          arith_cause=`FP_overflow; //Overflow
        else if (_r.fflags[1]==1)
          arith_cause=`FP_underflow; //Underflow
        else if (_r.fflags[0]==1)
          arith_cause=`FP_inexact; //Inexact
      end

      if (arith_trap) begin
        fuid[0].insttype = TRAP;
        TrapOut trapout = TrapOut {cause   : arith_cause, 
                                   is_microtrap: False,
                                   mtval : ?
                                  };
        //tx_trapout.u.enq(trapout);
        fuid[0].instpkt = tagged TRAP trapout;
        wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
        //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
        //rx_fuid.u.deq;
        `ifdef rtldump
          let clogpkt = rx_commitlog.u.first;
          wr_commitlog[0] <= clogpkt;
          //tx_commitlog.u.enq(clogpkt);
        `endif
      end
      else 
    `endif
      begin 
        BaseOut baseout = BaseOut {rd: rx_fuid.u.first[0].rd, rdvalue: _r.data, epochs: fuid[0].epochs
              `ifdef spfpu ,fflags: _r.fflags, rdtype: fuid[0].rdtype `endif };
        fuid[0].insttype = BASE;
        fuid[0].instpkt = tagged BASE baseout;
        wr_fuid[0] <= fn_fu2cu(fuid[0], ?);
        //tx_fuid.u.enq(fn_fu2cu(fuid, ?));
        //rx_fuid.u.deq;
      `ifdef rtldump
        let clogpkt = rx_commitlog.u.first[0];
        CommitLogReg _pkt =?;
        if (clogpkt.inst_type matches tagged REG .r)
          _pkt = r;
        _pkt.wdata = _r.data;
        _pkt.fflags = _r.fflags;
        clogpkt.inst_type = tagged REG _pkt;
        wr_commitlog[0] <= clogpkt;
        //tx_commitlog.u.enq(clogpkt);
        //rx_commitlog.u.deq;
      `endif
    end
    //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first[0].pc), wr_simulate_log_start)
    //`logLevel( stage4, 0, $format("[%2d]STAGE4: Enquing FLOAT Output: ",hartid, fshow(_r)), wr_simulate_log_start)
  endrule:rl_capture_float

`else
  rule rl_capture_float(rx_fuid.u.first.insttype == FLOAT && rx_fbox.u.notEmpty());
    let _r = rx_fbox.u.first;
    let fuid = fn_fu2cu(rx_fuid.u.first);
    rx_fbox.u.deq;
    `ifdef arith_trap
      Bool arith_trap = False;
      Bit#(`causesize) arith_cause = 0;
      if (_r.arith_trap_en == 1) begin
        if(_r.fflags!=0  && _r.fflags!=5'b00001) //Inexact need not be trap.
          arith_trap = True;
        if (_r.fflags[4]==1)
          arith_cause =`FP_invalid; //Invalid
        else if (_r.fflags[3]==1)
          arith_cause=`FP_divide_by_zero; //Divide_by_zero_float
        else if (_r.fflags[2]==1)
          arith_cause=`FP_overflow; //Overflow
        else if (_r.fflags[1]==1)
          arith_cause=`FP_underflow; //Underflow
        else if (_r.fflags[0]==1)
          arith_cause=`FP_inexact; //Inexact
      end

      if (arith_trap) begin
        fuid.insttype = TRAP;
        TrapOut trapout = TrapOut {cause   : arith_cause, 
                                   is_microtrap: False,
                                   mtval : ?
                                  };
        tx_trapout.u.enq(trapout);
        tx_fuid.u.enq(fuid);
        rx_fuid.u.deq;
        `ifdef etrace_support 
        let lv_opcode_ingress = rx_ingress_opcode.u.first;
        tx_ingress_opcode.u.enq(lv_opcode_ingress);
        rx_ingress_opcode.u.deq;
        `endif
        `ifdef rtldump
          let clogpkt = rx_commitlog.u.first;
          tx_commitlog.u.enq(clogpkt);
        `endif
      end
      else 
    `endif
      begin 
        tx_baseout.u.enq(BaseOut {rd: rx_fuid.u.first.rd, rdvalue: _r.data, epochs: fuid.epochs
              `ifdef no_wawstalls ,id: fuid.id `endif
              `ifdef spfpu ,fflags: _r.fflags, rdtype: fuid.rdtype `endif });
        fuid.insttype = BASE;
        tx_fuid.u.enq(fuid);
        rx_fuid.u.deq;
        `ifdef etrace_support 
        let lv_opcode_ingress = rx_ingress_opcode.u.first;
        tx_ingress_opcode.u.enq(lv_opcode_ingress);
        rx_ingress_opcode.u.deq;
        `endif
      `ifdef rtldump
        let clogpkt = rx_commitlog.u.first;
        CommitLogReg _pkt =?;
        if (clogpkt.inst_type matches tagged REG .r)
          _pkt = r;
        _pkt.wdata = _r.data;
        _pkt.fflags = _r.fflags;
        clogpkt.inst_type = tagged REG _pkt;
        tx_commitlog.u.enq(clogpkt);
        rx_commitlog.u.deq;
      `endif
    end
    //`logLevel( stage4, 0, $format("[%2d]STAGE4: PC:%h",hartid,rx_fuid.u.first.pc))
    //`logLevel( stage4, 0, $format("[%2d]STAGE4: Enquing FLOAT Output: ",hartid, fshow(_r)))
  endrule:rl_capture_float
`endif
`endif

`ifdef DUAL_ISSUE
    let default_commitlog = CommitLogPacket { mode : unpack(?),
                                              pc : ?,
                                              instruction : ?,
                                              inst_type : tagged None
                                            `ifdef hypervisor
                                              ,v : ?
                                            `endif
                                            };

    rule rl_1st_instruction_invalid(rx_fuid.u.first[0].insttype == NONE && tx_fuid.u.notFull());
      let default_common = CUid { pc : rx_fuid.u.first[0].pc,
                                  rd : rx_fuid.u.first[0].rd,
                                  epochs: rx_fuid.u.first[0].epochs,
                                  upper_instr: rx_fuid.u.first[0].upper_instr,
                                  drop_instr: True,
                                  instpkt : tagged None
                                `ifdef no_wawstalls 
                                  ,id: rx_fuid.u.first[0].id
                                `endif
                                `ifdef spfpu
                                  ,rdtype : rx_fuid.u.first[0].rdtype
                                `endif } ;

      wr_commitlog[0] <= default_commitlog;
      wr_fuid[0] <= default_common;
    endrule

    rule rl_2nd_instruction_invalid(rx_fuid.u.first[1].insttype == NONE && tx_fuid.u.notFull());
      let default_common = CUid { pc : rx_fuid.u.first[1].pc,
                                  rd : rx_fuid.u.first[1].rd,
                                  epochs: rx_fuid.u.first[1].epochs,
                                  upper_instr: rx_fuid.u.first[1].upper_instr,
                                  drop_instr: True,
                                  instpkt : tagged None
                                `ifdef no_wawstalls 
                                  ,id: rx_fuid.u.first[1].id
                                `endif
                                `ifdef spfpu
                                  ,rdtype : rx_fuid.u.first[1].rdtype
                                `endif } ;

      wr_commitlog[1] <= default_commitlog;
      wr_fuid[1] <= default_common;
    endrule

    rule rl_update_pipeline;
      Vector#(`num_issue, CUid) fuid;
      `ifdef rtldump
        Vector#(`num_issue, CommitLogPacket) commitlog;
      `endif
      for (Integer i=0; i<`num_issue; i=i+1) begin
        fuid[i] = wr_fuid[i];
        `ifdef rtldump
          commitlog[i] = wr_commitlog[i];
        `endif
      end
      // Drop upper instruction if lower instruction generates a trap.
      if (!fuid[0].upper_instr &&& fuid[0].instpkt matches tagged TRAP .t) begin
        //`logLevel( stage3, 0, $format("[%2d]STAGE4: Dropping upper instruction as lower instruction generated a TRAP", hartid), wr_simulate_log_start)
        fuid[1].drop_instr = True;
        //fuid[1].epochs = ~fuid[1].epochs;
        //fuid[1].instpkt = tagged None;
        //fuid[1].rd = 0;
        //fuid[1].pc = ?;
        //`ifdef spfpu
        //  fuid[1].rdtype = IRF;
        //`endif
        //`ifdef rtldump
        //  commitlog[1] = default_commitlog;
        //`endif
      end
      //tx_fuid.u.enq(unpack({pack(wr_fuid[1]), pack(wr_fuid[0])}));
      tx_fuid.u.enq(fuid);
      rx_fuid.u.deq;
    `ifdef rtldump
      //tx_commitlog.u.enq(unpack({pack(wr_commitlog[1]), pack(wr_commitlog[0])}));
      tx_commitlog.u.enq(commitlog);
      rx_commitlog.u.deq;
    `endif
    endrule
`endif

    interface rx = interface Ifc_s4_rx
`ifndef DUAL_ISSUE
      interface rx_baseout_from_stage3 = rx_baseout.e;
      interface rx_trapout_from_stage3 = rx_trapout.e;
      interface rx_systemout_from_stage3  = rx_systemout.e;
      interface rx_memoryout_from_stage3 = rx_memoryout.e;
`endif
      interface rx_fuid_from_stage3 = rx_fuid.e;
      `ifdef etrace_support 
      interface rx_ingress_opcode = rx_ingress_opcode.e;
      `endif
    `ifdef rtldump
      interface rx_commitlog = rx_commitlog.e;
    `endif
    endinterface;

`ifdef DUAL_ISSUE
  `ifdef perfmonitors
    interface perf = interface Ifc_s4_perfmonitors
      method mv_count_isb3_isb4_empty = pack(!(rx_fuid.u.notEmpty));
      method mv_count_isb4_isb5_full = pack(!(tx_fuid.u.notFull));
    endinterface;
  `endif
`endif

    interface tx = interface Ifc_s4_tx
`ifndef DUAL_ISSUE
      interface tx_systemout_to_stage5  = tx_systemout.e;
      interface tx_trapout_to_stage5  = tx_trapout.e;
      interface tx_baseout_to_stage5 = tx_baseout.e;
      interface tx_memio_to_stage5 = tx_memio.e;
`endif
      interface tx_fuid_to_stage5 = tx_fuid.e;
      `ifdef etrace_support 
      interface tx_ingress_opcode = tx_ingress_opcode.e;
      `endif
    `ifdef rtldump
      interface tx_commitlog = tx_commitlog.e;
    `endif
    endinterface;
    interface cache = interface Ifc_s4_cache
      interface  memory_response= interface Put
      method Action put (DMem_core_response#(`elen,1) response)if(ff_memory_response.notFull);
          ff_memory_response.enq(response);
        endmethod
      endinterface;
    endinterface;
  `ifdef muldiv
    interface s4_mbox = interface Ifc_s4_muldiv
      interface rx_mbox_output = rx_mbox.e;
      `ifdef arith_trap
        interface rx_mbox_arith_trap_output = rx_mbox_arith_trap_output.e;
      `endif
    endinterface;
  `endif
  `ifdef spfpu
  interface s4_fbox = interface Ifc_s4_float
    interface rx_fbox_output = rx_fbox.e;
  endinterface;
`endif
  endmodule:mkstage4
endpackage: stage4

