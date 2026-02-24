///////////////////////////////////////////////////////////////////
// File Name: cic3_64x4_stimulus_gen.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Stimulus generator for 64x4 CIC3 testbench
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

import cic3_64x4_test_pkg::*;

module cic3_64x4_stimulus_gen #(
    parameter string SDM_MODEL = "sd_mod2",  // Options: "sd_mod2", "sdm_rnm", or "bitstream_file"
    parameter string BITSTREAM_FILE = "../testbench/analog_data/sd_bitstream.txt"  // File path for bitstream_file mode
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
        else if (SDM_MODEL == "bitstream_file") begin : SDM_MODEL_SELECT
            // File-based bitstream input
            // Read bitstream from file and send to all modulator outputs
            logic file_bit;
            int file_handle;
            int scan_result;
            int bit_value;
            int line_count;
            
            initial begin
                file_handle = $fopen(BITSTREAM_FILE, "r");
                if (file_handle == 0) begin
                    $error("Failed to open bitstream file: %s", BITSTREAM_FILE);
                    $finish;
                end
                else begin
                    $display("Opened bitstream file: %s", BITSTREAM_FILE);
                end
                line_count = 0;
            end
            
            always @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    file_bit <= 1'b0;
                    line_count <= 0;
                end
                else begin
                    if (!$feof(file_handle)) begin
                        scan_result = $fscanf(file_handle, "%d\n", bit_value);
                        if (scan_result == 1) begin
                            file_bit <= bit_value[0];
                            line_count <= line_count + 1;
                        end
                        else begin
                            $warning("Failed to read bit from file at line %0d", line_count + 1);
                            file_bit <= 1'b0;
                        end
                    end
                    else begin
                        $display("Reached end of bitstream file after %0d lines", line_count);
                        $fclose(file_handle);
                        $display("Simulation complete - stopping due to end of bitstream file");
                        $finish;
                    end
                end
            end
            
            // Broadcast file bit to all modulator outputs
            assign modulator_outputs = {NUM_FILTERS{file_bit}};
        end
        else begin : SDM_MODEL_SELECT
            initial begin
                $error("Invalid SDM_MODEL parameter: %s. Valid options are 'sd_mod2', 'sdm_rnm', or 'bitstream_file'", SDM_MODEL);
            end
        end
    endgenerate
    
    // Golden Reference Input
    // Use output from first modulator as golden input (Row 0, Col 0)
    assign golden_modulator_out = modulator_outputs[0];

endmodule
