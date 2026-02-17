///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_tasks.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Reusable test tasks for 64x4 CIC3 testbench
///////////////////////////////////////////////////////////////////

import cic3_64x4_test_pkg::*;

// Task: initialize_test_stats
// Initialize test statistics structure
task automatic initialize_test_stats(
    ref test_stats_t stats
);
    stats.total_checks = 0;
    stats.total_errors = 0;
    stats.output_sample_count = 0;
    stats.test_passed = 0;
    
    // Initialize error counters
    for (int i = 0; i < NUM_ROWS; i++) begin
        for (int j = 0; j < NUM_COLS; j++) begin
            stats.error_count[i][j] = 0;
        end
    end
endtask

// Task: display_test_header
// Display testbench header information
task automatic display_test_header();
    $display("\n");
    $display("================================================================================");
    $display("         CIC3 64x4 Filter Array Self-Checking Testbench");
    $display("================================================================================");
    $display("Configuration:");
    $display("  Number of Filters:     %0d (%0dx%0d)", NUM_FILTERS, NUM_ROWS, NUM_COLS);
    $display("  Clock Period:          %0d ns (%0d MHz)", CLK_PERIOD_NS, 1000/CLK_PERIOD_NS);
    $display("  Decimation Factor:     %0d", DECIMATION_FACTOR);
    $display("  Output Width:          %0d bits", OUTPUT_WIDTH);
    $display("  Settling Time:         %0d cycles", SETTLING_TIME_CYCLES);
    $display("  Test Duration:         %0d samples", TEST_DURATION_SAMPLES);
    $display("================================================================================");
    $display("\n");
endtask

// Task: display_test_summary
// Display final test summary with statistics
task automatic display_test_summary(
    input test_stats_t stats
);
    int row, col;
    int filters_with_errors;
    
    filters_with_errors = 0;
    
    $display("\n");
    $display("================================================================================");
    $display("                        TEST SUMMARY");
    $display("================================================================================");
    $display("Total Output Checks Performed: %0d", stats.total_checks);
    $display("Total Errors Detected:         %0d", stats.total_errors);
    $display("Test Duration (samples):       %0d", stats.output_sample_count);
    $display("Settling Time (cycles):        %0d", SETTLING_TIME_CYCLES);
    $display("================================================================================");
    
    // Count filters with errors
    for (row = 0; row < NUM_ROWS; row++) begin
        for (col = 0; col < NUM_COLS; col++) begin
            if (stats.error_count[row][col] > 0) begin
                filters_with_errors++;
            end
        end
    end
    
    if (stats.total_errors == 0) begin
        $display("*** TEST PASSED *** All %0d filters matched golden reference!", NUM_FILTERS);
    end else begin
        $display("*** TEST FAILED *** %0d/%0d filters have mismatches", 
                 filters_with_errors, NUM_FILTERS);
        
        // Display error breakdown by filter
        $display("\nError Breakdown by Filter:");
        $display("Row  Col  Error_Count");
        $display("---  ---  -----------");
        for (row = 0; row < NUM_ROWS; row++) begin
            for (col = 0; col < NUM_COLS; col++) begin
                if (stats.error_count[row][col] > 0) begin
                    $display("%3d  %3d  %11d", row, col, stats.error_count[row][col]);
                end
            end
        end
    end
    
    $display("================================================================================");
    $display("\n");
endtask

// Task: apply_reset_sequence to DUT
task automatic apply_reset_sequence(
    ref logic reset_n,
    input int reset_duration_ns
);
    $display("[INFO] @%0t: Asserting reset...", $time);
    reset_n = 0;
    #reset_duration_ns;
    reset_n = 1;
    $display("[INFO] @%0t: Reset deasserted", $time);
endtask

// Task: wait_for_settling
task automatic wait_for_settling(
    input int settling_cycles,
    input int clk_period
);
    $display("[INFO] @%0t: Waiting for settling (%0d cycles)...", $time, settling_cycles);
    #(settling_cycles * clk_period);
    $display("[INFO] @%0t: Settling complete", $time);
endtask

task automatic delay_ns(
    input int delay_ns
);
    #(delay_ns);    
endtask

// Task: display_progress
// Display periodic progress updates
task automatic display_progress(
    input test_stats_t stats,
    input int update_interval
);
    if (stats.total_checks % update_interval == 0) begin
        $display("[INFO] @%0t: Completed %0d output checks, Total Errors=%0d", 
                 $time, stats.total_checks, stats.total_errors);
    end
endtask

// Task: dump_waveforms
// Enable waveform dumping (VCD format)
task automatic dump_waveforms(
    input string filename
);
    $display("[INFO] Enabling waveform dump to: %s", filename);
    //$dumpfile(filename);
    //$dumpvars(0);
    //////////////////////////Questa commands//////////////////////////
    //#do {wave.gate.do}
    //do larpix_minimal_vcd.do
    //# Set the window types
    //#
    //view wave
    //view structure
    //view signals
    //vcd file larpix_v3b.single_tb.vcd
    //vcd add -ports larpix_single_tb:larpix_v3b_inst:*
    ///////////////////////////////////////////////////////////////////
endtask

// Task: display_filter_status
// Display status of specific filter
task automatic display_filter_status(
    input int row,
    input int col,
    input logic [OUTPUT_WIDTH-1:0] output_val,
    input logic [OUTPUT_WIDTH-1:0] golden_val
);
    $display("[INFO] @%0t: Filter[%0d][%0d] Output=%h Golden=%h", 
             $time, row, col, output_val, golden_val);
endtask

// Task: export_results_to_file
// Export test results to file (optional)
task automatic export_results_to_file(
    input test_stats_t stats,
    input string filename
);
    int fd;
    int row, col;
    
    fd = $fopen(filename, "w");
    if (fd) begin
        $fdisplay(fd, "CIC3 64x4 Test Results");
        $fdisplay(fd, "======================");
        $fdisplay(fd, "Total Checks: %0d", stats.total_checks);
        $fdisplay(fd, "Total Errors: %0d", stats.total_errors);
        $fdisplay(fd, "Test Passed: %0s", stats.test_passed ? "YES" : "NO");
        $fdisplay(fd, "\nError Count by Filter:");
        $fdisplay(fd, "Row, Col, Errors");
        
        for (row = 0; row < NUM_ROWS; row++) begin
            for (col = 0; col < NUM_COLS; col++) begin
                if (stats.error_count[row][col] > 0) begin
                    $fdisplay(fd, "%0d, %0d, %0d", row, col, stats.error_count[row][col]);
                end
            end
        end
        
        $fclose(fd);
        $display("[INFO] Results exported to: %s", filename);
    end else begin
        $display("[ERROR] Failed to open file: %s", filename);
    end
endtask
