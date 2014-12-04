import lc3b_types::*;

module l2_cache_control
(
	input clk,
	
	/* external signals */
	input l2arb_mem_read,
	input l2arb_mem_write,
	output logic l2arb_mem_resp,
	output logic pmem_read,
	output logic pmem_write,
	input pmem_resp,
	input pref,
	
	/* cache internal signals */

	input dirty,
	input hit,
	input h0, h1, h2, h3,
	input r0, r1, r2, r3,
	input lc3b_2bit	hit_num,
	input lc3b_2bit	replace,
	
	output logic wr_va0, wr_va1, wr_va2, wr_va3,
	output logic wr_ta0, wr_ta1, wr_ta2, wr_ta3,
	output logic wr_da0, wr_da1, wr_da2, wr_da3,
	output logic wr_dba0, wr_dba1, wr_dba2, wr_dba3,
	output logic wr_lru,
	output logic wr_prefreg,
	
	output logic prefmux_sel,
	output logic din_sel,
	output logic addrmux_sel,
	output logic dba_in,
	output lc3b_2bit	dout_sel
);

enum int unsigned {
	idle,
	compare_tag,
	write_back,
	allocate,
	pref_int,
	pref_switch,
	pref_pause,
	pref_wb,
	pref_alloc,
	pref_done,
	pref_rest
} curr_state, next_state;

always_comb
begin : state_actions
	/* default output assignments */
	l2arb_mem_resp = 1'b0;
	pmem_read	= 1'b0;
	pmem_write	= 1'b0;
	prefmux_sel = 1'b0;
	din_sel 		= 1'b0;
	addrmux_sel = 1'b0;
	dba_in		= 1'b0;
	dout_sel		= hit_num;
	wr_va0		= 1'b0;
	wr_va1		= 1'b0;
	wr_va2		= 1'b0;	
	wr_va3		= 1'b0;
	wr_ta0		= 1'b0;
	wr_ta1		= 1'b0;
	wr_ta2		= 1'b0;	
	wr_ta3		= 1'b0;
	wr_da0		= 1'b0;
	wr_da1		= 1'b0;
	wr_da2		= 1'b0;	
	wr_da3		= 1'b0;
	wr_dba0		= 1'b0;
	wr_dba1		= 1'b0;
	wr_dba2		= 1'b0;	
	wr_dba3		= 1'b0;
	wr_lru		= 1'b0;
	wr_prefreg	= 1'b0;
	
	case (curr_state)
		idle: begin
			prefmux_sel = 1'b0;
		end
		
		compare_tag: begin
			if (l2arb_mem_read && hit) begin
				dout_sel	= hit_num;
				wr_lru	= 1'b1;
				l2arb_mem_resp	= 1'b1;
			end
			else if (l2arb_mem_write && hit) begin
				din_sel	= 1'b1;
				wr_lru	= 1'b1;
				dba_in	= 1'b1;
				wr_dba0	= h0;
				wr_dba1	= h1;
				wr_dba2	= h2;
				wr_dba3	= h3;
				wr_da0	= h0;
				wr_da1	= h1;
				wr_da2	= h2;
				wr_da3	= h3;
				l2arb_mem_resp = 1'b1;
			end
			else;
		end

		write_back: begin
			addrmux_sel	= 1'b1;
			dout_sel		= replace;
			pmem_write	= 1'b1;
		end
		
		allocate: begin
			addrmux_sel	= 1'b0;
			pmem_read	= 1'b1;
			din_sel		= 1'b0;
			wr_da0	= r0;
			wr_da1	= r1;
			wr_da2	= r2;
			wr_da3	= r3;
			dba_in	= 1'b0;
			wr_dba0	= r0;
			wr_dba1	= r1;
			wr_dba2	= r2;
			wr_dba3	= r3;
			wr_va0	= r0;
			wr_va1	= r1;
			wr_va2	= r2;
			wr_va3	= r3;
			wr_ta0	= r0;
			wr_ta1	= r1;
			wr_ta2	= r2;
			wr_ta3	= r3;
			wr_prefreg = 1'b1;
		end
		
		pref_int: begin
			if (l2arb_mem_read) begin
				dout_sel	= hit_num;
				wr_lru	= 1'b1;
				l2arb_mem_resp	= 1'b1;
			end
			else if (l2arb_mem_write) begin
				din_sel	= 1'b1;
				wr_lru	= 1'b1;
				dba_in	= 1'b1;
				wr_dba0	= h0;
				wr_dba1	= h1;
				wr_dba2	= h2;
				wr_dba3	= h3;
				wr_da0	= h0;
				wr_da1	= h1;
				wr_da2	= h2;
				wr_da3	= h3;
				l2arb_mem_resp = 1'b1;
			end
			else;
		end
		
		pref_switch: begin
			prefmux_sel = 1'b1;
		end
		
		pref_pause: begin
			prefmux_sel = 1'b1;
		end
		
		pref_wb: begin
			prefmux_sel = 1'b1;
			addrmux_sel	= 1'b1;
			dout_sel		= replace;
			pmem_write	= 1'b1;
		end
		
		pref_alloc: begin
			prefmux_sel = 1'b1;
			addrmux_sel	= 1'b0;
			pmem_read	= 1'b1;
			din_sel		= 1'b0;
			wr_da0	= r0;
			wr_da1	= r1;
			wr_da2	= r2;
			wr_da3	= r3;
			dba_in	= 1'b0;
			wr_dba0	= r0;
			wr_dba1	= r1;
			wr_dba2	= r2;
			wr_dba3	= r3;
			wr_va0	= r0;
			wr_va1	= r1;
			wr_va2	= r2;
			wr_va3	= r3;
			wr_ta0	= r0;
			wr_ta1	= r1;
			wr_ta2	= r2;
			wr_ta3	= r3;
		end

		pref_done: begin
			prefmux_sel = 1'b1;
			wr_lru	= 1'b1;
		end
		
/*		pref_rest: begin
			prefmux_sel = 1'b0;
		end
	*/	
		default:;
		
	endcase
end


always_comb
begin:	next_state_logic

	next_state = curr_state;

	case (curr_state)
		idle: begin
			if (l2arb_mem_read || l2arb_mem_write)
				next_state = compare_tag;
			else
				next_state = idle;
		end
		
		compare_tag: begin
			if (hit)
				next_state = idle;
			else if (dirty)
				next_state = write_back;
			else
				next_state = allocate;
		end
		
		write_back: begin
			if (pmem_resp)
				next_state = allocate;
			else
				next_state = write_back;
		end
		
		allocate: begin
			if (pmem_resp)
			begin
				if (pref)
					next_state = compare_tag;
				else
					next_state = pref_int;	
			end
			else
				next_state = allocate;
		end

		pref_int: begin
			next_state = pref_switch;
		end
		
		pref_switch: begin
			if (hit)
				next_state = idle;
			else
				next_state = pref_pause;
		end
		
		pref_pause: begin
			if (dirty)
				next_state = pref_wb;
			else
				next_state = pref_alloc;
		end
		
		pref_wb: begin
			if (pmem_resp)
				next_state = pref_alloc;
			else
				next_state = pref_wb;
		end
		
		pref_alloc: begin
			if (pmem_resp)
				next_state = pref_done;
			else
				next_state = pref_alloc;
		end
		
		pref_done: begin
			next_state = idle; //pref_rest;
		end
		
/*		pref_rest: begin
			next_state = idle;
		end
*/		
		default: next_state = idle;
	endcase
end


always_ff @(posedge clk)
begin:	next_state_assignment
	curr_state <= next_state;
end


endmodule : l2_cache_control