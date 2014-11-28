import lc3b_types::*;

module hazard_unit
(
	output logic		load_fd,
						reset_fd,
						load_dx,
						reset_dx,
						load_xm,
						reset_xm,
						load_mw,
						reset_mw,
	output logic [2:0]	pcmux_sel,
	input logic			mem_jinst,
						ex_d_read,
						ex_d_readi,
						ex_d_writei,
						BEN,
						btb_hit,
						btb_uc,
						pht_out,
						xm_btb_hit,
						xm_pht_taken,
	input logic [2:0]	ex_dest,
						id_sr1,
						id_sr2
						
						
);

logic d_read;
assign d_read = ~ex_d_writei & (ex_d_read | ex_d_readi); 


always_comb
begin
	load_fd = 1;
	reset_fd = 0;
	load_dx = 1;
	reset_dx = 0;
	load_xm = 1;
	reset_xm = 0;
	load_mw = 1;
	reset_mw = 0;
	
	if(id_sr1 == ex_dest && d_read)
	begin
		load_dx		= 0;
		load_fd		= 0;
		reset_dx	= 1;
	end
	
	if(id_sr2 == ex_dest && d_read) //corner case: will stall if load or store
									//offset bits are the same as mem_dest
	begin
		load_dx 	= 0;
		load_fd 	= 0;
		reset_dx 	= 1;
	end
	
	// check if mem_jinst, if branch was not taken when jinst was fetched
	// flush pipeline
	// else, check if branch was mispredicted
	if (mem_jinst)
	begin
		if (~xm_pht_taken)
		begin
			//load_fd		= 0; 	//commented out this part because need to load pc
									//load_pc is tied to load_fd
			load_fd 	= 1;		//NEED TO ENSURE PC IS LOADED in case the instructions to be flushed
									//cause hazards and prevent the pc from loading
			reset_fd 	= 1;		//reset takes precedence over load in the register
			load_dx		= 0;
			reset_dx 	= 1;
			load_xm		= 0;
			reset_xm 	= 1;
		end
	end
	else if (BEN ^ xm_pht_taken)
	begin
		//load_fd		= 0; 	//commented out this part because need to load pc
								//load_pc is tied to load_fd
		load_fd 	= 1;		//NEED TO ENSURE PC IS LOADED in case the instructions to be flushed
								//cause hazards and prevent the pc from loading
		reset_fd 	= 1;		//reset takes precedence over load in the register
		load_dx		= 0;
		reset_dx 	= 1;
		load_xm		= 0;
		reset_xm 	= 1;
	end	
end

always_comb
begin : pcmux_sel_gen
	pcmux_sel = 3'd0;
	
	// if jinst in mem stage and not supported/not seen before, load from trapmux
	// if supported and seen before, load from pc+2
	// else if unconditional branch in fetch stage and branch not taken in mem stage,
	// load from btb,
	// else, determine various scenarios
	//if(mem_jinst & ~xm_btb_hit)
	if(mem_jinst)
	begin
		if(~xm_btb_hit)
			pcmux_sel = 3'b001;
		else
			pcmux_sel = 3'b000;
	end
	else if(btb_uc & ~(xm_btb_hit & (xm_pht_taken ^ BEN)))
		pcmux_sel = 3'b100;
	else
	begin
		case({btb_hit & pht_out, xm_btb_hit, xm_pht_taken, BEN})
			4'b0000:
				pcmux_sel = 3'b000;
			4'b0001:
				pcmux_sel = 3'b010;
			//4'b0010:
				//pcmux_sel = 3'b000;
			//4'b0011:
				//pcmux_sel = 3'b010;
			4'b0100:
				pcmux_sel = 3'b000;
			4'b0101:
				pcmux_sel = 3'b010;
			4'b0110:
				pcmux_sel = 3'b011;
			4'b0111:
				pcmux_sel = 3'b000;
			4'b1000:
				pcmux_sel = 3'b100;
			4'b1001:
				pcmux_sel = 3'b010;
			//4'b1010:
			//	pcmux_sel = 3'b011;
			//4'b1011:
			//	pcmux_sel = 3'b100;
			4'b1100:
				pcmux_sel = 3'b100;
			4'b1101:
				pcmux_sel = 3'b010;
			4'b1110:
				pcmux_sel = 3'b011;
			4'b1111:
				pcmux_sel = 3'b100;
			default:
				pcmux_sel = 3'b111;
		endcase
	end			
end

endmodule : hazard_unit