# ModelSim compilation and simulation script for CIC3 64x4 testbench
# File: cic3_64x4_tb.do

# Create or clear the work library
if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# Compile source files
echo "Compiling source files..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/src/cic3_echip65_14b_simple.sv
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/src/cic3_echip65_14b_64Rowsx4Cols_v1.sv


# Compile testbench - Modular components in correct order
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/shift_reg.sv
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/sine_wave.sv
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/echip_clk_generator.sv
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/sdm_rnm.sv
vlog -sv ../testbench/analog_models/cic3_echip65_14b_golden.sv
echo "Compiling adi code"
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/cic3_adi_14b.sv
echo "Compiling sd_mod2"
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/sd_mod2.sv
echo "Compiling sd_mod2_wrapper"
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/analog_models/sdm_rnm_sd_mod2_wrapper.sv
echo "Compiling testbench (modular architecture)..."
echo "  - Compiling test package..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/cic3_64x4_test_pkg.sv
echo "  - Compiling checker functions..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/tasks/cic3_64x4_checker_functions.sv
echo "  - Compiling test tasks..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/tasks/cic3_64x4_tasks.sv
echo "  - Compiling stimulus generator.."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/cic3_64x4_stimulus_gen.sv
echo "  - Compiling scoreboard..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/cic3_64x4_scoreboard.sv
echo "  - Compiling top-level testbench..."
vlog -sv /home/lxusers/t/tprakash/IC_DESIGN/GIT_CODE/echip65_WaferRun/echip65_fullwafer/testbench/cic3_64x4_selfcheck_tb.sv

# Simulate
echo "Starting simulation..."
vsim -voptargs=+acc work.cic3_64x4_selfcheck_tb

# adding waves
echo "adding wavesforms..."
do cic3_64x4_tb_wave.do

# Run simulation
echo "Running test..."
run -all

# Display final results
echo "Simulation complete. Check the transcript for results."
