onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider clk_reset
add wave -noupdate :cic3_64x4_selfcheck_tb:clk
add wave -noupdate :cic3_64x4_selfcheck_tb:reset_n
add wave -noupdate :cic3_64x4_selfcheck_tb:divided_clk
add wave -noupdate :cic3_64x4_selfcheck_tb:clk_counter
add wave -noupdate :cic3_64x4_selfcheck_tb:dut_inputs
add wave -noupdate -divider stimulus
add wave -noupdate -format Analog-Step -height 84 -max 1.01 -min -1.01 :cic3_64x4_selfcheck_tb:stimulus_gen:sine_input
add wave -noupdate :cic3_64x4_selfcheck_tb:stimulus_gen:modulator_outputs
add wave -noupdate :cic3_64x4_selfcheck_tb:stimulus_gen:golden_modulator_out
add wave -noupdate -divider scoreboard
add wave -noupdate -format Analog-Step -height 84 -max 8184.0 -min -8192.0 :cic3_64x4_selfcheck_tb:golden_output
add wave -noupdate -format Analog-Step -height 84 -max 8184.0 -min -8192.0 :cic3_64x4_selfcheck_tb:adi_golden_output
add wave -noupdate -format Analog-Step -height 84 -max 8184.0 -min -8192.0 :cic3_64x4_selfcheck_tb:dut:out0_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out0_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out1_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out1_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out2_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out2_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out62_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out62_1
add wave -noupdate -format Analog-Step -height 84 -max 8184.0 -min -8192.0 :cic3_64x4_selfcheck_tb:dut:out63_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out63_1
add wave -noupdate -divider {all 25bits}
add wave -noupdate -format Analog-Step -height 84 -max 12621788.0 {:cic3_64x4_selfcheck_tb:dut:FILTERS_COL1[0]:cic3_echip65_14b:diff3}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1607775000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 276
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
WaveRestoreZoom {0 ps} {2700195750 ps}
