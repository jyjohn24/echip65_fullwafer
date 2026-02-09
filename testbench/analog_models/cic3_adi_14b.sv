///////////////////////////////////////////////////////////////////
// File Name: cic3_adi_14b.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: ADI CIC3 14-bit decimation filter model converted to 14 bit and systemverilog
/*`Data is read on negative clk edge*/
// Updated to match cic3_echip65_14b interface
// original code available at: https://www.analog.com/media/en/technical-documentation/data-sheets/ad7401.pdf
///////////////////////////////////////////////////////////////////
module cic3_adi_14b(
    input logic in,        // single bit from sigma-delta modulator
    input logic clk,       // high-speed modulator clk
    input logic reset_n,   // asynchronous digital reset (active low)
    output logic [13:0] out // filtered output (14-bits)
);
// Internal signals
logic [23:0] ip_data1;
logic [23:0] acc1;
logic [23:0] acc2;
logic [23:0] acc3;
logic [23:0] acc3_d2;
logic [23:0] diff1;
logic [23:0] diff2;
logic [23:0] diff3;
logic [23:0] diff1_d;
logic [23:0] diff2_d;
logic [7:0] word_count;
logic word_clk;
/*Perform the Sinc ACTION*/
always_comb begin
    if(in == 0)
        ip_data1 = 0; /* change from a 0 to a -1 for 2's comp */
    else
        ip_data1 = 1;
end
/*ACCUMULATOR (INTEGRATOR)
Perform the accumulation (IIR) at the speed
of the modulator.

MCLKIN
IP_DATA1

ACC1+ ACC2+ ACC3+

+
Z

+
Z

+
Z

05851-024

Figure 26. Accumulator
Z = one sample delay
MCLKIN = modulators conversion bit rate
*/
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        /*initialize acc registers on reset*/
        acc1 <= 0;
        acc2 <= 0;
        acc3 <= 0;
    end
    else begin
        /*perform accumulation process*/
        acc1 <= acc1 + ip_data1;
        acc2 <= acc2 + acc1;
        acc3 <= acc3 + acc2;
    end
end
/*DECIMATION STAGE (MCLKIN/ WORD_CLK)
*/
always_ff @(negedge clk or negedge reset_n) begin
    if (!reset_n)
        word_count <= 0;
    else
        word_count <= word_count + 1;
end

always_comb begin
    word_clk = word_count[7];
end
/*DIFFERENTIATOR (including decimation stage)
Perform the differentiation stage (FIR) at a
lower speed.

WORD_CLK
ACC3

DIFF1 + DIFF3
–

+
–
DIFF2

Z–1

+
–
Z–1 Z–1
05851-025

Figure 27. Differentiator
Z = one sample delay
WORD_CLK = output word rate
*/

always_ff @(posedge word_clk or negedge reset_n) begin
    if(!reset_n) begin
        acc3_d2 <= 0;
        diff1_d <= 0;
        diff2_d <= 0;
        diff1 <= 0;
        diff2 <= 0;
        diff3 <= 0;
    end
    else begin
        diff1 <= acc3 - acc3_d2;
        diff2 <= diff1 - diff1_d;
        diff3 <= diff2 - diff2_d;
        acc3_d2 <= acc3;
        diff1_d <= diff1;
        diff2_d <= diff2;
    end
end
/* Clock the Sinc output into an output
register
WORD_CLK

DIFF3 DATA
05851-026
Figure 28. Clocking Sinc Output into an Output Register
WORD_CLK = output word rate
*/
always_ff @(posedge word_clk) begin
    // 14-bit output matching cic3_echip65_14b (bits [23:10] from diff3)
    out <= diff3[23:10];
end
endmodule