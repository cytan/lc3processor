import lc3b_types::*;

module cache_control
(
	input clk,
	
	input mem_read,
			mem_write,
			hit,
			comp0_out,
			comp1_out,
			lru_out,
			dba0_out,
			dba1_out,
			vba0_out,
			vba1_out,
			pmem_resp,
			
	output logic va0_w, va1_w, 		// valid bit array load signals
					 ta0_w, ta1_w, 		// tag array load signals
					 da0_w, da1_w,			// data array load signals
					 dba0_w, dba1_w,		// dirty bit array load signals
					 la_w,					// LRU bit array load signal
					 lru_in,
					 dba_in,		
					 datamux_sel,		
					 dawmux_sel,
					 pmem_read,
					 pmem_write,
					 mem_resp,
					 
	 output lc3b_mux4sel addrmux_sel
);

enum int unsigned {
//	idle,
	tag_comp,
	write_back,
	allocate1,
	allocate2
} curr_state, next_state;

always_comb
begin: state_actions
/* Default output assignments */
	va0_w = 1'b0;
	va1_w = 1'b0; 	
	ta0_w = 1'b0;
	ta1_w = 1'b0;
	da0_w = 1'b0;
	da1_w = 1'b0;	
	dba0_w = 1'b0;
	dba1_w = 1'b0;
	la_w = 1'b0;
	lru_in = 1'b0;
	dba_in = 1'b0;
	datamux_sel = 1'b0;	
	dawmux_sel = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	mem_resp = 1'b0;
	addrmux_sel = 2'b00;
	
	case(curr_state)
		tag_comp: begin
		
			if (hit) begin
				if (mem_read) begin
					if (comp0_out && vba0_out)				
						datamux_sel = 1'b0;		
					else if (comp1_out && vba1_out)		
						datamux_sel = 1'b1;
				end
				
				else if (mem_write) begin
					dawmux_sel = 0;
					if (comp0_out && vba0_out)				
						datamux_sel = 1'b0;		
					else if (comp1_out && vba1_out)		
						datamux_sel = 1'b1;
					dba_in = 1;
					if (comp0_out) begin
						da0_w = 1;
						dba0_w = 1;
					end
					else if (comp1_out) begin
						da1_w = 1;
						dba1_w = 1;
					end
				end
					
				if (comp0_out && vba0_out)
					lru_in = 1'b1;
				else if (comp1_out && vba1_out)
					lru_in = 1'b0;
				la_w = 1;
				mem_resp = 1;
			end
		end
		
		write_back: begin 			// select cache line to write back based on least recently used line
			datamux_sel = lru_out;
			if (lru_out)
				addrmux_sel = 2'b10;
			else
				addrmux_sel = 2'b01;
			pmem_write = 1;
		end
		
		allocate1: begin
			pmem_read = 1;				// write cache line from pmem into way based on LRU bit
			dawmux_sel = 1;			// update tag array, valid bit an clear dirty bit
			dba_in = 0;
				if (lru_out) begin
					da1_w = 1;
					ta1_w = 1;
					va1_w = 1;
					dba1_w = 1;
				end
				else begin
					da0_w = 1;
					ta0_w = 1;
					va0_w = 1;
					dba0_w = 1;
				end
			end
		allocate2: begin				
			lru_in = ~lru_out;	// update LRU bit
			la_w = 1;
		end	
		
		default:;
			
	endcase
end

always_comb
begin : next_state_logic
/* Next state information and conditions (if any)
* for transitioning between states */
	next_state = curr_state;
	case(curr_state)
//		idle: begin
//			if (mem_read | mem_write)
//				next_state = tag_comp;
//		end
		
		tag_comp: begin
			if (mem_read || mem_write) begin
				if (~hit) begin
					if ((~lru_out && dba0_out && vba0_out) | (lru_out && dba1_out && vba1_out))
						next_state = write_back;
					else
						next_state = allocate1;
				end
			end
		end
		
		write_back: if (pmem_resp) next_state = allocate1;
		
		allocate1: if (pmem_resp) next_state = allocate2;
		
		allocate2: next_state = tag_comp;
		
		default:;
					
	endcase
end
	
	
always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 curr_state <= next_state;
end

endmodule: cache_control
			