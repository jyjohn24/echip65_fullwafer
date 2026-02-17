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
    //parameter int CLK_PERIOD_NS = 10;  // 100 MHz

    //Parameter from JJ for actal input clock frequencies and appriximate delays
    parameter int CLK_PERIOD_NS = 12.207/2.0; //[ns] (12.20703125ns is actual period); 81.92Mhz high speed input serializer clock

    parameter int PHI1_DELAY = 5; //[ns]; propagation delay from source to modulator clk input (will have skew across modulators)
    parameter int PHI2_DELAY = 5; //[ns]; propagation delay from source to modulator clk input (will have skew across modulators)

    parameter int PHI1F_DELAY_MIN = 3; //[ns]; min propagation delay from source to filter clk input (will have skew across filter rows)
    parameter int PHI1F_DELAY_INTER = 1.0; //[ns]; relative propagation delay from one filter input to next (will have skew across filter rows)

    parameter int FINPUT_DELAY_MIN = 3; //[ns]; min propagation delay from modulator output to filter input (will have skew across filter rows)
    parameter int FINPUT_DELAY_INTER = 1.0; //[ns]; relative propagation delay from one filter input to next  (will have skew across filter rows)



    // Test Configuration
    parameter int SETTLING_TIME_CYCLES = 1000;
    parameter int TEST_DURATION_SAMPLES = 500;  // Number of output samples to check
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
