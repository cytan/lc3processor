import lc3b_types::*;

// this module supports the word/byte writes to a cache line
module write_byte_to_cache
(
	input lc3b_cache_line datamux_out,
	input lc3b_word mem_wdata,
						 mem_address,
	input lc3b_mem_wmask mem_byte_enable,
						 
	output lc3b_cache_line data_write
);

logic [1:0] dec_out[7:0];

decoder_3to8 #(.width(2)) dec3
(
	.sel(mem_address[3:1]),
	.dec_out
);

mux4 byte_mux_0
(
	.sel(dec_out[0] & mem_byte_enable),
	.a(datamux_out[15:0]),
	.b({datamux_out[15:8], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[7:0]}),
	.d(mem_wdata[15:0]),
	.f(data_write[15:0])
);

mux4 byte_mux_1
(
	.sel(dec_out[1] & mem_byte_enable),
	.a(datamux_out[31:16]),
	.b({datamux_out[31:24], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[23:16]}),
	.d(mem_wdata[15:0]),
	.f(data_write[31:16])
);

mux4 byte_mux_2
(
	.sel(dec_out[2] & mem_byte_enable),
	.a(datamux_out[47:32]),
	.b({datamux_out[47:40], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[39:32]}),
	.d(mem_wdata[15:0]),
	.f(data_write[47:32])
);

mux4 byte_mux_3
(
	.sel(dec_out[3] & mem_byte_enable),
	.a(datamux_out[63:48]),
	.b({datamux_out[63:56], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[55:48]}),
	.d(mem_wdata[15:0]),
	.f(data_write[63:48])
);

mux4 byte_mux_4
(
	.sel(dec_out[4] & mem_byte_enable),
	.a(datamux_out[79:64]),
	.b({datamux_out[79:72], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[71:64]}),
	.d(mem_wdata[15:0]),
	.f(data_write[79:64])
);

mux4 byte_mux_5
(
	.sel(dec_out[5] & mem_byte_enable),
	.a(datamux_out[95:80]),
	.b({datamux_out[95:88], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[87:80]}),
	.d(mem_wdata[15:0]),
	.f(data_write[95:80])
);

mux4 byte_mux_6
(
	.sel(dec_out[6] & mem_byte_enable),
	.a(datamux_out[111:96]),
	.b({datamux_out[111:104], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[103:96]}),
	.d(mem_wdata[15:0]),
	.f(data_write[111:96])
);

mux4 byte_mux_7
(
	.sel(dec_out[7] & mem_byte_enable),
	.a(datamux_out[127:112]),
	.b({datamux_out[127:120], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], datamux_out[119:112]}),
	.d(mem_wdata[15:0]),
	.f(data_write[127:112])
);

endmodule: write_byte_to_cache