import lc3b_types::*;

module mp3_w_l1cache
(
    input clk,

    /* Memory signals */
	output 					read, write,
	output lc3b_word 		address,
	output lc3b_cache_line 	wdata,
	
	input 					resp,
	input lc3b_cache_line 	rdata
);

logic 						inst_mem_resp;
logic 						data_mem_resp;
lc3b_word 					inst_mem_rdata;
lc3b_word 					data_mem_rdata;
logic						inst_mem_read;
logic						data_mem_read;
logic						inst_mem_write;
logic 						data_mem_write;
lc3b_mem_wmask				inst_mem_byte_enable;
lc3b_mem_wmask				data_mem_byte_enable;
lc3b_word 					inst_mem_addr;
lc3b_word					data_mem_addr;
lc3b_word 					inst_mem_wdata;
lc3b_word					data_mem_wdata;
lc3b_cache_line				icache_mem_rdata;
lc3b_cache_line				dcache_mem_rdata;
logic						icache_mem_resp;
logic						dcache_mem_resp;
logic						icache_mem_read;
logic						dcache_mem_read;
logic						icache_mem_write;
logic						dcache_mem_write;
lc3b_word 					icache_mem_address;
lc3b_word					dcache_mem_address;
lc3b_cache_line				icache_mem_wdata;
lc3b_cache_line				dcache_mem_wdata;



/* Instantiate MP3 top level blocks here 
	Currently implementing processor w/o cache */

cpu CPU
(
	.clk,
	.inst_mem_resp,
	.data_mem_resp,
	.inst_mem_rdata,
	.data_mem_rdata,
	.inst_mem_read,
	.data_mem_read,
	.inst_mem_write,
	.data_mem_write,
	.inst_mem_byte_enable,
	.data_mem_byte_enable,
	.inst_mem_addr,
	.data_mem_addr,
	.inst_mem_wdata,
	.data_mem_wdata
);

l1_cache icache
(
	.clk,
	.mem_read(inst_mem_read),
	.mem_write(inst_mem_write),
	.mem_byte_enable(inst_mem_byte_enable),
	.mem_address(inst_mem_addr),
	.mem_wdata(inst_mem_wdata),
	.mem_resp(inst_mem_resp),
	.mem_rdata(inst_mem_rdata),
	.arb_mem_rdata(icache_mem_rdata),
	.arb_mem_resp(icache_mem_resp),
	.arb_mem_read(icache_mem_read), 
	.arb_mem_write(icache_mem_write),
	.arb_mem_wdata(icache_mem_wdata),
	.arb_mem_address(icache_mem_address)
);

l1_cache dcache
(
	.clk,
	.mem_read(data_mem_read),
	.mem_write(data_mem_write),
	.mem_byte_enable(data_mem_byte_enable),
	.mem_address(data_mem_addr),
	.mem_wdata(data_mem_wdata),
	.mem_resp(data_mem_resp),
	.mem_rdata(data_mem_rdata),
	.arb_mem_rdata(dcache_mem_rdata),
	.arb_mem_resp(dcache_mem_resp),
	.arb_mem_read(dcache_mem_read), 
	.arb_mem_write(dcache_mem_write),
	.arb_mem_wdata(dcache_mem_wdata),
	.arb_mem_address(dcache_mem_address)
);

arbiter dut_arbiter
(
	.clk,
	
	/*i-cache signals*/
	.i_arb_mem_address(icache_mem_address),
	.i_arb_mem_read(icache_mem_read),
	.i_arb_mem_rdata(icache_mem_rdata),
	.i_arb_mem_resp(icache_mem_resp),
	
	/*d-cache signals*/
	.d_arb_mem_address(dcache_mem_address),
	.d_arb_mem_read(dcache_mem_read),
	.d_arb_mem_write(dcache_mem_write),
	.d_arb_mem_wdata(dcache_mem_wdata),
	.d_arb_mem_rdata(dcache_mem_rdata),	
	.d_arb_mem_resp(dcache_mem_resp),
	
	/*l2 cache signals*/
	.l2arb_mem_address(address),
	.l2arb_mem_read(read),
	.l2arb_mem_write(write),
	.l2arb_mem_wdata(wdata),
	.l2arb_mem_rdata(rdata),
	.l2arb_mem_resp(resp)
);




endmodule : mp3_w_l1cache
