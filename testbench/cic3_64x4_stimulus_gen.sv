///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_stimulus_gen.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Stimulus generator for 64x4 CIC3 testbench
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

import cic3_64x4_test_pkg::*;

module cic3_64x4_stimulus_gen #(
    parameter string SDM_MODEL = "sd_mod2"  // Options: "sd_mod2" or "sdm_rnm"
)(
    input  logic                      clk,
    input  logic                      reset_n,
    output logic [NUM_FILTERS-1:0]    modulator_outputs,
    output logic                      golden_modulator_out,
    output real                       sine_input
);

    // Sine Wave Generator
    sine_wave sine_wave_inst (
        .sine_out(sine_input)
    );
    
    // Sigma-Delta Modulator Array
    // Generate NUM_FILTERS sigma-delta modulators
    // SDM model selected by SDM_MODEL parameter
    genvar m;
    generate
        if (SDM_MODEL == "sd_mod2") begin : SDM_MODEL_SELECT
            for (m = 0; m < NUM_FILTERS; m++) begin : SDM_ARRAY
                sdm_rnm_sd_mod2_wrapper sdm_inst (
                    .dout      (modulator_outputs[m]),
                    .analog_in (sine_input),  // All modulators share same input
                    .clk       (clk),
                    .reset_n   (reset_n)
                );
            end
        end
        else if (SDM_MODEL == "sdm_rnm") begin : SDM_MODEL_SELECT
            for (m = 0; m < NUM_FILTERS; m++) begin : SDM_ARRAY
                sdm_rnm sdm_inst (
                    .dout      (modulator_outputs[m]),
                    .analog_in (sine_input),  // All modulators share same input
                    .clk       (clk),
                    .reset_n   (reset_n)
                );
            end
        end
        else begin : SDM_MODEL_SELECT
            initial begin
                $error("Invalid SDM_MODEL parameter: %s. Valid options are 'sd_mod2' or 'sdm_rnm'", SDM_MODEL);
            end
        end
    endgenerate
    
    // Golden Reference Input
    // Use output from first modulator as golden input (Row 0, Col 0)
    assign golden_modulator_out = modulator_outputs[0];

endmodule 
