///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_checker_functions.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Checking functions for 64x4 CIC3 testbench
// NOTE: AI-generated from cic3_64x4_selfcheck_tb.sv
//       These funcitions are not use and called anywhere currently.
//       They are generated while testing Agentic planning phase 
///////////////////////////////////////////////////////////////////

import cic3_64x4_test_pkg::*;

///////////////////////////////////////////////////////////////////
// Function: check_single_output
// Description: Check a single filter output against golden reference
// Returns: 1 if match, 0 if mismatch
///////////////////////////////////////////////////////////////////
function automatic bit check_single_output(
    input logic [OUTPUT_WIDTH-1:0] dut_output,
    input logic [OUTPUT_WIDTH-1:0] golden_output,
    input int row,
    input int col
);
    if (dut_output !== golden_output) begin
        $display("[ERROR] @%0t: Filter[%0d][%0d] mismatch: Expected=%h, Got=%h", 
                 $time, row, col, golden_output, dut_output);
        return 0;
    end
    return 1;
endfunction

///////////////////////////////////////////////////////////////////
// Function: check_output_range
// Description: Check if output is within expected range (optional)
// Returns: 1 if within range, 0 otherwise
///////////////////////////////////////////////////////////////////
function automatic bit check_output_range(
    input logic [OUTPUT_WIDTH-1:0] output_val,
    input logic [OUTPUT_WIDTH-1:0] min_val,
    input logic [OUTPUT_WIDTH-1:0] max_val,
    input int row,
    input int col
);
    if (output_val < min_val || output_val > max_val) begin
        $display("[WARN] @%0t: Filter[%0d][%0d] output=%h outside range [%h:%h]", 
                 $time, row, col, output_val, min_val, max_val);
        return 0;
    end
    return 1;
endfunction

///////////////////////////////////////////////////////////////////
// Function: calculate_snr
// Description: Calculate Signal-to-Noise Ratio (placeholder)
// Returns: SNR in dB as real number
///////////////////////////////////////////////////////////////////
function automatic real calculate_snr(
    input logic [OUTPUT_WIDTH-1:0] signal_samples[$],
    input logic [OUTPUT_WIDTH-1:0] noise_samples[$]
);
    real signal_power = 0.0;
    real noise_power = 0.0;
    real snr_db = 0.0;
    
    // Simplified SNR calculation - can be expanded
    // This is a placeholder for more complex SNR calculations
    if (signal_samples.size() > 0 && noise_samples.size() > 0) begin
        foreach(signal_samples[i]) begin
            signal_power += real'(signal_samples[i]) ** 2;
        end
        foreach(noise_samples[i]) begin
            noise_power += real'(noise_samples[i]) ** 2;
        end
        
        signal_power /= real'(signal_samples.size());
        noise_power /= real'(noise_samples.size());
        
        if (noise_power > 0.0) begin
            snr_db = 10.0 * $log10(signal_power / noise_power);
        end
    end
    
    return snr_db;
endfunction

///////////////////////////////////////////////////////////////////
// Function: compare_outputs_tolerance
// Description: Compare two outputs with tolerance
// Returns: 1 if within tolerance, 0 otherwise
///////////////////////////////////////////////////////////////////
function automatic bit compare_outputs_tolerance(
    input logic [OUTPUT_WIDTH-1:0] output1,
    input logic [OUTPUT_WIDTH-1:0] output2,
    input int tolerance,
    input int row,
    input int col
);
    int diff;
    diff = $signed(output1) - $signed(output2);
    
    if (diff < 0) diff = -diff;  // Absolute value
    
    if (diff > tolerance) begin
        $display("[ERROR] @%0t: Filter[%0d][%0d] tolerance exceeded: diff=%0d (tolerance=%0d)", 
                 $time, row, col, diff, tolerance);
        return 0;
    end
    return 1;
endfunction
