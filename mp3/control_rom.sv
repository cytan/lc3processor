import lc3b_types::*;

module control_rom
(
	/* input format: opcode, ir[11], ir[5], ir[4] */
	input [6:0]	in,
	output lc3b_control_word	out
);

always_comb
begin
	/* Default assignments */
	out.id_storemux_sel = 1'b0;
	out.ex_alumux_sel = 3'b000;
	out.ex_aluop = alu_add;
	out.data_mem_read = 1'b0;
	out.data_mem_write = 1'b0;
	out.data_mem_readi = 1'b0;
	out.data_mem_writei= 1'b0;
	out.mem_jinst	= 1'b0;
	out.mem_rdatamux_sel = 1'b0;
	out.wb_regfile_sel = 2'b00;
	out.wb_load_cc = 1'b0;
	out.wb_destmux_sel = 1'b0;
	out.wb_load_regfile = 1'b0;
	
	casex (in)
		{op_add,1'bx,1'b0,1'bx}: begin			// add
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
			out.wb_regfile_sel = 2'b01;
		end
		
		{op_add,1'bx,1'b1,1'bx}: begin			// addimm
			out.ex_alumux_sel = 3'b010;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
			out.wb_regfile_sel = 2'b01;
		end
		
		{op_and,1'bx,1'b0,1'bx}: begin			// and
			out.ex_aluop = alu_and;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
			out.wb_regfile_sel = 2'b01;
		end
		
		{op_and,1'bx,1'b1,1'bx}: begin			// andimm
			out.ex_alumux_sel = 3'b010;
			out.ex_aluop = alu_and;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
			out.wb_regfile_sel = 2'b01;
		end
		
		{op_br,3'bxxx}:;							// br
		
		{op_not,3'bxxx}: begin					// not
			out.ex_aluop = alu_not;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
			out.wb_regfile_sel = 2'b01;
		end
		
		{op_ldr,3'bxxx}: begin					// ldr
			out.ex_alumux_sel = 3'b001;
			out.data_mem_read = 1'b1;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_str,3'bxxx}: begin					// str
			out.id_storemux_sel = 1'b1;
			out.ex_alumux_sel = 3'b001;
			out.data_mem_write = 1'b1;
		end
		
		{op_jmp,3'bxxx}: begin					// jump & ret
			out.mem_jinst = 1'b1;
		end
		
		{op_jsr,3'bxxx}: begin				// jsr & jsrr
			out.mem_jinst = 1'b1;
			out.wb_regfile_sel = 2'b11;
			out.wb_destmux_sel = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_trap,3'bxxx}: begin				// trap
			out.data_mem_read = 1'b1;
			out.mem_jinst = 1'b1;
			out.wb_regfile_sel = 2'b11;
			out.wb_destmux_sel = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_ldb,3'bxxx}: begin				// ldb
			out.ex_alumux_sel = 3'b011;
			out.data_mem_read = 1'b1;
			out.mem_rdatamux_sel = 1'b1;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_stb,3'bxxx}: begin				// stb
			out.id_storemux_sel = 1'b1;
			out.ex_alumux_sel = 3'b011;
			out.data_mem_write = 1'b1;
		end
		
		{op_ldi,3'bxxx}: begin				// ldi
			out.ex_alumux_sel = 3'b001;
			out.data_mem_read = 1'b1;
			out.data_mem_readi = 1'b1;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_sti,3'bxxx}: begin				// sti
			out.id_storemux_sel = 1'b1;
			out.ex_alumux_sel = 3'b001;
			out.data_mem_read = 1'b1;
			out.data_mem_writei = 1'b1;
		end
		
		{op_lea,3'bxxx}: begin				// lea
			out.wb_regfile_sel = 2'b10;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_shf,1'bx,1'bx,1'b0}: begin	// lshf
			out.ex_alumux_sel = 3'b100;
			out.ex_aluop = alu_sll;
			out.wb_regfile_sel = 2'b01;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end
		
		{op_shf,1'bx,1'b0,1'b1}: begin	// rshfl
			out.ex_alumux_sel = 3'b100;
			out.ex_aluop = alu_srl;
			out.wb_regfile_sel = 2'b01;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end

		{op_shf,1'bx,1'b1,1'b1}: begin	// rshfa
			out.ex_alumux_sel = 3'b100;
			out.ex_aluop = alu_sra;
			out.wb_regfile_sel = 2'b01;
			out.wb_load_cc = 1'b1;
			out.wb_load_regfile = 1'b1;
		end

		
		default: begin
			out = 0;
		end
	endcase
end

endmodule: control_rom












