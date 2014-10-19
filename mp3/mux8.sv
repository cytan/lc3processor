module mux8 #(parameter width	= 16)
(
	input [2:0] sel,
	input [width-1:0] a,b,c,d,h,i,j,k,
	output logic [width-1:0] f
);

always_comb
begin
	case (sel)
		3'b000: f = a;
		3'b001: f = b;
		3'b010: f = c;
		3'b011: f = d;
		3'b100: f = h;
		3'b101: f = i;
		3'b110: f = j;
		3'b111: f = k;
		default:;
	endcase
end

endmodule: mux8