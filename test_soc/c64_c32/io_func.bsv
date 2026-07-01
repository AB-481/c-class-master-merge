// See LICENSE.iitm for license details


package io_func;
 `include "Soc.defines"
  // this function is used to indicate the caches which are the non-cacheable regions within the
  // Soc.
  function Bool isIO(Bit#(`paddr) addr, Bool cacheable);
	  if(!cacheable)
		  return True;
    else if (addr >= `BootRomBase && addr <= `BootRomEnd)
      return False;
    else if(addr<'h80000000)
      return True;
	  else
		  return False;
  endfunction

endpackage

