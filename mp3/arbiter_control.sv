import lc3b_types::*;

module arbiter_control
(
	input clk,
	
	input i_arb_mem_read,
			d_arb_mem_read,
			d_arb_mem_write,
			l2arb_mem_resp,
	
	/*control signals for arbiter*/
	output logic addrmux_sel,
					 readmux_sel,
					 writemux_sel,
					 wdatamux_sel,
					 rdatademux_sel,
					 respdemux_sel
);

enum int unsigned {
	idle,
	i_fetch,
	d_fetch
} curr_state, next_state;

always_comb
begin: state_actions
/* Default output assignments */
	addrmux_sel = 1'b0;
	readmux_sel = 1'b0;
	writemux_sel = 1'b0;
	wdatamux_sel = 1'b0;
	rdatademux_sel = 1'b0;
	respdemux_sel = 1'b0;
	
	case(curr_state)
		idle: begin
			if (i_arb_mem_read) begin
				addrmux_sel = 1'b0;
				readmux_sel = 1'b0;
				writemux_sel = 1'b0;
				wdatamux_sel = 1'b0;
				rdatademux_sel = 1'b0;
				respdemux_sel = 1'b0;
			end
			
			else if (d_arb_mem_read || d_arb_mem_write) begin
				addrmux_sel = 1'b1;
				readmux_sel = 1'b1;
				writemux_sel = 1'b1;
				wdatamux_sel = 1'b1;
				rdatademux_sel = 1'b1;
				respdemux_sel = 1'b1;
			end
		end
		
		i_fetch:;
		
		d_fetch: begin
			addrmux_sel = 1'b1;
			readmux_sel = 1'b1;
			writemux_sel = 1'b1;
			wdatamux_sel = 1'b1;
			rdatademux_sel = 1'b1;
			respdemux_sel = 1'b1;
		end
		
		default:;	
	endcase
end

always_comb
begin: next_state_logic
	next_state = curr_state;
	unique case(curr_state)
		idle: begin
			if (i_arb_mem_read)
				next_state = i_fetch;
			else if (d_arb_mem_read || d_arb_mem_write)
				next_state = d_fetch;
		end
		
		i_fetch: begin
			if (l2arb_mem_resp)
				next_state = idle;
		end
		
		d_fetch: begin
			if (l2arb_mem_resp)
				next_state = idle;
		end
		
		default:;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	curr_state <= next_state;
end

endmodule: arbiter_control