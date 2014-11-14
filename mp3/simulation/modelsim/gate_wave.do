onerror {resume}
quietly radix -hexadecimal
quietly WaveActivateNextPane {} 0

#######
## PC #
#######
#quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
#        \datapath|fetch|pc|data[15] /q, \datapath|fetch|pc|data[14] /q ,
#        \datapath|fetch|pc|data[13] /q, \datapath|fetch|pc|data[12] /q ,
#        \datapath|fetch|pc|data[11] /q, \datapath|fetch|pc|data[10] /q ,
#        \datapath|fetch|pc|data[9] /q, \datapath|fetch|pc|data[8] /q ,
#        \datapath|fetch|pc|data[7] /q, \datapath|fetch|pc|data[6] /q ,
#        \datapath|fetch|pc|data[5] /q, \datapath|fetch|pc|data[4] /q ,
#        \datapath|fetch|pc|data[3] /q, \datapath|fetch|pc|data[2] /q ,
#        \datapath|fetch|pc|data[1] /q, 1'b0
#    }} PC
#
########
## MAR #
########
#quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
#        \datapath|execute|mar|data[15] /q, \datapath|execute|mar|data[14] /q ,
#        \datapath|execute|mar|data[13] /q, \datapath|execute|mar|data[12] /q ,
#        \datapath|execute|mar|data[11] /q, \datapath|execute|mar|data[10] /q ,
#        \datapath|execute|mar|data[9] /q, \datapath|execute|mar|data[8] /q ,
#        \datapath|execute|mar|data[7] /q, \datapath|execute|mar|data[6] /q ,
#        \datapath|execute|mar|data[5] /q, \datapath|execute|mar|data[4] /q ,
#        \datapath|execute|mar|data[3] /q, \datapath|execute|mar|data[2] /q ,
#        \datapath|execute|mar|data[1] /q, 1'b0
#    }} MAR

#############
# Registers #
#############
quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~15 /q , \CPU|regfile|data~14 /q ,
        \CPU|regfile|data~13 /q , \CPU|regfile|data~12 /q ,
        \CPU|regfile|data~11 /q , \CPU|regfile|data~10 /q ,
        \CPU|regfile|data~9 /q , \CPU|regfile|data~8 /q ,
        \CPU|regfile|data~7 /q , \CPU|regfile|data~6 /q ,
        \CPU|regfile|data~5 /q , \CPU|regfile|data~4 /q ,
        \CPU|regfile|data~3 /q , \CPU|regfile|data~2 /q ,
        \CPU|regfile|data~1 /q , \CPU|regfile|data~0 /q
    }} R0

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~31 /q , \CPU|regfile|data~30 /q ,
        \CPU|regfile|data~29 /q , \CPU|regfile|data~28 /q ,
        \CPU|regfile|data~27 /q , \CPU|regfile|data~26 /q ,
        \CPU|regfile|data~25 /q , \CPU|regfile|data~24 /q ,
        \CPU|regfile|data~23 /q , \CPU|regfile|data~22 /q ,
        \CPU|regfile|data~21 /q , \CPU|regfile|data~20 /q ,
        \CPU|regfile|data~19 /q , \CPU|regfile|data~18 /q ,
        \CPU|regfile|data~17 /q , \CPU|regfile|data~16 /q
    }} R1

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~47 /q , \CPU|regfile|data~46 /q ,
        \CPU|regfile|data~45 /q , \CPU|regfile|data~44 /q ,
        \CPU|regfile|data~43 /q , \CPU|regfile|data~42 /q ,
        \CPU|regfile|data~41 /q , \CPU|regfile|data~40 /q ,
        \CPU|regfile|data~39 /q , \CPU|regfile|data~38 /q ,
        \CPU|regfile|data~37 /q , \CPU|regfile|data~36 /q ,
        \CPU|regfile|data~35 /q , \CPU|regfile|data~34 /q ,
        \CPU|regfile|data~33 /q , \CPU|regfile|data~32 /q
    }} R2

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~63 /q , \CPU|regfile|data~62 /q ,
        \CPU|regfile|data~61 /q , \CPU|regfile|data~60 /q ,
        \CPU|regfile|data~59 /q , \CPU|regfile|data~58 /q ,
        \CPU|regfile|data~57 /q , \CPU|regfile|data~56 /q ,
        \CPU|regfile|data~55 /q , \CPU|regfile|data~54 /q ,
        \CPU|regfile|data~53 /q , \CPU|regfile|data~52 /q ,
        \CPU|regfile|data~51 /q , \CPU|regfile|data~50 /q ,
        \CPU|regfile|data~49 /q , \CPU|regfile|data~48 /q
    }} R3

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~79 /q , \CPU|regfile|data~78 /q ,
        \CPU|regfile|data~77 /q , \CPU|regfile|data~76 /q ,
        \CPU|regfile|data~75 /q , \CPU|regfile|data~74 /q ,
        \CPU|regfile|data~73 /q , \CPU|regfile|data~72 /q ,
        \CPU|regfile|data~71 /q , \CPU|regfile|data~70 /q ,
        \CPU|regfile|data~69 /q , \CPU|regfile|data~68 /q ,
        \CPU|regfile|data~67 /q , \CPU|regfile|data~66 /q ,
        \CPU|regfile|data~65 /q , \CPU|regfile|data~64 /q
    }} R4

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~95 /q , \CPU|regfile|data~94 /q ,
        \CPU|regfile|data~93 /q , \CPU|regfile|data~92 /q ,
        \CPU|regfile|data~91 /q , \CPU|regfile|data~90 /q ,
        \CPU|regfile|data~89 /q , \CPU|regfile|data~88 /q ,
        \CPU|regfile|data~87 /q , \CPU|regfile|data~86 /q ,
        \CPU|regfile|data~85 /q , \CPU|regfile|data~84 /q ,
        \CPU|regfile|data~83 /q , \CPU|regfile|data~82 /q ,
        \CPU|regfile|data~81 /q , \CPU|regfile|data~80 /q
    }} R5

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~111 /q , \CPU|regfile|data~110 /q ,
        \CPU|regfile|data~109 /q , \CPU|regfile|data~108 /q ,
        \CPU|regfile|data~107 /q , \CPU|regfile|data~106 /q ,
        \CPU|regfile|data~105 /q , \CPU|regfile|data~104 /q ,
        \CPU|regfile|data~103 /q , \CPU|regfile|data~102 /q ,
        \CPU|regfile|data~101 /q , \CPU|regfile|data~100 /q ,
        \CPU|regfile|data~99 /q , \CPU|regfile|data~98 /q ,
        \CPU|regfile|data~97 /q , \CPU|regfile|data~96 /q
    }} R6

quietly virtual signal -install /mp3_w_l1cache_tb { (context /mp3_w_l1cache_tb/dut )&{
        \CPU|regfile|data~127 /q , \CPU|regfile|data~126 /q ,
        \CPU|regfile|data~125 /q , \CPU|regfile|data~124 /q ,
        \CPU|regfile|data~123 /q , \CPU|regfile|data~122 /q ,
        \CPU|regfile|data~121 /q , \CPU|regfile|data~120 /q ,
        \CPU|regfile|data~119 /q , \CPU|regfile|data~118 /q ,
        \CPU|regfile|data~117 /q , \CPU|regfile|data~116 /q ,
        \CPU|regfile|data~115 /q , \CPU|regfile|data~114 /q ,
        \CPU|regfile|data~113 /q , \CPU|regfile|data~112 /q
    }} R7

add wave -noupdate -expand /mp3_w_l1cache_tb/clk
#add wave -noupdate /mp3_w_l1cache_tb/MAR
#add wave -noupdate /mp3_w_l1cache_tb/PC
add wave -noupdate /mp3_w_l1cache_tb/R0
add wave -noupdate /mp3_w_l1cache_tb/R1
add wave -noupdate /mp3_w_l1cache_tb/R2
add wave -noupdate /mp3_w_l1cache_tb/R3
add wave -noupdate /mp3_w_l1cache_tb/R4
add wave -noupdate /mp3_w_l1cache_tb/R5
add wave -noupdate /mp3_w_l1cache_tb/R6
add wave -noupdate /mp3_w_l1cache_tb/R7

TreeUpdate [SetDefaultTree]
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 4300
configure wave -gridperiod 8600
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
