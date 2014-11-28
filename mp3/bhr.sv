import lc3b_types::*;

module bhr #(parameter width = 12)
(
	input clk,
	
	input load,
	input reset,
	input in,
	
	output logic [width-1:0] out
);

logic [width-1:0] data;

assign out = data;

initial
begin
    data = 0;
end


always_ff @(posedge clk)
begin
	if(load)
	begin
		data = {data[width-2:0], in};
	end
end	

endmodule : bhr