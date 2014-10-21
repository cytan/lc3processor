import lc3b_types::*;

module cpu
(
	input clk,
   /* Memory signals */
	input	mem_resp,
   input	lc3b_word inst_mem_rdata,
	input	lc3b_word data_mem_rdata,
   output logic	inst_mem_read,
	output logic	data_mem_read,
   output logic	inst_mem_write,
	output logic 	data_mem_write,
   output lc3b_mem_wmask	inst_mem_byte_enable,
	output lc3b_mem_wmask	data_mem_byte_enable,
   output lc3b_word inst_mem_addr,
	output lc3b_word	data_mem_addr,
   output lc3b_word inst_mem_wdata,
	output lc3b_word	data_mem_wdata
);

/* internal signals */
logic				BEN;
logic				load_pc;
logic				load_fd;
logic				load_dx;
logic				load_xm;
logic				load_mw;
logic				opcomp_out;
logic				cccomp_out;
lc3b_nzp			cc_out;
lc3b_nzp			gencc_out;
lc3b_reg			destmux_out;
lc3b_reg			storemux_out;
lc3b_word		pcplus2_out;
lc3b_word		bradder_out;
lc3b_word		pcmux_out;
lc3b_word		fd_pc_out;
lc3b_word		fd_ir_out;
lc3b_word		wb_regfile_in;
lc3b_word		sr1_out;
lc3b_word		sr2_out;
lc3b_word		dx_sr1_out;
lc3b_word		dx_sr2_out;
lc3b_word		dx_pc_out;
lc3b_word		dx_ir_out;
lc3b_word		adj6_out;
lc3b_word		sext5_out;
lc3b_word		sext6_out;
lc3b_word		alumux_out;
lc3b_word		alu_out;
lc3b_word		xm_sr2_out;
lc3b_word		xm_pc_out;
lc3b_word		xm_ir_out;
lc3b_word		adj9_out;
lc3b_word		mw_rdata_out;
lc3b_word		mw_alu_out;
lc3b_word		mw_pc_out;
lc3b_word		mw_ir_out;


lc3b_control_word		rom_out;
lc3b_control_word		dx_ctr_out;
lc3b_control_word		xm_ctr_out;
lc3b_control_word		mw_ctr_out;


/* set signals */
assign load_pc	= 1;
assign load_fd = 1;
assign load_dx	= 1;
assign load_xm = 1;
assign load_mw	= 1;
assign inst_mem_write = 0;
assign inst_mem_read	= load_pc;
assign data_mem_byte_enable = 2'b11;

/* PC unit */
mux2 pcmux
(
	.sel(BEN),
	.a(pcplus2_out),
	.b(bradder_out),
	.f(pcmux_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.in(pcmux_out),
	.out(inst_mem_addr)
);

plus2 pcplus2
(
	.in(inst_mem_addr),
	.out(pcplus2_out)
);

/* IF-ID registers*/
register fd_pc
(
	.clk,
	.load(load_fd),
	.in(pcplus2_out),
	.out(fd_pc_out)
);

register fd_ir
(
	.clk,
	.load(load_fd),
	.in(inst_mem_rdata),
	.out(fd_ir_out)
);

/* decode stage unit */
mux2 #(.width(3)) destmux
(
	.sel(mw_ctr_out.wb_destmux_sel),
	.a(mw_ir_out[11:9]),
	.b(3'b111),
	.f(destmux_out)
);

mux2 #(.width(3))	storemux
(
	.sel(rom_out.id_storemux_sel),
	.a(fd_ir_out[2:0]),			//	sr2
	.b(fd_ir_out[11:9]),			// dest
	.f(storemux_out)
);

regfile regfile
(
	.clk,
	.load(mw_ctr_out.wb_load_regfile),
	.in(wb_regfile_in),
	.src_a(fd_ir_out[8:6]),		// sr1
	.src_b(storemux_out),		// sr2 OR dest
	.dest(destmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);

control_rom	rom
(
	.in({fd_ir_out[15:12], fd_ir_out[11], fd_ir_out[5], fd_ir_out[4]}),
	.out(rom_out)
);

/* ID-EX registers */
register dx_sr1
(
	.clk,
	.load(load_dx),
	.in(sr1_out),
	.out(dx_sr1_out)
);

register dx_sr2
(
	.clk,
	.load(load_dx),
	.in(sr2_out),
	.out(dx_sr2_out)
);

register #(.width(13)) dx_ctr
(
	.clk,
	.load(load_dx),
	.in(rom_out),
	.out(dx_ctr_out)
);

register dx_pc
(
	.clk,
	.load(load_dx),
	.in(fd_pc_out),
	.out(dx_pc_out)
);

register dx_ir
(
	.clk,
	.load(load_dx),
	.in(fd_ir_out),
	.out(dx_ir_out)
);

/* execute stage unit */
adj #(.width(6)) adj6
(
	.in(dx_ir_out[5:0]),
	.out(adj6_out)
);

sext #(.width(5)) sext5
(
	.in(dx_ir_out[4:0]),
	.out(sext5_out)
);

sext #(.width(6)) sext6
(
	.in(dx_ir_out[5:0]),
	.out(sext6_out)
);

mux4 alumux
(
	.sel(dx_ctr_out.ex_alumux_sel),
	.a(dx_sr2_out),
	.b(adj6_out),
	.c(sext5_out),
	.d(sext6_out),
	.f(alumux_out)
);

alu alu
(
	.aluop(dx_ctr_out.ex_aluop),
	.a(dx_sr1_out),
	.b(alumux_out),
	.f(alu_out)
);

/* EX-MEM registers */
register xm_sr2
(
	.clk,
	.load(load_xm),
	.in(dx_sr2_out),
	.out(xm_sr2_out)
);

register xm_alu
(
	.clk,
	.load(load_xm),
	.in(alu_out),
	.out(data_mem_addr)
);

register #(.width(13)) xm_ctr
(
	.clk,
	.load(load_xm),
	.in(dx_ctr_out),
	.out(xm_ctr_out)
);

register xm_pc
(
	.clk,
	.load(load_xm),
	.in(dx_pc_out),
	.out(xm_pc_out)
);

register xm_ir
(
	.clk,
	.load(load_xm),
	.in(dx_ir_out),
	.out(xm_ir_out)
);

/* memory stage unit*/

mux2 wdatamux
(
	.sel(data_mem_addr[0]),
	.a(xm_sr2_out),
	.b({xm_sr2_out[7:0],8'b00000000}),
	.f(data_mem_wdata)
);

comparator #(.width(4)) opcomp
(
	.a(4'b0000),
	.b(xm_ir_out[15:12]),
	.f(opcomp_out)
);

cccomp cccomp
(
	.NZP(xm_ir_out[11:9]),
	.nzp(cc_out),
	.out(cccomp_out)
);

assign BEN = opcomp_out & cccomp_out;
assign data_mem_read		= xm_ctr_out.data_mem_read;
assign data_mem_write	= xm_ctr_out.data_mem_write;

adj #(.width(9)) adj9
(
	.in(xm_ir_out[8:0]),
	.out(adj9_out)
);

adder2 bradder
(
	.a(xm_pc_out),
	.b(adj9_out),
	.f(bradder_out)
);

/* MEM-WB registers */
register mw_rdata
(
	.clk,
	.load(load_mw),
	.in(data_mem_rdata),
	.out(mw_rdata_out)
);

register mw_alu
(
	.clk,
	.load(load_mw),
	.in(data_mem_addr),
	.out(mw_alu_out)
);

register #(.width(13)) mw_ctr
(
	.clk,
	.load(load_mw),
	.in(xm_ctr_out),
	.out(mw_ctr_out)
);

register mw_pc
(
	.clk,
	.load(load_mw),
	.in(xm_pc_out),
	.out(mw_pc_out)
);

register mw_ir
(
	.clk,
	.load(load_mw),
	.in(xm_ir_out),
	.out(mw_ir_out)
);

/* writeback stage unit */
mux2 regfilemux
(
	.sel(mw_ctr_out.wb_regfile_sel),
	.a(mw_alu_out),
	.b(mw_rdata_out),
	.f(wb_regfile_in)
);

gencc gencc
(
	.in(wb_regfile_in),
	.out(gencc_out)
);

registerneg #(.width(3)) cc
(
	.clk,
	.load(mw_ctr_out.wb_load_cc),
	.in(gencc_out),
	.out(cc_out)
);

endmodule: cpu















