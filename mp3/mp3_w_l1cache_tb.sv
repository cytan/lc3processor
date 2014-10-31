module mp3_w_l1cache_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic read, write, resp;
logic [15:0] address;
logic [127:0] wdata, rdata;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

mp3_w_l1cache dut
(
    .clk,
    .read, .write,
	.address,
	.wdata,
	
	.resp,
	.rdata
);



physical_memory memory
(
    .clk,
    
	.read(read),
    .write(write),
    .address(address),
    .wdata(wdata),
    .resp(resp),
    .rdata(rdata)
);

endmodule : mp3_w_l1cache_tb
