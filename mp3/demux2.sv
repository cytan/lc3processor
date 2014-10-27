module demux2 #(parameter width = 16)
(
	input sel,
	input [width-1:0] f,
	output logic [width-1:0] a, b
);

always_comb
begin
	a = (sel) ? {width{1'b0}}:f;
	b = (sel) ? f:{width{1'b0}};
end

endmodule: demux2