import lc3b_types::*;

module cache_datapath
(
		input clk,
		
		/*control signals*/
		input va0_w, va1_w, 		// valid bit array load signals
				ta0_w, ta1_w, 		// tag array load signals
				da0_w, da1_w,		// data array load signals
				dba0_w, dba1_w,	// dirty bit array load signals
				la_w,					// LRU bit array load signal
				lru_in,
				dba_in,		
				datamux_sel,		
				dawmux_sel,
		
		input lc3b_mux4sel addrmux_sel,	//select signal to choose what pmem_address should be
				
		/* memory signals */
		input lc3b_word mem_wdata,
		input lc3b_word mem_address,
		input mem_read, mem_write,
		input lc3b_mem_wmask mem_byte_enable,
		input lc3b_cache_line arb_mem_rdata,
		
		/* output signals */
		output logic hit,  
				 comp0_out,
				 comp1_out,
				 lru_out,
				 dba0_out,
				 dba1_out,
				 vba0_out,
				 vba1_out,
		output lc3b_word mem_rdata,
		output lc3b_cache_line arb_mem_wdata,
		output lc3b_word arb_mem_address
);

/* Internal signals */
//logic vba0_out, vba1_out;
lc3b_cache_tag ta0_out, ta1_out;
lc3b_cache_line da0_out, da1_out;

lc3b_cache_line dawmux_out,
					 datamux_out,
					 data_write;
					 
lc3b_c_index		addr_index;
lc3b_cache_tag		addr_tag;

assign addr_tag 	= mem_address[15:8];
assign addr_index	= mem_address[7:4];
					 
array #(.width(1)) valid_bit_array_0
(
	.clk,
	.write(va0_w),
	.index(addr_index),
	.datain(1'b1),
	.dataout(vba0_out)
);

array #(.width(1)) valid_bit_array_1
(
	.clk,
	.write(va1_w),
	.index(addr_index),
	.datain(1'b1),
	.dataout(vba1_out)
);

array #(.width(8)) tag_array_0
(
	.clk,
	.write(ta0_w),
	.index(addr_index),
	.datain(addr_tag),
	.dataout(ta0_out)
);

array #(.width(8)) tag_array_1
(
	.clk,
	.write(ta1_w),
	.index(addr_index),
	.datain(addr_tag),
	.dataout(ta1_out)
);

array data_array_0
(
	.clk,
	.write(da0_w),
	.index(addr_index),
	.datain(dawmux_out),
	.dataout(da0_out)
);

array data_array_1
(
	.clk,
	.write(da1_w),
	.index(addr_index),
	.datain(dawmux_out),
	.dataout(da1_out)
);

array #(.width(1)) dirty_bit_array_0
(
	.clk,
	.write(dba0_w),
	.index(addr_index),
	.datain(dba_in),
	.dataout(dba0_out)
);

array #(.width(1)) dirty_bit_array_1
(
	.clk,
	.write(dba1_w),
	.index(addr_index),
	.datain(dba_in),
	.dataout(dba1_out)
);

array #(.width(1)) lru_array
(
	.clk,
	.write(la_w),
	.index(addr_index),
	.datain(lru_in),
	.dataout(lru_out)
);

comparator #(.width(8)) tag_comp0
(
	.a(addr_tag),
	.b(ta0_out),
	.f(comp0_out)
);

comparator #(.width(8)) tag_comp1
(
	.a(addr_tag),
	.b(ta1_out),
	.f(comp1_out)
);

mux2 #(.width(128)) datamux
(
	.sel(datamux_sel),
	.a(da0_out),
	.b(da1_out),
	.f(datamux_out)
);

mux2 #(.width(128)) dawmux
(
	.sel(dawmux_sel),
	.a(data_write),
	.b(arb_mem_rdata),
	.f(dawmux_out)
);

mux8 #(.width(16)) c_line_2_word
(
	.sel(mem_address[3:1]),
	.a(datamux_out[15:0]),
	.b(datamux_out[31:16]),
	.c(datamux_out[47:32]),
	.d(datamux_out[63:48]),
	.h(datamux_out[79:64]),
	.i(datamux_out[95:80]),
	.j(datamux_out[111:96]),
	.k(datamux_out[127:112]),
	.f(mem_rdata)
);

write_byte_to_cache wbyte2cache
(
	.datamux_out,
	.mem_wdata,
	.mem_address,
	.mem_byte_enable,
	.data_write
);

mux4 #(.width(16)) addrmux
(
	.sel(addrmux_sel),
	.a(mem_address),
	.b({ta0_out, mem_address[7:0]}),
	.c({ta1_out, mem_address[7:0]}),
	.d(16'b0),
	.f(arb_mem_address)
);

assign hit = (vba0_out && comp0_out) | (vba1_out && comp1_out);
assign arb_mem_wdata = datamux_out;

endmodule: cache_datapath
							 
		
							