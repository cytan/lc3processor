module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic mem_resp;
logic inst_mem_read;
logic data_mem_read;
logic inst_mem_write;
logic data_mem_write;
logic [1:0] inst_mem_byte_enable;
logic [1:0]	data_mem_byte_enable;
logic [15:0] inst_mem_addr;
logic [15:0] data_mem_addr;
logic [15:0] inst_mem_rdata;
logic [15:0] data_mem_rdata;
logic [15:0] inst_mem_wdata;
logic [15:0] data_mem_wdata;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

mp3 dut
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

memory memory
(
    .clk,
    .i_read(inst_mem_read),
	 .d_read(data_mem_read),
    .i_write(inst_mem_write),
	 .d_write(data_mem_write),
    .i_byte_enable(inst_mem_byte_enable),
	 .d_byte_enable(data_mem_byte_enable),
    .i_address(inst_mem_addr),
	 .d_address(data_mem_addr),
    .i_wdata(inst_mem_wdata),
	 .d_wdata(data_mem_wdata),
    .resp(mem_resp),
    .i_rdata(inst_mem_rdata),
	 .d_rdata(data_mem_rdata)
);

endmodule : mp3_tb
