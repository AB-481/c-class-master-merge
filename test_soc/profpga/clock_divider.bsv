// See LICENSE.iitm for license details

package clock_divider;
  /*=== Project imports ==*/
  import Clocks::*;
  /*======================*/
  // =========================== Clock divider module ================ //
  interface Ifc_clock_divider#(numeric type width);
    interface Clock slowclock;
    method Action divisor(Bit#(width) in);
  endinterface

  module mkclock_divider(Ifc_clock_divider#(width));
    let defclock <- exposeCurrentClock;
    Reg#(Bit#(1)) clk <- mkRegA(1);
    Reg#(Bit#(width)) rg_divisor <- mkRegA(0);
	Reg#(Bit#(width)) rg_half_divisor <- mkRegA(0);
    Reg#(Bit#(width)) rg_counter <- mkRegA(0);
    MakeClockIfc#(Bit#(1)) new_clock <- mkUngatedClock(0);
    MuxClkIfc clock_selector <- mkUngatedClockMux(new_clock.new_clk,defclock);
    Bool clockmux_sel = rg_divisor!=0;
    rule increment_counter(rg_divisor != 0);
		if(rg_counter <= rg_half_divisor)
			clk <= 1;
		else
			clk <= 0;
		if(rg_counter == rg_divisor)
			rg_counter <= 0;
		else
			rg_counter <= rg_counter + 1;
    endrule

    rule generate_clock;
      new_clock.setClockValue(clk);
    endrule

    rule select_clock;
      clock_selector.select(clockmux_sel);
    endrule

    method Action divisor(Bit#(width) in);
	  rg_half_divisor <= in >> 1;
      rg_divisor <= in;
    endmethod

    interface slowclock=clock_selector.clock_out;
  endmodule
  // ============================================================== //
  
endpackage
