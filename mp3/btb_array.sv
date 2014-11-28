module btb_array #(parameter width = 16)
(
	input clk,
	
	input logic write,
    input logic [3:0] read_index,
	input logic [3:0] write_index,
    input logic [width-1:0] datain,
    output logic [width-1:0] dataout
);

logic [width-1:0] data [15:0];

initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        data[write_index] = datain;
    end
end

assign dataout = data[read_index];

endmodule : btb_array