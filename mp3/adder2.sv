module adder2 #(parameter width = 16)
(
	input [width-1:0] a,b,
	output logic [width-1:0] f
);

/* simply add inputs*/
assign f = a + b;

endmodule : adder2