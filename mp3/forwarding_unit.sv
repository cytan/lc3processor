import lc3b_types::*;


module forwarding_unit
(
	input logic [2:0]	ex_sr1,
						ex_sr2,
						ex_dest,
						mem_sr1,
						mem_dest,
						wb_dest,
	input logic [1:0]	mem_regfile_sel,
	input logic			mem_load_regfile,
						wb_load_regfile,
						ex_mem_write,
	output logic [1:0]	ex_sr1_sel,
						ex_sr2_sel,
	output logic		mem_sr1_sel,
						mem_sr2_sel
);

always_comb
begin : choose_ex_sr1
	ex_sr1_sel = 0;

	if(wb_load_regfile)
	begin
		if(ex_sr1 == wb_dest)
		begin
			ex_sr1_sel = 2'b10;
		end
	end
	
	if(mem_load_regfile)
	begin
		if(ex_sr1 == mem_dest)
		begin
			if(mem_regfile_sel == 2'b10)
				ex_sr1_sel = 2'b11;
			else
				ex_sr1_sel = 2'b01;
		end
	end
	
end

always_comb
begin : choose_ex_sr2
	ex_sr2_sel = 0;
	
	if(wb_load_regfile)
	begin
		if(ex_mem_write)
		begin
			if(ex_dest == wb_dest)
			begin
				ex_sr2_sel = 2'b10;
			end
		end
		else if(ex_sr2 == wb_dest)
		begin
			ex_sr2_sel = 2'b10;
		end
	end
	
	if(mem_load_regfile)
	begin
		if(ex_sr2 == mem_dest)
		begin
			ex_sr2_sel = 2'b01;
		end
	end
end

always_comb
begin : choose_mem_sr1
	mem_sr1_sel = 1'b0;
	
	if(wb_load_regfile)
	begin
		if(mem_sr1 == wb_dest)
		begin
			mem_sr1_sel = 1'b1;
		end
	end
			
end

always_comb
begin : choose_mem_sr2
	mem_sr2_sel = 1'b0;
	
	if(wb_load_regfile)
	begin
		if(mem_dest == wb_dest)
		begin
			mem_sr2_sel = 1'b1;
		end
	end
end

endmodule : forwarding_unit