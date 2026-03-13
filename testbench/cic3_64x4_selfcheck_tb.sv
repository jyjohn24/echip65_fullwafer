`timescale 1ns/1ps

///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_selfcheck_tb.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Main testbench top for 64x4 CIC3 filter array
//              Tests cic3_echip65_14b_64Rowsx4Cols_v1 design
// Structure:
//  testbench/
//    ├── cic3_64x4_selfcheck_tb.sv          # Main testbench top 
//    ├── cic3_64x4_scoreboard.sv            # Output checking scoreboard 
//    ├── cic3_64x4_stimulus_gen.sv          # Stimulus generator
//    ├── cic3_64x4_test_pkg.sv              # Test parameters package
//    └── tasks/
//        ├── cic3_64x4_tasks.sv             # Reusable test tasks 
//        └── cic3_64x4_checker_functions.sv # Checking functions (unused)
///////////////////////////////////////////////////////////////////

import cic3_64x4_test_pkg::*;

module cic3_64x4_selfcheck_tb();

    // Clock & Reset
    logic clk;
    logic reset_n;
    logic clk_reset_n;
    
    // Stimulus signals
    real  sine_input;
    logic [NUM_FILTERS-1:0] modulator_outputs;
    logic [NUM_FILTERS-1:0] mod_out_Delayed; 
    logic golden_modulator_out;
    
    // DUT outputs (collected into 2D array for easier checking)
    logic [OUTPUT_WIDTH-1:0] dut_outputs [NUM_ROWS-1:0][NUM_COLS-1:0];
    
    // Golden reference
    logic [OUTPUT_WIDTH-1:0] golden_output;
    logic [OUTPUT_WIDTH-1:0] adi_golden_output;
    
    // Scoreboard signals
    test_stats_t stats;
    logic test_complete;
    logic scoreboard_enable;
    
    // clocks with delays
    logic divided_clk;
    int clk_counter;

    logic enable;
    logic phi1;
    logic phi1_delayed;
    logic phi2;
    logic phi2_delayed;
    logic phi1F;
    logic [(NUM_FILTERS-1):0] phi1F_delayed;
    logic sclk;
    logic cfg_sel_outBits;


    // Include task library
    `include "tasks/cic3_64x4_tasks.sv"
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Clock Generation - 81.92 MHz (12.207 ns period) 
    always #(CLK_PERIOD_NS/2) clk = ~clk;
    
    // Clock counter and divided clock generation
    always_ff @(posedge phi1 or negedge reset_n) begin
        if (!reset_n)
            clk_counter <= 0;
        else
            clk_counter <= clk_counter + 1;
    end
    
    assign divided_clk = clk_counter[7]; // Bit 7 toggles every 128 cycles (approximates decimation/2)

    echip_clk_generator echip65_clk_generator (    
        .phi1(phi1), //input clk to modulator (5.12 MHz); non-overlapping with phi2 (level-sensitive)
        .phi2(phi2), //input clk to modulator (5.12 MHz); non-overlapping with phi1 (level-sensitive)
        .phi1F(phi1F), //input clk to digital filters (5.12 MHz); (edge-sensitive)
        .sclk(sclk), //serial data clk, captures data for serializer (5.12 MHz); (edge-sensitive)
       .clk(clk), //input 81.92M MHz high speed serializer clk
        .enable(enable),
        .rstn(clk_reset_n)
    );
    // generated clk delays
    always @(phi1) phi1_delayed <= #(PHI1_DELAY) phi1;
    always @(phi2) phi2_delayed <= #(PHI2_DELAY) phi2;

    //clks come up left right so for a row, min delay is on left edge, max delay on right edge (this is for V5 mainly, other versions have 1 clk pin input and clk tree takes care of below)
    genvar m;
    generate
        // int k;
        for (m=0; m<NUM_FILTERS; m=m+1) begin : PHI1FDELAY
            always @(phi1F) phi1F_delayed[(m)] <= #(PHI1F_DELAY_MIN + (NUM_FILTERS-1-m)*PHI1F_DELAY_INTER) phi1F;
        end
    endgenerate

    //mod input come from right side so for a row, min delay is on right edge, max delay on left edge
    genvar n;
    generate
        // int k;
        for (n=0; n<NUM_FILTERS; n=n+1) begin : MODDELAY
            always @(modulator_outputs) mod_out_Delayed[(n)] <= #(FINPUT_DELAY_MIN + n*FINPUT_DELAY_INTER) modulator_outputs;
        end
    endgenerate

    //////////////////////////////////////////////////////////////////////////////////////////////////

    // Stimulus Generator Instantiation
    cic3_64x4_stimulus_gen #(
        .SDM_MODEL("bitstream_file"),  // Select SDM model for testing, options: sdm_rnm(Carl's RTL model) or sd_mod2(Katerina's verilogA model) 
                                       //     or bitstream_file(virtuoso modulator output), when bitstream_file is selected, povide the txt file path
        .BITSTREAM_FILE("../testbench/analog_data/sd_bitstream.txt")
    ) stimulus_gen_inst (
        .clk                   (phi2), 
        .reset_n               (reset_n),
        .modulator_outputs     (modulator_outputs),
        .golden_modulator_out  (golden_modulator_out),
        .sine_input            (sine_input)
    );
    
    // DUT Instantiation
    // Map modulator_outputs to DUT input
    logic [NUM_FILTERS-1:0] dut_inputs;
    assign dut_inputs = modulator_outputs;

    // Instantiate the 64x4 filter array
    // --------------------------------------------------
    // For SDF simulations, the parameter block below is excluded because
    // the post-PnR DUT does not have these parameters.
    // For RTL simulations, pass the following parameters to the DUT:
    //   .NUM_FILTERS_PERCOLUMN(NUM_ROWS),
    //   .NUM_COLUMNS(NUM_COLS)
    // --------------------------------------------------
    cic3_echip65_14b_64Rowsx4Cols dut (
        // Column 0 outputs //NOTE: Generated using AI Agent
        .out0_0(dut_outputs[0][0]),   .out1_0(dut_outputs[1][0]),   .out2_0(dut_outputs[2][0]),   .out3_0(dut_outputs[3][0]),
        .out4_0(dut_outputs[4][0]),   .out5_0(dut_outputs[5][0]),   .out6_0(dut_outputs[6][0]),   .out7_0(dut_outputs[7][0]),
        .out8_0(dut_outputs[8][0]),   .out9_0(dut_outputs[9][0]),   .out10_0(dut_outputs[10][0]), .out11_0(dut_outputs[11][0]),
        .out12_0(dut_outputs[12][0]), .out13_0(dut_outputs[13][0]), .out14_0(dut_outputs[14][0]), .out15_0(dut_outputs[15][0]),
        .out16_0(dut_outputs[16][0]), .out17_0(dut_outputs[17][0]), .out18_0(dut_outputs[18][0]), .out19_0(dut_outputs[19][0]),
        .out20_0(dut_outputs[20][0]), .out21_0(dut_outputs[21][0]), .out22_0(dut_outputs[22][0]), .out23_0(dut_outputs[23][0]),
        .out24_0(dut_outputs[24][0]), .out25_0(dut_outputs[25][0]), .out26_0(dut_outputs[26][0]), .out27_0(dut_outputs[27][0]),
        .out28_0(dut_outputs[28][0]), .out29_0(dut_outputs[29][0]), .out30_0(dut_outputs[30][0]), .out31_0(dut_outputs[31][0]),
        .out32_0(dut_outputs[32][0]), .out33_0(dut_outputs[33][0]), .out34_0(dut_outputs[34][0]), .out35_0(dut_outputs[35][0]),
        .out36_0(dut_outputs[36][0]), .out37_0(dut_outputs[37][0]), .out38_0(dut_outputs[38][0]), .out39_0(dut_outputs[39][0]),
        .out40_0(dut_outputs[40][0]), .out41_0(dut_outputs[41][0]), .out42_0(dut_outputs[42][0]), .out43_0(dut_outputs[43][0]),
        .out44_0(dut_outputs[44][0]), .out45_0(dut_outputs[45][0]), .out46_0(dut_outputs[46][0]), .out47_0(dut_outputs[47][0]),
        .out48_0(dut_outputs[48][0]), .out49_0(dut_outputs[49][0]), .out50_0(dut_outputs[50][0]), .out51_0(dut_outputs[51][0]),
        .out52_0(dut_outputs[52][0]), .out53_0(dut_outputs[53][0]), .out54_0(dut_outputs[54][0]), .out55_0(dut_outputs[55][0]),
        .out56_0(dut_outputs[56][0]), .out57_0(dut_outputs[57][0]), .out58_0(dut_outputs[58][0]), .out59_0(dut_outputs[59][0]),
        .out60_0(dut_outputs[60][0]), .out61_0(dut_outputs[61][0]), .out62_0(dut_outputs[62][0]), .out63_0(dut_outputs[63][0]),
        
        // Column 1 outputs //NOTE: Generated using AI Agent
        .out0_1(dut_outputs[0][1]),   .out1_1(dut_outputs[1][1]),   .out2_1(dut_outputs[2][1]),   .out3_1(dut_outputs[3][1]),
        .out4_1(dut_outputs[4][1]),   .out5_1(dut_outputs[5][1]),   .out6_1(dut_outputs[6][1]),   .out7_1(dut_outputs[7][1]),
        .out8_1(dut_outputs[8][1]),   .out9_1(dut_outputs[9][1]),   .out10_1(dut_outputs[10][1]), .out11_1(dut_outputs[11][1]),
        .out12_1(dut_outputs[12][1]), .out13_1(dut_outputs[13][1]), .out14_1(dut_outputs[14][1]), .out15_1(dut_outputs[15][1]),
        .out16_1(dut_outputs[16][1]), .out17_1(dut_outputs[17][1]), .out18_1(dut_outputs[18][1]), .out19_1(dut_outputs[19][1]),
        .out20_1(dut_outputs[20][1]), .out21_1(dut_outputs[21][1]), .out22_1(dut_outputs[22][1]), .out23_1(dut_outputs[23][1]),
        .out24_1(dut_outputs[24][1]), .out25_1(dut_outputs[25][1]), .out26_1(dut_outputs[26][1]), .out27_1(dut_outputs[27][1]),
        .out28_1(dut_outputs[28][1]), .out29_1(dut_outputs[29][1]), .out30_1(dut_outputs[30][1]), .out31_1(dut_outputs[31][1]),
        .out32_1(dut_outputs[32][1]), .out33_1(dut_outputs[33][1]), .out34_1(dut_outputs[34][1]), .out35_1(dut_outputs[35][1]),
        .out36_1(dut_outputs[36][1]), .out37_1(dut_outputs[37][1]), .out38_1(dut_outputs[38][1]), .out39_1(dut_outputs[39][1]),
        .out40_1(dut_outputs[40][1]), .out41_1(dut_outputs[41][1]), .out42_1(dut_outputs[42][1]), .out43_1(dut_outputs[43][1]),
        .out44_1(dut_outputs[44][1]), .out45_1(dut_outputs[45][1]), .out46_1(dut_outputs[46][1]), .out47_1(dut_outputs[47][1]),
        .out48_1(dut_outputs[48][1]), .out49_1(dut_outputs[49][1]), .out50_1(dut_outputs[50][1]), .out51_1(dut_outputs[51][1]),
        .out52_1(dut_outputs[52][1]), .out53_1(dut_outputs[53][1]), .out54_1(dut_outputs[54][1]), .out55_1(dut_outputs[55][1]),
        .out56_1(dut_outputs[56][1]), .out57_1(dut_outputs[57][1]), .out58_1(dut_outputs[58][1]), .out59_1(dut_outputs[59][1]),
        .out60_1(dut_outputs[60][1]), .out61_1(dut_outputs[61][1]), .out62_1(dut_outputs[62][1]), .out63_1(dut_outputs[63][1]),
        
        // Column 2 outputs //NOTE: Generated using AI Agent
        .out0_2(dut_outputs[0][2]),   .out1_2(dut_outputs[1][2]),   .out2_2(dut_outputs[2][2]),   .out3_2(dut_outputs[3][2]),
        .out4_2(dut_outputs[4][2]),   .out5_2(dut_outputs[5][2]),   .out6_2(dut_outputs[6][2]),   .out7_2(dut_outputs[7][2]),
        .out8_2(dut_outputs[8][2]),   .out9_2(dut_outputs[9][2]),   .out10_2(dut_outputs[10][2]), .out11_2(dut_outputs[11][2]),
        .out12_2(dut_outputs[12][2]), .out13_2(dut_outputs[13][2]), .out14_2(dut_outputs[14][2]), .out15_2(dut_outputs[15][2]),
        .out16_2(dut_outputs[16][2]), .out17_2(dut_outputs[17][2]), .out18_2(dut_outputs[18][2]), .out19_2(dut_outputs[19][2]),
        .out20_2(dut_outputs[20][2]), .out21_2(dut_outputs[21][2]), .out22_2(dut_outputs[22][2]), .out23_2(dut_outputs[23][2]),
        .out24_2(dut_outputs[24][2]), .out25_2(dut_outputs[25][2]), .out26_2(dut_outputs[26][2]), .out27_2(dut_outputs[27][2]),
        .out28_2(dut_outputs[28][2]), .out29_2(dut_outputs[29][2]), .out30_2(dut_outputs[30][2]), .out31_2(dut_outputs[31][2]),
        .out32_2(dut_outputs[32][2]), .out33_2(dut_outputs[33][2]), .out34_2(dut_outputs[34][2]), .out35_2(dut_outputs[35][2]),
        .out36_2(dut_outputs[36][2]), .out37_2(dut_outputs[37][2]), .out38_2(dut_outputs[38][2]), .out39_2(dut_outputs[39][2]),
        .out40_2(dut_outputs[40][2]), .out41_2(dut_outputs[41][2]), .out42_2(dut_outputs[42][2]), .out43_2(dut_outputs[43][2]),
        .out44_2(dut_outputs[44][2]), .out45_2(dut_outputs[45][2]), .out46_2(dut_outputs[46][2]), .out47_2(dut_outputs[47][2]),
        .out48_2(dut_outputs[48][2]), .out49_2(dut_outputs[49][2]), .out50_2(dut_outputs[50][2]), .out51_2(dut_outputs[51][2]),
        .out52_2(dut_outputs[52][2]), .out53_2(dut_outputs[53][2]), .out54_2(dut_outputs[54][2]), .out55_2(dut_outputs[55][2]),
        .out56_2(dut_outputs[56][2]), .out57_2(dut_outputs[57][2]), .out58_2(dut_outputs[58][2]), .out59_2(dut_outputs[59][2]),
        .out60_2(dut_outputs[60][2]), .out61_2(dut_outputs[61][2]), .out62_2(dut_outputs[62][2]), .out63_2(dut_outputs[63][2]),
        
        // Column 3 outputs//NOTE: Generated using AI Agent
        .out0_3(dut_outputs[0][3]),   .out1_3(dut_outputs[1][3]),   .out2_3(dut_outputs[2][3]),   .out3_3(dut_outputs[3][3]),
        .out4_3(dut_outputs[4][3]),   .out5_3(dut_outputs[5][3]),   .out6_3(dut_outputs[6][3]),   .out7_3(dut_outputs[7][3]),
        .out8_3(dut_outputs[8][3]),   .out9_3(dut_outputs[9][3]),   .out10_3(dut_outputs[10][3]), .out11_3(dut_outputs[11][3]),
        .out12_3(dut_outputs[12][3]), .out13_3(dut_outputs[13][3]), .out14_3(dut_outputs[14][3]), .out15_3(dut_outputs[15][3]),
        .out16_3(dut_outputs[16][3]), .out17_3(dut_outputs[17][3]), .out18_3(dut_outputs[18][3]), .out19_3(dut_outputs[19][3]),
        .out20_3(dut_outputs[20][3]), .out21_3(dut_outputs[21][3]), .out22_3(dut_outputs[22][3]), .out23_3(dut_outputs[23][3]),
        .out24_3(dut_outputs[24][3]), .out25_3(dut_outputs[25][3]), .out26_3(dut_outputs[26][3]), .out27_3(dut_outputs[27][3]),
        .out28_3(dut_outputs[28][3]), .out29_3(dut_outputs[29][3]), .out30_3(dut_outputs[30][3]), .out31_3(dut_outputs[31][3]),
        .out32_3(dut_outputs[32][3]), .out33_3(dut_outputs[33][3]), .out34_3(dut_outputs[34][3]), .out35_3(dut_outputs[35][3]),
        .out36_3(dut_outputs[36][3]), .out37_3(dut_outputs[37][3]), .out38_3(dut_outputs[38][3]), .out39_3(dut_outputs[39][3]),
        .out40_3(dut_outputs[40][3]), .out41_3(dut_outputs[41][3]), .out42_3(dut_outputs[42][3]), .out43_3(dut_outputs[43][3]),
        .out44_3(dut_outputs[44][3]), .out45_3(dut_outputs[45][3]), .out46_3(dut_outputs[46][3]), .out47_3(dut_outputs[47][3]),
        .out48_3(dut_outputs[48][3]), .out49_3(dut_outputs[49][3]), .out50_3(dut_outputs[50][3]), .out51_3(dut_outputs[51][3]),
        .out52_3(dut_outputs[52][3]), .out53_3(dut_outputs[53][3]), .out54_3(dut_outputs[54][3]), .out55_3(dut_outputs[55][3]),
        .out56_3(dut_outputs[56][3]), .out57_3(dut_outputs[57][3]), .out58_3(dut_outputs[58][3]), .out59_3(dut_outputs[59][3]),
        .out60_3(dut_outputs[60][3]), .out61_3(dut_outputs[61][3]), .out62_3(dut_outputs[62][3]), .out63_3(dut_outputs[63][3]),
        
        // Inputs
        .cfg_sel_outBits (cfg_sel_outBits), // global config bit to select output format (0: take bits 24:11, 1: take bits 23:10)
        .in       (dut_inputs), //JJ used delayed modulator outputs. Evaluate if this is needed. 
        .clk      (phi1F), //JJ used delayed phy1f clk. Evaluate if this is needed. 
        .reset_n  (reset_n)
    );
    
    // Golden Reference Model
    // Instantiate one golden reference filter
    cic3_echip65_14b_golden #(
        .DECIMATION_FACTOR(DECIMATION_FACTOR)
    ) golden_filter (
        .out      (golden_output),
        .in       (golden_modulator_out),
        .cfg_sel_outBits (cfg_sel_outBits), 
        .clk      (phi1F),
        .reset_n  (reset_n)
    );


    // ADI Golden Reference Model
    // Instantiate ADI golden reference filter
    cic3_adi_14b adi_golden_filter (
        .out      (adi_golden_output),
        .in       (golden_modulator_out),
        .clk      (phi1F),
        .reset_n  (reset_n)
    );
    // Scoreboard Instantiation
    cic3_64x4_scoreboard scoreboard (
        .clk             (divided_clk),  
        .reset_n         (reset_n),
        .enable          (scoreboard_enable),
        .dut_outputs     (dut_outputs),
        .golden_output   (golden_output),
        .stats           (stats),
        .test_complete   (test_complete)
    );
    
    // Test Sequence Control
    initial begin
        clk = 0;
        reset_n = 0;
        scoreboard_enable = 0;
        enable = 0;
        cfg_sel_outBits = 1; // Set output bits selection (0: take bits 24:11, 1: take bits 23:10)
        // Display test header
        display_test_header();
        delay_ns(10); 
        enable = 1;
        
        // Apply clock reset
        apply_reset_sequence(clk_reset_n, 100);
        // Apply reset
        @(negedge phi2);
        #2;
        apply_reset_sequence(reset_n, 100);
        
        // Wait for settling time
        wait_for_settling(SETTLING_TIME_CYCLES, CLK_PERIOD_NS);
        
        // Enable scoreboard checking
        $display("[INFO] @%0t: Enabling output checking...", $time);
        scoreboard_enable = 1;
        
        // Wait for test completion
        wait(test_complete);
        
        // Display results
        display_test_summary(stats);
        
        // export_results_to_file(stats, "test_results.txt");// TP: not working currently
        
        $finish;
    end
    
    // Timeout watchdog
    initial begin
        #(TEST_DURATION_SAMPLES * DECIMATION_FACTOR * CLK_PERIOD_NS * 9);
        $display("[WARNING] Test timeout reached");
        display_test_summary(stats);
        $finish;
    end
    
    // VCD
    initial begin
        // Uncomment to enable waveform dumping
        // dump_waveforms("cic3_64x4_selfcheck.vcd"); // TP: not implemented yet. 
    end

endmodule 
