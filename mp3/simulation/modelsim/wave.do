onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal -childformat {{{/mp3_w_l1cache_tb/dut/CPU/regfile/data[7]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[6]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[5]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[4]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[3]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[2]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[1]} -radix hexadecimal} {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_w_l1cache_tb/dut/CPU/regfile/data[7]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[6]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[5]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[4]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[3]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[2]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[1]} {-radix hexadecimal} {/mp3_w_l1cache_tb/dut/CPU/regfile/data[0]} {-radix hexadecimal}} /mp3_w_l1cache_tb/dut/CPU/regfile/data
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/data_mem_wdata
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/data_mem_resp
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/data_mem_write
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/pc/data
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/fd_pc_out
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/fd_ir_out
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/dx_pc_out
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/dx_ir_out
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/xm_pc_out
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/xm_ir_out
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/mw_pc_out
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/mw_ir_out
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/inst_mem_resp
add wave -noupdate -radix hexadecimal /mp3_w_l1cache_tb/dut/CPU/pc/in
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/pc/load
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/BEN
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/hazard_unit/id_sr2
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/hazard_unit/id_sr1
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/hazard_unit/d_read
add wave -noupdate /mp3_w_l1cache_tb/dut/CPU/hazard_unit/ex_dest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3890160 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 301
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
restart -f
log -r *
