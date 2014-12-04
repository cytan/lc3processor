import lc3b_types::*;

module btb_datapath
(
	input clk,
	
	input write, uc,								//uc = unconditional
	
	input logic [3:0] index_fetch, index_mem,		//fetch is used to read from btb
	input logic [11:0] tag_fetch, tag_mem,			//mem is used to write to btb (in case of simultaneous reads and writes) 
	input lc3b_word target,
	
	output lc3b_word 	out,
	output logic 		uc_out, hit
);

logic 			va0_out, va1_out, va2_out, va3_out;
logic			comp0_out, comp1_out, comp2_out, comp3_out;
logic			uc0_out, uc1_out, uc2_out, uc3_out, ucmux_out;
logic			h0, h1, h2, h3;
logic 			wr_lru, wr0, wr1, wr2, wr3;
logic			r0, r1, r2, r3;
logic [1:0]		set_sel;
logic [2:0] 	lru_out, next_lru;
logic [11:0] 	tag0_out, tag1_out, tag2_out, tag3_out;
lc3b_word 		data0_out, data1_out, data2_out, data3_out;

assign h0 = va0_out & comp0_out;
assign h1 = va1_out & comp1_out;
assign h2 = va2_out & comp2_out;
assign h3 = va3_out & comp3_out;

assign wr0 = r0 & write;
assign wr1 = r1 & write;
assign wr2 = r2 & write;
assign wr3 = r3 & write;
assign wr_lru = wr0 | wr1 | wr2 | wr3;

assign hit = h0 | h1 | h2 | h3;
assign uc_out = ucmux_out & hit;


encoder4to2 sel_gen
(
	.a(h0),
	.b(h1),
	.c(h2),
	.d(h3),
	.f(set_sel)
);

//LRU

lru_rom lrurom
(
	.h0(r0),
	.h1(r1),
	.h2(r2),
	.h3(r3),
	.lru(lru_out),
	.next_lru
);

l2_array_b #(.width(3)) lru
(
	.clk,
	.write(wr_lru),
	.index(index_mem),
	.datain(next_lru),
	.dataout(lru_out)
);

//VALID ARRAYS
btb_array #(.width(1)) va0
(
	.clk,
	.write(wr0),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(1'b1),
	.dataout(va0_out)
);

btb_array #(.width(1)) va1
(
	.clk,
	.write(wr1),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(1'b1),
	.dataout(va1_out)
);

btb_array #(.width(1)) va2
(
	.clk,
	.write(wr2),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(1'b1),
	.dataout(va2_out)
);

btb_array #(.width(1)) va3
(
	.clk,
	.write(wr3),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(1'b1),
	.dataout(va3_out)
);

//TAG ARRAYS and COMPARATORS
btb_array #(.width(12)) tag0
(
	.clk,
	.write(wr0),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(tag_mem),
	.dataout(tag0_out)
);

btb_array #(.width(12)) tag1
(
	.clk,
	.write(wr1),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(tag_mem),
	.dataout(tag1_out)
);

btb_array #(.width(12)) tag2
(
	.clk,
	.write(wr2),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(tag_mem),
	.dataout(tag2_out)
);

btb_array #(.width(12)) tag3
(
	.clk,
	.write(wr3),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(tag_mem),
	.dataout(tag3_out)
);

comparator #(.width(12)) comp0
(
	.a(tag_fetch),
	.b(tag0_out),
	.f(comp0_out)
);

comparator #(.width(12)) comp1
(
	.a(tag_fetch),
	.b(tag1_out),
	.f(comp1_out)
);

comparator #(.width(12)) comp2
(
	.a(tag_fetch),
	.b(tag2_out),
	.f(comp2_out)
);

comparator #(.width(12)) comp3
(
	.a(tag_fetch),
	.b(tag3_out),
	.f(comp3_out)
);

//UNCONDITIONAL ARRAYS
btb_array #(.width(1)) uc0
(
	.clk,
	.write(wr0),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(uc),
	.dataout(uc0_out)
);

btb_array #(.width(1)) uc1
(
	.clk,
	.write(wr1),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(uc),
	.dataout(uc1_out)
);

btb_array #(.width(1)) uc2
(
	.clk,
	.write(wr2),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(uc),
	.dataout(uc2_out)
);

btb_array #(.width(1)) uc3
(
	.clk,
	.write(wr3),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(uc),
	.dataout(uc3_out)
);

mux4 #(.width(1)) ucmux
(
	.sel(set_sel),
	.a(uc0_out),
	.b(uc1_out),
	.c(uc2_out),
	.d(uc3_out),
	.f(ucmux_out)
);

//DATA ARRAYS
btb_array data0
(
	.clk,
	.write(wr0),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(target),
	.dataout(data0_out)
);

btb_array data1
(
	.clk,
	.write(wr1),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(target),
	.dataout(data1_out)
);

btb_array data2
(
	.clk,
	.write(wr2),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(target),
	.dataout(data2_out)
);

btb_array data3
(
	.clk,
	.write(wr3),
	.read_index(index_fetch),
	.write_index(index_mem),
	.datain(target),
	.dataout(data3_out)
);

mux4 #(.width(16)) datamux
(
	.sel(set_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(out)
);

lru_replace write_gen
(
	.lru_out,
	.r0,
	.r1,
	.r2,
	.r3
);

endmodule : btb_datapath