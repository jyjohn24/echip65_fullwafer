///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_test_pkg.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Test parameters and types package for 64x4 CIC3 testbench
// NOTE: Auto-generated from cic3_64x4_selfcheck_tb.sv (model: calude-sonnet-high)
///////////////////////////////////////////////////////////////////

package cic3_64x4_test_pkg;

    // Design Parameters
    parameter int NUM_ROWS = 64;
    parameter int NUM_COLS = 4;
    parameter int NUM_FILTERS = NUM_ROWS * NUM_COLS;
    parameter int OUTPUT_WIDTH = 14;
    parameter int CLK_PERIOD_NS = 10;  // 100 MHz
    
    // Test Configuration
    parameter int SETTLING_TIME_CYCLES = 1000;
    parameter int TEST_DURATION_SAMPLES = 1000;  // Number of output samples to check
    parameter int DECIMATION_FACTOR = 256;
    
    // Test Status Types // TP : not used currently AI generated
    //typedef enum {
    //    TEST_IDLE,
    //    TEST_RESET,
    //    TEST_SETTLING,
    //    TEST_CHECKING,
    //    TEST_COMPLETE
    //} test_state_e;
    
    // Error tracking structure
    typedef struct {
        int error_count[NUM_ROWS-1:0][NUM_COLS-1:0];
        int total_checks;
        int total_errors;
        int output_sample_count;
        bit test_passed;
    } test_stats_t;
    
endpackage 
