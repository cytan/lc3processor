module pht #(parameter width = 15)
(
	input clk,
	
	input load,
	input [width-1:0] index_fetch,
	input [width-1:0] index_mem,
	input BEN,
	
	output logic out
);

logic [1:0] data [(2**width)-1:0];

assign out = data[index_fetch][1];

initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 2'b01;
    end
end

always_ff @(posedge clk)
begin
	if(load)
	begin
		if(BEN)
		begin
			if(data[index_mem] != 2'b11)
			begin
				data[index_mem] = data[index_mem] + 2'b01;
			end
		end
		else
		begin
			if(data[index_mem] != 2'b00)
			begin
				data[index_mem] = data[index_mem] - 2'b01;
			end
		end
	end
end

endmodule : pht
