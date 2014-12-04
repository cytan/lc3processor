import lc3b_types::*;

module l2_array_b #(parameter width = 128)
(
    input clk,
    input write,
    input logic [3:0] index,
    input logic [width-1:0] datain,
    output logic [width-1:0] dataout
);

logic [width-1:0] data [15:0];

/* Initialize array */
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
        data[index] = datain;
    end
end

assign dataout = data[index];

endmodule : l2_array_b