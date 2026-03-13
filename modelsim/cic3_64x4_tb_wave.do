onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider clk_reset
add wave -noupdate :cic3_64x4_selfcheck_tb:clk
add wave -noupdate :cic3_64x4_selfcheck_tb:reset_n
add wave -noupdate :cic3_64x4_selfcheck_tb:divided_clk
add wave -noupdate :cic3_64x4_selfcheck_tb:clk_counter
add wave -noupdate :cic3_64x4_selfcheck_tb:echip65_clk_generator:phi1
add wave -noupdate :cic3_64x4_selfcheck_tb:echip65_clk_generator:phi2
add wave -noupdate :cic3_64x4_selfcheck_tb:echip65_clk_generator:phi1F
add wave -noupdate :cic3_64x4_selfcheck_tb:echip65_clk_generator:sclk
add wave -noupdate :cic3_64x4_selfcheck_tb:dut_inputs
add wave -noupdate -divider stimulus
add wave -noupdate -color red -format Analog-Step -height 84 -max 0.98999899999999996 -min -0.98999999999999999 :cic3_64x4_selfcheck_tb:stimulus_gen_inst:sine_input
add wave -noupdate {:cic3_64x4_selfcheck_tb:dut_inputs[0]}
add wave -noupdate -divider scoreboard
add wave -noupdate -color green -format Analog-Step -height 84 -max 16291.0 -radix unsigned :cic3_64x4_selfcheck_tb:golden_output
add wave -noupdate -format Analog-Step -height 84 -max 8184.9999999999991 -min -8192.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:out_signed
add wave -noupdate -radix binary -childformat {{{:cic3_64x4_selfcheck_tb:adi_golden_output[13]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[12]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[11]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[10]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[9]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[8]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[7]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[6]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[5]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[4]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[3]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[2]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[1]} -radix binary} {{:cic3_64x4_selfcheck_tb:adi_golden_output[0]} -radix binary}} -subitemconfig {{:cic3_64x4_selfcheck_tb:adi_golden_output[13]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[12]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[11]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[10]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[9]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[8]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[7]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[6]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[5]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[4]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[3]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[2]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[1]} {-height 17 -radix binary} {:cic3_64x4_selfcheck_tb:adi_golden_output[0]} {-height 17 -radix binary}} :cic3_64x4_selfcheck_tb:adi_golden_output
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out0_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out0_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out1_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out1_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out2_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out2_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out62_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out62_1
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out63_0
add wave -noupdate :cic3_64x4_selfcheck_tb:dut:out63_1
add wave -noupdate -divider {all 25bits}
add wave -noupdate -color {royal blue} -format Analog-Step -height 84 -max 2097.0 -min -2.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:acc1
add wave -noupdate -color yellow -format Analog-Step -height 84 -max 16775800.000000002 -min -16776800.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:acc2
add wave -noupdate -color magenta -format Analog-Step -height 84 -max 16775699.999999998 -min -16777100.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:acc3
add wave -noupdate -color cyan -format Analog-Step -height 84 -max 16468000.0 -min -16346100.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:acc3_d
add wave -noupdate -color red -format Analog-Step -height 84 -max 16250100.000000002 -min -16626200.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:diff1
add wave -noupdate -format Analog-Step -height 84 -max 16250100.000000002 -min -16626200.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:diff1_d
add wave -noupdate -color green -format Analog-Step -height 84 -max 16720699.999999998 -min -16773900.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:diff2
add wave -noupdate -format Analog-Step -height 84 -max 16720699.999999998 -min -16773900.0 -radix decimal :cic3_64x4_selfcheck_tb:golden_filter:diff2_d
add wave -noupdate -color {royal blue} -format Analog-Step -height 84 -max 16763500.0 -min -16777200.0 -radix decimal {:cic3_64x4_selfcheck_tb:dut:FILTERS_COL1[0]:cic3_echip65_14b:diff3}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {221295000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 525
configure wave -valuecolwidth 330
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
WaveRestoreZoom {0 ps} {5161032450 ps}
