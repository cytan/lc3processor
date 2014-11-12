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
	input logic			mem_jinst,
						ex_d_read,
						ex_d_readi,
						ex_d_writei,
						BEN,
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
	
	if(BEN | mem_jinst)
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

endmodule : hazard_unit