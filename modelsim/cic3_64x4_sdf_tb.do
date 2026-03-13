# ModelSim SDF simulation script for CIC3 64x4 testbench
# File: cic3_64x4_sdf_tb.do
# This script performs timing-accurate simulation with SDF back-annotation

# Create or clear the work library
if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# Compile TSMC library files (required for SDF simulation)
echo "Compiling TSMC library files..."
if {![file exists tcbn65lp_pwr]} {
    do compile_reflibs.do
}

# Compile source files
echo "Compiling post-PnR netlist..."
# Note: Update this path to point to your post-PnR netlist
vlog -sv ../signoff/cic3_echip65_14b_64Rowsx4Cols.signoff.v

# Compile testbench - Modular components in correct order
echo "Compiling testbench components..."
vlog -sv ../testbench/analog_models/shift_reg.sv
vlog -sv ../testbench/analog_models/sine_wave.sv
vlog -sv ../testbench/analog_models/echip_clk_generator.sv
vlog -sv ../testbench/analog_models/sdm_rnm.sv
echo "Compiling adi code"
vlog -sv ../testbench/analog_models/cic3_adi_14b.sv
vlog -sv ../testbench/analog_models/cic3_echip65_14b_golden.sv
echo "Compiling sd_mod2"
vlog -sv ../testbench/analog_models/sd_mod2.sv
echo "Compiling sd_mod2_wrapper"
vlog -sv ../testbench/analog_models/sdm_rnm_sd_mod2_wrapper.sv
echo "Compiling testbench (modular architecture)..."
echo "  - Compiling test package..."
vlog -sv ../testbench/cic3_64x4_test_pkg.sv
echo "  - Compiling checker functions..."
vlog -sv ../testbench/tasks/cic3_64x4_checker_functions.sv
echo "  - Compiling test tasks..."
vlog -sv ../testbench/tasks/cic3_64x4_tasks.sv
echo "  - Compiling stimulus generator.."
vlog -sv ../testbench/cic3_64x4_stimulus_gen.sv
echo "  - Compiling scoreboard..."
vlog -sv ../testbench/cic3_64x4_scoreboard.sv
echo "  - Compiling top-level testbench..."
vlog -sv ../testbench/cic3_64x4_selfcheck_tb.sv

# Get SDF file path from environment variable (set by run_vsim_sdf.sh)
if {[info exists env(SDF_FILE_PATH)]} {
    set sdf_file $env(SDF_FILE_PATH)
    set corner $env(SIM_CORNER)
    echo "SDF File: $sdf_file"
    echo "Corner: $corner"
} else {
    # Default SDF file if environment variable not set
    set sdf_file "../signoff/cic3_echip65_14b_64Rowsx4Cols_av_setup_wc_tempus_signoff.sdf"
    set corner "wc_setup"
    echo "Using default SDF file: $sdf_file"
}

# Simulate with SDF back-annotation
echo "Starting simulation with SDF back-annotation..."
vsim -L tcbn65lp_pwr -L tcbn65lphvt_pwr -L tcbn65lplvt_pwr \
     -suppress 12027 \
     work.cic3_64x4_selfcheck_tb \
     -sdfnoerror \
     -vopt \
     -voptargs="+acc -xprop,mode=resolve" \
     -sdfmax :cic3_64x4_selfcheck_tb:dut=$sdf_file

# Configure SDF warnings/errors
# Suppress common SDF warnings that don't affect functionality
# set StdArithNoWarnings 1
# set NumericStdNoWarnings 1

# Add waveforms
echo "Adding waveforms..."
do cic3_64x4_sdf_tb_wave.do

# Set the window types
view wave
view structure
view signals

# Run simulation
echo "Running test with SDF timing..."
run -all

# Display final results
echo "=========================================="
echo "SDF Simulation complete for corner: $corner"
echo "Check the transcript for timing violations and results."
echo "=========================================="
