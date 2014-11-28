import lc3b_types::*;


module cpu
(
	input clk,
   /* Memory signals */
	input	inst_mem_resp,
	input data_mem_resp,
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
logic				load_pipeline;
logic				load_pc;
logic				load_fd;
logic				reset_fd;
logic				load_dx;
logic				reset_dx;
logic				load_xm;
logic				reset_xm;
logic				load_mw;
logic				reset_mw;
logic				hazard_load_fd;
logic				hazard_load_dx;
logic				hazard_load_xm;
logic				hazard_load_mw;
logic				hazard_reset_fd;
logic				hazard_reset_dx;
logic				hazard_reset_xm;
logic				hazard_reset_mw;
logic				direct;
logic				indirect;
logic				stall_out;
logic				stall_outbar;
logic				opcomp_out;
logic				cccomp_out;
logic [1:0]			ex_sr1_sel;
logic [1:0]			ex_sr2_sel;
logic				mem_sr1_sel;
logic				mem_sr2_sel;
logic				btb_uc_out;
logic				btb_hit_out;
logic				pht_out;
logic [2:0]			pcmux_sel;
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
lc3b_word		zext4_out;
lc3b_word		alumux_out;
lc3b_word		alu_out;
lc3b_word		xm_sr1_out;
lc3b_word		xm_sr2_out;
lc3b_word		xm_pc_out;
lc3b_word		xm_ir_out;
lc3b_word		xm_alu_out;
lc3b_word		xm_lea_out;
lc3b_word		hlbyte_out;
lc3b_word		rdatamux_out;
lc3b_word		zdj8_out;
lc3b_word		adj9_out;
lc3b_word		adj11_out;
lc3b_word		jsradder_out;
lc3b_word		jsrmux_out;
lc3b_word		trapmux_out;
lc3b_word		mw_rdata_out;
lc3b_word		mw_alu_out;
lc3b_word		mw_lea_out;
lc3b_word		mw_pc_out;
lc3b_word		mw_ir_out;
lc3b_word		iaddr_out;
lc3b_word		ex_sr1_mux_out;
lc3b_word		ex_sr2_mux_out;
lc3b_word		mem_sr1_mux_out;
lc3b_word		mem_sr2_mux_out;
lc3b_word		btb_target_out;

logic [3:0] bhr_out;



lc3b_control_word		rom_out;
lc3b_control_word		dx_ctr_out;
lc3b_control_word		xm_ctr_out;
lc3b_control_word		mw_ctr_out;

lc3b_brp_bits			fd_brp_in;
lc3b_brp_bits			fd_brp_out;
lc3b_brp_bits			dx_brp_out;
lc3b_brp_bits			xm_brp_out;

/* * * * * * * * * * * * * * * */
/* Control flow and stall unit */
/*   handles p-mem interface   */
/* * * * * * * * * * * * * * * */
assign load_pc	= load_fd; 
assign load_fd 	= load_pipeline & hazard_load_fd;
assign load_dx	= load_pipeline & hazard_load_dx;
assign load_xm 	= load_pipeline & hazard_load_xm;
assign load_mw	= load_pipeline & hazard_load_mw;

assign reset_fd = load_pipeline & hazard_reset_fd;
assign reset_dx = load_pipeline & hazard_reset_dx;
assign reset_xm = load_pipeline & hazard_reset_xm;
assign reset_mw = load_pipeline & hazard_reset_mw;

assign inst_mem_byte_enable = 2'b00;
assign inst_mem_write = 0;
assign inst_mem_wdata = 16'b0;
assign inst_mem_read	= 1;
assign stall_outbar = ~stall_out;

assign direct		= ((xm_ir_out[15]^1'b1) & (xm_ir_out[13]^1'b0)) | (&xm_ir_out[15:12]);	// non-indirect load/stores have opcode 0x1x
assign indirect 	= &(xm_ir_out[15:13] ^ 3'b010);		// 3'b101 signifies indirect instructions
assign load_pipeline	= inst_mem_resp & (~(indirect&(~(stall_out & data_mem_resp)))) & (~(direct&(~data_mem_resp)));

assign fd_brp_in.btb_hit = btb_hit_out;
assign fd_brp_in.pht_taken = btb_uc_out | (pht_out & btb_hit_out) ;

register #(.width(1))	stallreg		///////////////////////////////
(
	.clk,
	.load(data_mem_resp & indirect),
	.reset(1'b0),
	.in(stall_outbar),
	.out(stall_out)
);

mux2 #(.width(1))		dreadmux
(
	.sel(stall_out),
	.a(xm_ctr_out.data_mem_read),
	.b(xm_ctr_out.data_mem_readi),
	.f(data_mem_read)
);

mux2 #(.width(1))		dwritemux
(
	.sel(stall_out),
	.a(xm_ctr_out.data_mem_write),
	.b(xm_ctr_out.data_mem_writei),
	.f(data_mem_write)
);

register #(.width(16))	iaddr	///////////////////////////
(
	.clk,
	.load(stall_outbar),
	.reset(1'b0),
	.in(data_mem_rdata),
	.out(iaddr_out)
);

mux4 #(.width(16))	daddrmux
(
	.sel({&(xm_ir_out[15:12]), stall_out}),
	.a(xm_alu_out),
	.b(iaddr_out),
	.c(zdj8_out),
	.d(zdj8_out),
	.f(data_mem_addr)
);


mux4 #(.width(2)) mbemux
(
	.sel({(xm_ir_out[15]^xm_ir_out[14]), xm_alu_out[0]}),
	.a(2'b01),
	.b(2'b10),
	.c(2'b11),
	.d(2'b11),
	.f(data_mem_byte_enable)
);

/* * * * * */
/* PC unit */
/* * * * * */
mux8 pcmux
(
	//.sel({BEN,xm_ctr_out.mem_jinst}),
	.sel(pcmux_sel),
	.a(pcplus2_out),
	.b(trapmux_out),
	.c(xm_lea_out),
	.d(xm_pc_out),
	.h(btb_target_out),
	.i(16'd0),
	.j(16'd0),
	.k(16'd0),
	.f(pcmux_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.reset(1'b0),
	.in(pcmux_out),
	.out(inst_mem_addr)
);

plus2 pcplus2
(
	.in(inst_mem_addr),
	.out(pcplus2_out)
);

btb_datapath btb
(
	.clk,
	
	.write(	~xm_brp_out.btb_hit					&
			load_pipeline						&		//prevent writing into btb multiple times on a pipe stall
			((opcomp_out & (|xm_ir_out[11:9]))	|		//prevent false positives form nops
			(xm_ir_out[11] & xm_ctr_out.mem_jinst))		// write in mem stage only if no hit in fetch stage
			),
	
	//uc = unconditional
	.uc(	(opcomp_out & (|xm_ir_out[11:9]))	&
			(&xm_ir_out[11:9])					|
			(xm_ir_out[11] & xm_ctr_out.mem_jinst)
		),
	
	.index_fetch(pcplus2_out[3:0]), 
	.index_mem(xm_pc_out[3:0]),
	.tag_fetch(pcplus2_out[15:4]), 
	.tag_mem(xm_pc_out[15:4]),
	.target(xm_lea_out),
	
	.out(btb_target_out),
	.uc_out(btb_uc_out), 
	.hit(btb_hit_out)
);

bhr #(.width(4)) bhr
(
	.clk,
	
	.load(opcomp_out & (|xm_ir_out[11:9])),
	.reset(1'b0),
	.in(BEN),
	
	.out(bhr_out)
);

pht #(.width(7)) pht
(
	.clk,
	.load(opcomp_out & (|xm_ir_out[11:9])),
	.index_fetch({bhr_out, pcplus2_out[2:0]}),
	.index_mem({bhr_out, xm_pc_out[2:0]}),
	.BEN,
	.out(pht_out)
);
	
	
/* * * * * * * * * */
/* IF-ID registers */
/* * * * * * * * * */
register fd_pc
(
	.clk,
	.load(load_fd),
	.reset(reset_fd),
	.in(pcplus2_out),
	.out(fd_pc_out)
);

register fd_ir
(
	.clk,
	.load(load_fd),
	.reset(reset_fd),
	.in(inst_mem_rdata),
	.out(fd_ir_out)
);

register #(.width($bits(lc3b_brp_bits))) fd_brp
(
	.clk,
	.load(load_fd),
	.reset(reset_fd),
	.in(fd_brp_in),
	.out(fd_brp_out)
);

/* * * * * * * * * * */
/* decode stage unit */
/* * * * * * * * * * */
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

/* * * * * * * * * */
/* ID-EX registers */
/* * * * * * * * * */
register dx_sr1
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(sr1_out),
	.out(dx_sr1_out)
);

register dx_sr2
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(sr2_out),
	.out(dx_sr2_out)
);

register #(.width($bits(lc3b_control_word))) dx_ctr
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(rom_out),
	.out(dx_ctr_out)
);

register dx_pc
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(fd_pc_out),
	.out(dx_pc_out)
);

register dx_ir
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(fd_ir_out),
	.out(dx_ir_out)
);

register #(.width($bits(lc3b_brp_bits))) dx_brp
(
	.clk,
	.load(load_dx),
	.reset(reset_dx),
	.in(fd_brp_out),
	.out(dx_brp_out)
);
/* * * * * * * * * * * */
/* execute stage unit  */
/* * * * * * * * * * * */
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

zext zext4
(
	.in(dx_ir_out[3:0]),
	.out(zext4_out)
);

mux8 alumux
(
	.sel(dx_ctr_out.ex_alumux_sel),
	.a(ex_sr2_mux_out),
	.b(adj6_out),
	.c(sext5_out),
	.d(sext6_out),
	.h(zext4_out),
	.i(zext4_out),
	.j(zext4_out),
	.k(zext4_out),
	.f(alumux_out)
);

mux4 ex_sr1_mux
(
	.sel(ex_sr1_sel),
	.a(dx_sr1_out),
	.b(xm_alu_out),
	.c(wb_regfile_in),
	.d(xm_lea_out),
	.f(ex_sr1_mux_out)
);

mux4 ex_sr2_mux
(
	.sel(ex_sr2_sel),
	.a(dx_sr2_out),
	.b(xm_alu_out),
	.c(wb_regfile_in),
	.d(16'h0000),
	.f(ex_sr2_mux_out)
);
alu alu
(
	.aluop(dx_ctr_out.ex_aluop),
	.a(ex_sr1_mux_out),
	.b(alumux_out),
	.f(alu_out)
);

adj #(.width(9)) adj9
(
	.in(dx_ir_out[8:0]),
	.out(adj9_out)
);

adder2 bradder
(
	.a(dx_pc_out),
	.b(adj9_out),
	.f(bradder_out)
);

/* * * * * * * * * * */
/* EX-MEM registers  */
/* * * * * * * * * * */
register xm_sr1
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(ex_sr1_mux_out),
	.out(xm_sr1_out)
);

register xm_sr2
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(ex_sr2_mux_out),
	.out(xm_sr2_out)
);

register xm_lea
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(bradder_out),
	.out(xm_lea_out)
);

register xm_alu
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(alu_out),
	.out(xm_alu_out)
);

register #(.width($bits(lc3b_control_word))) xm_ctr
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(dx_ctr_out),
	.out(xm_ctr_out)
);

register xm_pc
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(dx_pc_out),
	.out(xm_pc_out)
);

register xm_ir
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(dx_ir_out),
	.out(xm_ir_out)
);

register #(.width($bits(lc3b_brp_bits))) xm_brp
(
	.clk,
	.load(load_xm),
	.reset(reset_xm),
	.in(dx_brp_out),
	.out(xm_brp_out)
);

/* * * * * * * * * * */
/* memory stage unit */
/* * * * * * * * * * */
mux2 wdatamux
(
	.sel(xm_alu_out[0]),
	.a(mem_sr2_mux_out),
	.b({mem_sr2_mux_out[7:0],8'b00000000}),
	.f(data_mem_wdata)
);

mux2 mem_sr2_mux
(
	.sel(mem_sr2_sel),
	.a(xm_sr2_out),
	.b(wb_regfile_in),
	.f(mem_sr2_mux_out)
);

mux2 mem_sr1_mux
(
	.sel(mem_sr1_sel),
	.a(xm_sr1_out),
	.b(wb_regfile_in),
	.f(mem_sr1_mux_out)
);

zdj zdj8
(
	.in(xm_ir_out[7:0]),
	.out(zdj8_out)
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

adj #(.width(11)) adj11
(
	.in(xm_ir_out[10:0]),
	.out(adj11_out)
);

adder2 jsradder
(
	.a(xm_pc_out),
	.b(adj11_out),
	.f(jsradder_out)
);

mux2 jsrmux
(
	.sel(xm_ir_out[11]),
	.a(mem_sr1_mux_out),
	.b(jsradder_out),
	.f(jsrmux_out)
);

mux2 trapmux
(
	.sel(&(xm_ir_out[15:12])),
	.a(jsrmux_out),
	.b(data_mem_rdata),
	.f(trapmux_out)
);

hlbyte hlbyte
(
	.in(data_mem_rdata),
	.hl(xm_alu_out[0]),
	.out(hlbyte_out)
);

mux2 rdatamux
(
	.sel(xm_ctr_out.mem_rdatamux_sel),
	.a(data_mem_rdata),
	.b(hlbyte_out),
	.f(rdatamux_out)
);

/* * * * * * * * * * */
/* MEM-WB registers  */
/* * * * * * * * * * */
register mw_rdata
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(rdatamux_out),
	.out(mw_rdata_out)
);

register mw_alu
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(xm_alu_out),
	.out(mw_alu_out)
);

register mw_lea
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(xm_lea_out),
	.out(mw_lea_out)
);

register #(.width($bits(lc3b_control_word))) mw_ctr
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(xm_ctr_out),
	.out(mw_ctr_out)
);

register mw_pc
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(xm_pc_out),
	.out(mw_pc_out)
);

register mw_ir
(
	.clk,
	.load(load_mw),
	.reset(reset_mw),
	.in(xm_ir_out),
	.out(mw_ir_out)
);

/* * * * * * * * * * * * */
/* writeback stage unit  */
/* * * * * * * * * * * * */
mux4 regfilemux
(
	.sel(mw_ctr_out.wb_regfile_sel),
	.a(mw_rdata_out),
	.b(mw_alu_out),
	.c(mw_lea_out),
	.d(mw_pc_out),
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

/* * * * * * * * * * * * */
/* forwarding & hazards  */
/* * * * * * * * * * * * */
forwarding_unit forwarding_unit
(
	.ex_sr1(dx_ir_out[8:6]),
	.ex_sr2(dx_ir_out[2:0]),
	.ex_dest(dx_ir_out[11:9]),
	.mem_sr1(xm_ir_out[8:6]),
	.mem_dest(xm_ir_out[11:9]),
	.wb_dest(mw_ir_out[11:9]),
	.mem_regfile_sel(xm_ctr_out.wb_regfile_sel),
	.mem_load_regfile(xm_ctr_out.wb_load_regfile),
	.wb_load_regfile(mw_ctr_out.wb_load_regfile),
	.ex_mem_write(dx_ctr_out.data_mem_write | dx_ctr_out.data_mem_writei),
	.ex_sr1_sel,
    .ex_sr2_sel,
    .mem_sr1_sel,
	.mem_sr2_sel
);

hazard_unit hazard_unit
(
	.load_fd(hazard_load_fd),
	.reset_fd(hazard_reset_fd),
	.load_dx(hazard_load_dx),
	.reset_dx(hazard_reset_dx),
	.load_xm(hazard_load_xm),
	.reset_xm(hazard_reset_xm),
	.load_mw(hazard_load_mw),
	.reset_mw(hazard_reset_mw),
	.pcmux_sel,
	.mem_jinst(xm_ctr_out.mem_jinst),
	.ex_d_read(dx_ctr_out.data_mem_read),
	.ex_d_readi(dx_ctr_out.data_mem_readi),
	.ex_d_writei(dx_ctr_out.data_mem_writei),
	.BEN,
	.btb_hit(btb_hit_out),
	.btb_uc(btb_uc_out),
	.pht_out,
	.xm_btb_hit(xm_brp_out.btb_hit),
	.xm_pht_taken(xm_brp_out.pht_taken),
	.ex_dest(dx_ir_out[11:9]),
	.id_sr1(fd_ir_out[8:6]),
	.id_sr2(fd_ir_out[2:0])
);

endmodule: cpu















