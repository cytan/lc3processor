import lc3b_types::*;

module l2_cache_datapath
(
	input	clk,
	
	/* external signals */
	input lc3b_word			l2arb_mem_address,
	input lc3b_cache_line	l2arb_mem_wdata,
	output lc3b_cache_line	l2arb_mem_rdata,
	output lc3b_word			pmem_address,
	output lc3b_cache_line	pmem_wdata,
	input lc3b_cache_line	pmem_rdata,
	
	/* cache internal signals */
	input wr_va0, wr_va1, wr_va2, wr_va3,
	input wr_ta0, wr_ta1, wr_ta2, wr_ta3,
	input wr_da0, wr_da1, wr_da2, wr_da3,
	input wr_dba0, wr_dba1, wr_dba2, wr_dba3,
	input wr_lru,
	
	input dba_in,
	output logic dirty,
	output logic hit,
	output logic h0, h1, h2, h3,
	output logic r0, r1, r2, r3,
	
	input din_sel,
	input addrmux_sel,
	output lc3b_2bit	hit_num,
	output lc3b_2bit	replace,
	input	 lc3b_2bit	dout_sel
);

/********************/
/* internal signals */
/********************/
lc3b_cache_line	dinmux_out;
lc3b_cache_line	da0_out, da1_out, da2_out, da3_out;
lc3b_l2_tag			ta0_out, ta1_out, ta2_out, ta3_out;
lc3b_l2_tag			tagmux_out;
lc3b_3bit			next_lru;
lc3b_3bit			lru_out;
logic 				va0_out, va1_out, va2_out, va3_out;
logic					dba0_out, dba1_out, dba2_out, dba3_out;
logic					comp0_out, comp1_out, comp2_out, comp3_out;


/*******************/
/* data array unit */
/*******************/
mux2 #(.width(128)) dinmux
(
	.sel(din_sel),
	.a(pmem_rdata),
	.b(l2arb_mem_wdata),
	.f(dinmux_out)
);

l2_array data_array_0
(
	.clk,
	.write(wr_da0),
	.index(l2arb_mem_address[7:4]),
	.datain(dinmux_out),
	.dataout(da0_out)
);

l2_array data_array_1
(
	.clk,
	.write(wr_da1),
	.index(l2arb_mem_address[7:4]),
	.datain(dinmux_out),
	.dataout(da1_out)
);

l2_array data_array_2
(
	.clk,
	.write(wr_da2),
	.index(l2arb_mem_address[7:4]),
	.datain(dinmux_out),
	.dataout(da2_out)
);

l2_array data_array_3
(
	.clk,
	.write(wr_da3),
	.index(l2arb_mem_address[7:4]),
	.datain(dinmux_out),
	.dataout(da3_out)
);

mux4 #(.width(128)) doutmux
(
	.sel(dout_sel),
	.a(da0_out),
	.b(da1_out),
	.c(da2_out),
	.d(da3_out),
	.f(pmem_wdata)
);

assign l2arb_mem_rdata = pmem_wdata;


/***********************/
/* tag comparison unit */
/***********************/
l2_array #(.width(8)) tag_array_0
(
	.clk,
	.write(wr_ta0),
	.index(l2arb_mem_address[7:4]),
	.datain(l2arb_mem_address[15:8]),
	.dataout(ta0_out)
);

l2_array #(.width(8)) tag_array_1
(
	.clk,
	.write(wr_ta1),
	.index(l2arb_mem_address[7:4]),
	.datain(l2arb_mem_address[15:8]),
	.dataout(ta1_out)
);

l2_array #(.width(8)) tag_array_2
(
	.clk,
	.write(wr_ta2),
	.index(l2arb_mem_address[7:4]),
	.datain(l2arb_mem_address[15:8]),
	.dataout(ta2_out)
);

l2_array #(.width(8)) tag_array_3
(
	.clk,
	.write(wr_ta3),
	.index(l2arb_mem_address[7:4]),
	.datain(l2arb_mem_address[15:8]),
	.dataout(ta3_out)
);

comparator #(.width(8)) tag_comp0
(
	.a(l2arb_mem_address[15:8]),
	.b(ta0_out),
	.f(comp0_out)
);

comparator #(.width(8)) tag_comp1
(
	.a(l2arb_mem_address[15:8]),
	.b(ta1_out),
	.f(comp1_out)
);

comparator #(.width(8)) tag_comp2
(
	.a(l2arb_mem_address[15:8]),
	.b(ta2_out),
	.f(comp2_out)
);

comparator #(.width(8)) tag_comp3
(
	.a(l2arb_mem_address[15:8]),
	.b(ta3_out),
	.f(comp3_out)
);

l2_array #(.width(1)) valid_bit_array_0
(
	.clk,
	.write(wr_va0),
	.index(l2arb_mem_address[7:4]),
	.datain(1'b1),
	.dataout(va0_out)
);

l2_array #(.width(1)) valid_bit_array_1
(
	.clk,
	.write(wr_va1),
	.index(l2arb_mem_address[7:4]),
	.datain(1'b1),
	.dataout(va1_out)
);

l2_array #(.width(1)) valid_bit_array_2
(
	.clk,
	.write(wr_va2),
	.index(l2arb_mem_address[7:4]),
	.datain(1'b1),
	.dataout(va2_out)
);

l2_array #(.width(1)) valid_bit_array_3
(
	.clk,
	.write(wr_va3),
	.index(l2arb_mem_address[7:4]),
	.datain(1'b1),
	.dataout(va3_out)
);

assign h0 = va0_out & comp0_out;
assign h1 = va1_out & comp1_out;
assign h2 = va2_out & comp2_out;
assign h3 = va3_out & comp3_out;

assign hit = h0 | h1 | h2 | h3;

encoder4to2 hit_encoder
(
	.a(h0),
	.b(h1),
	.c(h2),
	.d(h3),
	.f(hit_num)
);

mux4 #(.width(8)) tagmux
(
	.sel(replace),
	.a(ta0_out),
	.b(ta1_out),
	.c(ta2_out),
	.d(ta3_out),
	.f(tagmux_out)
);

mux2 addrmux
(
	.sel(addrmux_sel),
	.a(l2arb_mem_address),
	.b({tagmux_out, l2arb_mem_address[7:0]}),
	.f(pmem_address)
);

/******************************/
/* LRU & dirty bit array unit */
/******************************/
l2_array #(.width(3)) lru
(
	.clk,
	.write(wr_lru),
	.index(l2arb_mem_address[7:4]),
	.datain(next_lru),
	.dataout(lru_out)
);

lru_rom lrurom
(
	.h0,
	.h1,
	.h2,
	.h3,
	.lru(lru_out),
	.next_lru
);

lru_replace lrureplace
(
	.lru_out,
	.r0,
	.r1,
	.r2,
	.r3
);

encoder4to2	lru_encoder
(
	.a(r0),
	.b(r1),
	.c(r2),
	.d(r3),
	.f(replace)
);

l2_array #(.width(1)) dirty_bit_array_0
(
	.clk,
	.write(wr_dba0),
	.index(l2arb_mem_address[7:4]),
	.datain(dba_in),
	.dataout(dba0_out)
);

l2_array #(.width(1)) dirty_bit_array_1
(
	.clk,
	.write(wr_dba1),
	.index(l2arb_mem_address[7:4]),
	.datain(dba_in),
	.dataout(dba1_out)
);

l2_array #(.width(1)) dirty_bit_array_2
(
	.clk,
	.write(wr_dba2),
	.index(l2arb_mem_address[7:4]),
	.datain(dba_in),
	.dataout(dba2_out)
);

l2_array #(.width(1)) dirty_bit_array_3
(
	.clk,
	.write(wr_dba3),
	.index(l2arb_mem_address[7:4]),
	.datain(dba_in),
	.dataout(dba3_out)
);

mux4 #(.width(1)) dirtymux
(
	.sel(replace),
	.a(dba0_out),
	.b(dba1_out),
	.c(dba2_out),
	.d(dba3_out),
	.f(dirty)
);



endmodule : l2_cache_datapath