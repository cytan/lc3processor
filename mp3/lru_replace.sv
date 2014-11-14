import lc3b_types::*;

module lru_replace
(
	input lc3b_3bit	lru_out,
	output logic 		r0, r1, r2, r3
);

always_comb
begin
	case (lru_out)
		3'b000: begin
			r0 = 1'b1;
			r1 = 1'b0;
			r2 = 1'b0;
			r3 = 1'b0;
		end
		
		3'b001: begin
			r0 = 1'b1;
			r1 = 1'b0;
			r2 = 1'b0;
			r3 = 1'b0;
		end
			
		3'b010: begin
			r0 = 1'b0;
			r1 = 1'b1;
			r2 = 1'b0;
			r3 = 1'b0;
		end
		
		3'b011: begin
			r0 = 1'b0;
			r1 = 1'b1;
			r2 = 1'b0;
			r3 = 1'b0;
		end
		
		3'b100: begin
			r0 = 1'b0;
			r1 = 1'b0;
			r2 = 1'b1;
			r3 = 1'b0;
		end
		
		3'b101: begin
			r0 = 1'b0;
			r1 = 1'b0;
			r2 = 1'b0;
			r3 = 1'b1;
		end
		
		3'b110: begin
			r0 = 1'b0;
			r1 = 1'b0;
			r2 = 1'b1;
			r3 = 1'b0;
		end
		
		3'b111: begin
			r0 = 1'b0;
			r1 = 1'b0;
			r2 = 1'b0;
			r3 = 1'b1;
		end
		
		default: begin
			r0 = 1'b0;
			r1 = 1'b0;
			r2 = 1'b0;
			r3 = 1'b0;
		end
	endcase
end

endmodule : lru_replace