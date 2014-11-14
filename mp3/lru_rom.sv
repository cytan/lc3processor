import lc3b_types::*;

module lru_rom
(
	input h0, h1, h2, h3,
	input lc3b_3bit	lru,
	output lc3b_3bit	next_lru
);

always_comb
begin
	case(lru)
		3'b000: begin
			case({h0,h1,h2,h3})
				4'b1000:	next_lru = 3'b110;
				4'b0100: next_lru = 3'b100;
				4'b0010: next_lru = 3'b001;
				4'b0001: next_lru = 3'b000;
				default: next_lru = 3'b000;
			endcase
		end
		
		3'b001: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b111;
				4'b0100: next_lru = 3'b101;
				4'b0010: next_lru = 3'b001;
				4'b0001: next_lru = 3'b000;
				default: next_lru = 3'b001;
			endcase
		end
		
		3'b010: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b110;
				4'b0100: next_lru = 3'b100;
				4'b0010: next_lru = 3'b011;
				4'b0001: next_lru = 3'b010;
				default: next_lru = 3'b010;
			endcase
		end
				
		3'b011: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b111;
				4'b0100: next_lru = 3'b101;
				4'b0010: next_lru = 3'b011;
				4'b0001: next_lru = 3'b010;
				default: next_lru = 3'b011;
			endcase
		end
		
		3'b100: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b110;
				4'b0100: next_lru = 3'b100;
				4'b0010: next_lru = 3'b001;
				4'b0001: next_lru = 3'b000;
				default: next_lru = 3'b100;
			endcase
		end
		
		3'b101: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b111;
				4'b0100: next_lru = 3'b101;
				4'b0010: next_lru = 3'b001;
				4'b0001: next_lru = 3'b000;
				default: next_lru = 3'b101;
			endcase
		end
		
		3'b110: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b110;
				4'b0100: next_lru = 3'b100;
				4'b0010: next_lru = 3'b011;
				4'b0001: next_lru = 3'b010;
				default: next_lru = 3'b110;
			endcase
		end
		
		3'b111: begin
			case({h0,h1,h2,h3})
				4'b1000: next_lru = 3'b111;
				4'b0100: next_lru = 3'b101;
				4'b0010: next_lru = 3'b011;
				4'b0001: next_lru = 3'b010;
				default: next_lru = 3'b111;
			endcase
		end
		
		default: next_lru = 3'b000;

	endcase
end

endmodule : lru_rom