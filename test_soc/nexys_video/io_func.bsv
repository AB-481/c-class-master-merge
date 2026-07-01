/* 
See LICENSE.iitm for license details
*/

package io_func;

  `include "Soc.defines"

  // this function is used to indicate the caches which are the non-cacheable regions within the
  // Soc.
  function Bool isIO(Bit#(`paddr) addr, Bool cacheable);
	  if(!cacheable)
		  return True;
    else if(addr >= `MemoryBase && addr <= `MemoryEnd )
      return False;
    else if (addr >= `BootBase && addr <= `BootEnd)
      return False;
	  else
		  return True;
  endfunction

endpackage


