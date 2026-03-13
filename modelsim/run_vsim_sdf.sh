#!/bin/bash

# SDF Simulation Script for Post-PnR Timing Verification
# This script runs ModelSim with SDF back-annotation for timing-accurate simulations
# SDF files are located in ../signoff/ directory

echo "=========================================="
echo "SDF Simulation Script for CIC3 64x4 Design"
echo "=========================================="

# Default corner is worst-case setup
CORNER="wc_setup"
SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_setup_wc_tempus_signoff.sdf"

# Parse command line arguments
if [ $# -gt 0 ]; then
    case "$1" in
        wc_setup|wc)
            CORNER="wc_setup"
            SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_setup_wc_tempus_signoff.sdf"
            echo "Selected corner: Worst-Case Setup"
            ;;
        wclt_setup|wclt)
            CORNER="wclt_setup"
            SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_setup_wclt_tempus_signoff.sdf"
            echo "Selected corner: Worst-Case Low-Temp Setup"
            ;;
        bc_hold|bc)
            CORNER="bc_hold"
            SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_hold_bc_tempus_signoff.sdf"
            echo "Selected corner: Best-Case Hold"
            ;;
        tc_hold|tc)
            CORNER="tc_hold"
            SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_hold_tc_tempus_signoff.sdf"
            echo "Selected corner: Typical-Case Hold"
            ;;
        wc_hold)
            CORNER="wc_hold"
            SDF_FILE="../signoff/cic3_echip65_14b_64Rowsx4Cols_av_hold_wc_tempus_signoff.sdf"
            echo "Selected corner: Worst-Case Hold"
            ;;
        *)
            echo "Unknown corner: $1"
            echo "Usage: $0 [corner]"
            echo "Available corners:"
            echo "  wc_setup  | wc   - Worst-Case Setup (default)"
            echo "  wclt_setup| wclt - Worst-Case Low-Temp Setup"
            echo "  bc_hold   | bc   - Best-Case Hold"
            echo "  tc_hold   | tc   - Typical-Case Hold"
            echo "  wc_hold          - Worst-Case Hold"
            exit 1
            ;;
    esac
else
    echo "No corner specified, using default: Worst-Case Setup"
fi

# Check if SDF file exists
if [ ! -f "$SDF_FILE" ]; then
    echo "ERROR: SDF file not found: $SDF_FILE"
    exit 1
fi

echo "SDF File: $SDF_FILE"
echo "=========================================="

# Clean old work library
echo "Cleaning old work library..."
rm -rf work

# Export SDF file path for use in .do script
export SDF_FILE_PATH="$SDF_FILE"
export SIM_CORNER="$CORNER"

echo "Starting ModelSim with SDF back-annotation..."
echo ""

# Run ModelSim with the SDF-specific .do file
    echo "Running default SDF testbench: cic3_64x4_sdf_tb.do"
    vsim -do cic3_64x4_sdf_tb.do

