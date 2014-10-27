import lc3b_types::*;

module arbiter
(
	input clk,
	
	/*i-cache signals*/
	input lc3b_word i_arb_mem_address,
	input i_arb_mem_read,
	output lc3b_cache_line i_arb_mem_rdata,
	output logic i_arb_mem_resp,
	
	/*d-cache signals*/
	input lc3b_word d_arb_mem_address,
	input d_arb_mem_read,
			d_arb_mem_write,
	input lc3b_cache_line d_arb_mem_wdata,
	output lc3b_cache_line d_arb_mem_rdata,	
	output logic d_arb_mem_resp,
	
	/*l2 cache signals*/
	output lc3b_word l2arb_mem_address,
	output logic l2arb_mem_read,
					 l2arb_mem_write,
	output lc3b_cache_line l2arb_mem_wdata,
	input lc3b_cache_line l2arb_mem_rdata,
	input logic l2arb_mem_resp
);

logic addrmux_sel,
		readmux_sel,
		writemux_sel,
		wdatamux_sel,
		rdatademux_sel,
		respdemux_sel;

mux2 addrmux
(
	.sel(addrmux_sel),
	.a(i_arb_mem_address),
	.b(d_arb_mem_address),
	.f(l2arb_mem_address)
);

mux2 #(.width(1)) readmux
(
	.sel(readmux_sel),
	.a(i_arb_mem_read),
	.b(d_arb_mem_read),
	.f(l2arb_mem_address)
);

mux2 #(.width(1)) writemux
(
	.sel(writemux_sel),
	.a(1'b0),
	.b(d_arb_mem_write),
	.f(l2arb_mem_address)
);

mux2 #(.width(128)) wdatamux
(
	.sel(wdatamux_sel),
	.a(128'b0),
	.b(d_arb_mem_wdata),
	.f(l2arb_mem_address)
);

demux2 #(.width(128)) rdatademux
(
	.sel(rdatademux_sel),
	.f(l2arb_mem_rdata),
	.a(i_arb_mem_rdata),
	.b(d_arb_mem_rdata)
);

demux2 #(.width(1)) respdemux
(
	.sel(respdemux_sel),
	.f(l2arb_mem_resp),
	.a(i_arb_mem_resp),
	.b(d_arb_mem_resp)
);

arbiter_control control
(
	.clk,
	.i_arb_mem_read,
	.d_arb_mem_read,
	.d_arb_mem_write,
	.l2arb_mem_resp,
	.addrmux_sel,
	.readmux_sel,
	.writemux_sel,
	.wdatamux_sel,
	.rdatademux_sel,
	.respdemux_sel
);
	
	
endmodule: arbiter