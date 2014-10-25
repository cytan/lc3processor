import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module l1_cache
(
	input clk,
	
	/* cpu to l1_cache signals */
	input mem_read,
	input mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	
	output mem_resp,
	output lc3b_word mem_rdata,
	
	/* l1 cache to arbiter signals */
	input lc3b_cache_line arb_mem_rdata,
	input arb_mem_resp,
	
	output arb_mem_read, 
	output arb_mem_write,
	output lc3b_cache_line arb_mem_wdata,
	output lc3b_word arb_mem_address
);

	logic va0_w, va1_w, 		// valid bit array load signals
			ta0_w, ta1_w, 		// tag array load signals
			da0_w, da1_w,		// data array load signals
			dba0_w, dba1_w,	// dirty bit array load signals
			la_w,					// LRU bit array load signal
			lru_in,
			dba_in,		
			datamux_sel,		
			dawmux_sel;
	
	lc3b_mux4sel addrmux_sel;
			
	logic hit,  
			comp0_out,
			comp1_out,
			lru_out,
			dba0_out,
			dba1_out,
			vba0_out,
			vba1_out;

cache_datapath cache_datapath
(
	.clk,
	
	.va0_w,
	.va1_w,
	.ta0_w,
	.ta1_w,
	.da0_w,
	.da1_w,
	.dba0_w,
	.dba1_w,
	.la_w,
	.lru_in,
	.dba_in,
	.datamux_sel,
	.dawmux_sel,
	.addrmux_sel,
	
	.mem_wdata,
	.mem_address,
	.mem_read,
	.mem_write,
	.mem_byte_enable,
	
	.arb_mem_rdata,
	
	.hit,
	.comp0_out,
	.comp1_out,
	.lru_out,
	.dba0_out,
	.dba1_out,
	.vba0_out,
	.vba1_out,
	
	.mem_rdata,
	.arb_mem_wdata,
	.arb_mem_address
);

cache_control cache_control
(
	.clk,
	.mem_read,
	.mem_write,
	
	.hit,
	.comp0_out,
	.comp1_out,
	.lru_out,
	.dba0_out,
	.dba1_out,
	.vba0_out,
	.vba1_out,
	
	.arb_mem_resp,
	
	.va0_w,
	.va1_w,
	.ta0_w,
	.ta1_w,
	.da0_w,
	.da1_w,
	.dba0_w,
	.dba1_w,
	.la_w,
	.lru_in,
	.dba_in,
	.datamux_sel,
	.dawmux_sel,
	.addrmux_sel,
	
	.arb_mem_read,
	.arb_mem_write,
	.mem_resp
);

endmodule: l1_cache