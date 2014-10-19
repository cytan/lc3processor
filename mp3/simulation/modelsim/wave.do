onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/inst_mem_read
add wave -noupdate /mp3_tb/data_mem_read
add wave -noupdate /mp3_tb/inst_mem_write
add wave -noupdate /mp3_tb/data_mem_write
add wave -noupdate /mp3_tb/inst_mem_addr
add wave -noupdate /mp3_tb/data_mem_addr
add wave -noupdate /mp3_tb/inst_mem_rdata
add wave -noupdate /mp3_tb/data_mem_rdata
add wave -noupdate /mp3_tb/data_mem_wdata
add wave -noupdate /mp3_tb/dut/CPU/BEN
add wave -noupdate /mp3_tb/dut/CPU/bradder_out
add wave -noupdate /mp3_tb/dut/CPU/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3999261 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {256 ns}
