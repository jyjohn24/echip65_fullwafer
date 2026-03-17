///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_scoreboard.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Output checking scoreboard for 64x4 CIC3 testbench
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

import cic3_64x4_test_pkg::*;

module cic3_64x4_scoreboard (
    input  logic                          clk,
    input  logic                          reset_n,
    input  logic                          enable,
    input  logic [OUTPUT_WIDTH-1:0]       dut_outputs [NUM_ROWS-1:0][NUM_COLS-1:0],
    input  logic [OUTPUT_WIDTH-1:0]       golden_output,
    output test_stats_t                   stats,
    output logic                          test_complete
);

    // Internal state
    logic                          checking_enabled;
    logic                          first_error_reported [NUM_ROWS-1:0][NUM_COLS-1:0];
    
    // Import checking functions
    `include "tasks/cic3_64x4_checker_functions.sv"
    
    // Initialization
    // Initialization removed; reset handled in always_ff
    
    // Enable Control
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            checking_enabled <= 0;
        end else begin
            checking_enabled <= enable;
        end
    end
    
    // Output Checking Logic
    // Check all outputs against golden reference
    task automatic check_all_outputs();
        int row, col;
        bit mismatch_found;
        
        mismatch_found = 0;
        stats.total_checks++;
        
        for (row = 0; row < NUM_ROWS; row++) begin
            for (col = 0; col < NUM_COLS; col++) begin
                if (dut_outputs[row][col] !== golden_output) begin
                    // Only report first error for each filter to avoid log spam
                    if (!first_error_reported[row][col]) begin
                        $display("[ERROR] @%0t: Filter[%0d][%0d] mismatch: Expected=%h, Got=%h", 
                                 $time, row, col, golden_output, dut_outputs[row][col]);
                        first_error_reported[row][col] = 1;
                    end
                    stats.error_count[row][col]++;
                    stats.total_errors++;
                    mismatch_found = 1;
                end
            end
        end
    endtask
    
    // Checking Process with reset and test completion
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset internal registers
            test_complete <= 0;
            stats.total_checks <= 0;
            stats.total_errors <= 0;
            stats.output_sample_count <= 0;
            stats.test_passed <= 0;
            // Reset error counters and flags
            for (int i = 0; i < NUM_ROWS; i++) begin
                for (int j = 0; j < NUM_COLS; j++) begin
                    stats.error_count[i][j] <= 0;
                    first_error_reported[i][j] <= 0;
                end
            end
        end else begin
            if (checking_enabled) begin
                check_all_outputs();
                stats.output_sample_count <= stats.output_sample_count + 1;
                // Display progress periodically
                if (stats.total_checks % 100 == 0) begin
                    $display("[INFO] @%0t: Completed %0d percent output checks, Total Errors=%0d", $time, stats.total_checks, stats.total_errors);
                end
                // Check if test duration reached
                if (stats.output_sample_count >= TEST_DURATION_SAMPLES) begin
                    test_complete <= 1;
                    stats.test_passed <= (stats.total_errors == 0);
                end
            end
        end
    end

endmodule : cic3_64x4_scoreboard
