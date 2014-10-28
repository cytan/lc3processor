/*
 * Magic memory that handles 2 memory accesses at the same time
 */
/*
module memory
(
    input clk,
    input read,
    input write,
    input [1:0] byte_enable,
    input [15:0] address,
    input [15:0] wdata,
    output logic resp,
    output logic [15:0] rdata
);
*/

module memory
(
	// common signal
	input clk,
	output logic 	i_resp,
	output logic	d_resp,
	// instruction memory
	input i_read,
	input i_write,
	input [1:0] 	i_byte_enable,
	input [15:0]	i_address,
	input [15:0] 	i_wdata,
	output logic [15:0]	i_rdata,
	// data memory
	input d_read,
	input d_write,
	input [1:0]		d_byte_enable,
	input [15:0]	d_address,
	input [15:0]	d_wdata,
	output logic [15:0]	d_rdata
);
	

timeunit 1ns;
timeprecision 1ns;

logic [7:0]	 mem [0:2**$bits(i_address)-1];
logic [15:0] i_even_address;
logic [15:0] d_even_address;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

/* Calculate even address */
assign i_even_address = {i_address[15:1], 1'b0};
assign d_even_address = {d_address[15:1], 1'b0};

always_ff @(posedge clk)
begin
	if (i_write) begin
		if (i_byte_enable[1])
		begin
			mem[i_even_address+1] = i_wdata[15:8];
		end
		if (i_byte_enable[0])
		begin
			mem[i_even_address] = i_wdata[7:0];
		end
	end
	if (d_write) begin
		if (d_byte_enable[1])
		begin
			mem[d_even_address+1] = d_wdata[15:8];
		end
		if (d_byte_enable[0])
		begin
			mem[d_even_address] = d_wdata[7:0];
		end
	end
end

/* Magic memory responds immediately */
assign i_rdata = {mem[i_even_address+1], mem[i_even_address]};
assign d_rdata = {mem[d_even_address+1], mem[d_even_address]};
assign i_resp = i_read | i_write;
assign d_resp = d_read | d_write;

endmodule : memory
