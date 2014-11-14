import lc3b_types::*;

module encoder4to2
(
	input a,
	input b,
	input c,
	input d,
	output lc3b_2bit f
);

always_comb
begin
	case ({a,b,c,d})
		4'b1000: f = 2'b00;
		4'b0100: f = 2'b01;
		4'b0010: f = 2'b10;
		4'b0001: f = 2'b11;
		default: f = 2'b00;
	endcase
end

endmodule : encoder4to2