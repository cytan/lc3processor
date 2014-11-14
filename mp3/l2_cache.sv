import lc3b_types::*;

module l2_cache
(
	input	clk,
	
	/* arbiter signals */
	input lc3b_word		l2arb_mem_address,
	input 					l2arb_mem_read,
	input 					l2arb_mem_write,
	input lc3b_cache_line	l2arb_mem_wdata,
	output lc3b_cache_line	l2arb_mem_rdata,
	output logic 			l2arb_mem_resp,
	
	/* memory signals */
	output lc3b_word		pmem_address,
	output logic			pmem_read,
	output logic 			pmem_write,
	output lc3b_cache_line	pmem_wdata,
	input lc3b_cache_line	pmem_rdata,
	input 					pmem_resp	
);

	logic wr_va0, wr_va1, wr_va2, wr_va3, 		// valid bit array load signals
			wr_ta0, wr_ta1, wr_ta2, wr_ta3, 		// tag array load signals
			wr_da0, wr_da1, wr_da2, wr_da3,		// data array load signals
			wr_dba0, wr_dba1, wr_dba2, wr_dba3,	// dirty bit array load signals
			wr_lru,									// LRU bit array load signal
			dba_in, dirty,
			hit, h0, h1, h2, h3,					// one-hot hit bit
			r0, r1, r2, r3;						// one-hot replace bit
	
	logic 	din_sel;
	logic 	addrmux_sel;
	lc3b_2bit	hit_num;
	lc3b_2bit	replace;
	lc3b_2bit	dout_sel;
	
l2_cache_datapath l2_datapath
(
	.clk,
	
	/* external signals */
	.l2arb_mem_address,
	.l2arb_mem_wdata,
	.l2arb_mem_rdata,
	.pmem_address,
	.pmem_wdata,
	.pmem_rdata,
	
	/* cache internal signals */
	.wr_va0,
	.wr_va1,
	.wr_va2,
	.wr_va3,
	.wr_ta0,
	.wr_ta1,
	.wr_ta2,
	.wr_ta3,
	.wr_da0,
	.wr_da1,
	.wr_da2,
	.wr_da3,
	.wr_dba0,
	.wr_dba1,
	.wr_dba2,
	.wr_dba3,
	.wr_lru,
	
	.dba_in,
	.dirty,
	.hit,
	.h0,
	.h1,
	.h2,
	.h3,
	.r0,
	.r1,
	.r2,
	.r3,
	.din_sel,
	.addrmux_sel,
	.hit_num,
	.replace,
	.dout_sel
);

l2_cache_control l2_control
(
	.clk,
	
	/* external signals */
	.l2arb_mem_read,
	.l2arb_mem_write,
	.l2arb_mem_resp,
	.pmem_read,
	.pmem_write,
	.pmem_resp,
	
	/* cache internal signals */
	.wr_va0,
	.wr_va1,
	.wr_va2,
	.wr_va3,
	.wr_ta0,
	.wr_ta1,
	.wr_ta2,
	.wr_ta3,
	.wr_da0,
	.wr_da1,
	.wr_da2,
	.wr_da3,
	.wr_dba0,
	.wr_dba1,
	.wr_dba2,
	.wr_dba3,
	.wr_lru,
	
	.dba_in,
	.dirty,
	.hit,
	.h0,
	.h1,
	.h2,
	.h3,
	.r0,
	.r1,
	.r2,
	.r3,
	.din_sel,
	.addrmux_sel,
	.hit_num,
	.replace,
	.dout_sel
);
			
			
endmodule: l2_cache			
			
			
