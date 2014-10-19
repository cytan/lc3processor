import lc3b_types::*;

module mp3
(
    input clk,

    /* Memory signals */
    input	mem_resp,
    input	lc3b_word inst_mem_rdata,
	 input	lc3b_word data_mem_rdata,
    output logic	inst_mem_read,
	 output logic	data_mem_read,
    output logic	inst_mem_write,
	 output logic 	data_mem_write,
    output lc3b_mem_wmask	inst_mem_byte_enable,
	 output lc3b_mem_wmask	data_mem_byte_enable,
    output lc3b_word inst_mem_addr,
	 output lc3b_word	data_mem_addr,
    output lc3b_word inst_mem_wdata,
	 output lc3b_word	data_mem_wdata
);



/* Instantiate MP3 top level blocks here 
	Currently implementing processor w/o cache */

cpu CPU
(
	.clk,
	.mem_resp,
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


endmodule : mp3
