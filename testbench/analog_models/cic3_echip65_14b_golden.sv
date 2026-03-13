///////////////////////////////////////////////////////////////////
// File Name: cic3_echip65_14b_golden.sv
// Engineer:  Carl Grace (crgrace@lbl.gov)
// Description: cascaded integrator comb filter (CIC)
//          Processes filter sigma-delta modulator output
//          Need the following number of internal bits:
//          W = Nlog2(D)+1
//          N = filter order (3 here)
//          D = decimation factor (256 here)
//          so W = 3*(8)+1 = 25. 
//          divide ratio is 256 (need 25 bits minimum internally)
//          based on sample code provided by ADI in AD7401 datasheet
//
//   DOES NOT INCLUDE MONTIOR MUX
//   IS NOT PARAMETERIZED
//   JJ (03/06/25): added in parametrization
//   JJ (01/12/26): only bringing out 14 bits of the 25-bit output
//   TP (02/24/26): converted all internal datapath signals (acc*, diff*, in_coded) to
//                 'signed' with explicit signed'() casts on arithmetic ops.
//                 Added out_signed intermediate signal.
//   JJ (02/25/26): Adding in two configuration bits (for selecting output word format
//                 and for selecting which 14-bits to take out)
//   TP (03/03/26): Changed input encoding from 2s complement back to offset binary (undid the change from 02/24/26)
//                  and removed config bit for selecting output word format
///////////////////////////////////////////////////////////////////

module cic3_echip65_14b_golden
    #(parameter DECIMATION_FACTOR = 256, // default D = 256
    parameter CLOCK_WIDTH = $clog2(DECIMATION_FACTOR),
    parameter NUMBITS = 3*CLOCK_WIDTH+1)
    (output logic [14-1:0] out, // filtered output (14-bits)
    input logic in, // single bit from sigma-delta modulator
    input logic cfg_sel_outBits, // config bit to select output format (0: take bits 24:11, 1: take bits 23:10)
    input logic clk, // high-speed modulator clk
    input logic reset_n); // asynchronous digital reset (active low)

logic [NUMBITS-1:0] in_coded; // input coded to 25-bit offset binary
logic [NUMBITS-1:0] acc1;
logic [NUMBITS-1:0] acc2;
logic [NUMBITS-1:0] acc3;
logic [NUMBITS-1:0] acc3_d;
logic [NUMBITS-1:0] diff1;
logic [NUMBITS-1:0] diff2;
logic [NUMBITS-1:0] diff3;
logic [NUMBITS-1:0] diff1_d;
logic [NUMBITS-1:0] diff2_d;
logic [14-1:0] out_unsigned; // 14-bit offset binary output from CIC filter
logic [CLOCK_WIDTH-1:0] clock_counter; // 256 decimation ratio
logic divided_clk;

/*
JJ (03/13/25): updated clking setup of filter because previous implementation led to difficulties meeting hold time target slack
Original:
integrators update on posedge of clk
clock_counter updates on posedge of clk
    -so MSB transitions both going HIGH and LOW are on posedge of clk
differentiators update on negedge of divided_clk (which aligns with posedge of clk)
End result: update of integrators, downsampling and update of differentiators all effectively happen on same posedge of clk 

Updated:
integrators update on posedge of clk
clock_counter updates on NEGEDGE of clk
    -so MSB transitions both going HIGH and LOW are on NEGEDGE of clk
differentiators update on posedge of divided_clk (which aligns with negedge of clk)
End result: update of integrators and the downsampling + update of differentiators are seperated by 1/2 fast input filter clk period
*/

// Offset binary encoder: sigma-delta bit 1 -> +1, bit 0 -> 0
always_comb begin : coder
    if (in)
        in_coded = {{(NUMBITS-1){1'b0}}, 1'b1};   // 1 unsigned (00000.....0001)
    else
        in_coded = {(NUMBITS){1'b0}};            // 0, (00000.....0000)
end // always_comb

// clock assignment
always_comb begin : clock_assign
    divided_clk = clock_counter[CLOCK_WIDTH-1];
end // always_comb

// integrators
always_ff @ (posedge clk or negedge reset_n) begin 
    if (!reset_n) begin 
        acc1 <= 'b0; 
        acc2 <= 'b0; 
        acc3 <= 'b0; 
    end 
    else begin
        acc1 <= acc1 + in_coded; 
        acc2 <= acc2 + acc1; 
        acc3 <= acc3 + acc2;  
    end
end // always_ff

// differentiators
// always_ff @ (negedge divided_clk or negedge reset_n) begin 
always_ff @ (posedge divided_clk or negedge reset_n) begin 
    if(!reset_n) begin
        acc3_d <= 'b0; 
        diff1_d <= 'b0; 
        diff2_d <= 'b0; 
        diff1 <= 'b0; 
        diff2 <= 'b0; 
        diff3 <= 'b0;
    end 
    else begin 
        diff1 <= acc3 - acc3_d; 
        diff2 <= diff1 - diff1_d; 
        diff3 <= diff2 - diff2_d; 
        acc3_d <=  acc3; 
        diff1_d <= diff1; 
        diff2_d <= diff2; 
    end
end // always_ff

/* Clock the CIC3 output into the output register */
// JJ: to optimize power savings, for "simple" base filter version, moved output clocking to use divided_clk
// JJ: so, wrt to clk, output is registered on negedge of clk
//always_ff @ (posedge divided_clk or negedge reset_n) begin
always_ff @ (negedge divided_clk or negedge reset_n) begin
    if (!reset_n) begin  
        out_unsigned <= 'b0;
    end
    else begin
        //explicit 14-bit assignment from 25-bit diff3 w/ config. bit to select which 14 bits to take out
        /*out[13] <= diff3[23];
        out[12] <= diff3[22];
        out[11] <= diff3[21];
        out[10] <= diff3[20];
        out[9] <= diff3[19];
        out[8] <= diff3[18];
        out[7] <= diff3[17];
        out[6] <= diff3[16];
        out[5] <= diff3[15];
        out[4] <= diff3[14];
        out[3] <= diff3[13];
        out[2] <= diff3[12];
        out[1] <= diff3[11];
        out[0] <= diff3[10];*/
        if (cfg_sel_outBits)
            out_unsigned <= diff3[23:10];
        else
            out_unsigned <= diff3[24:11];
    end
end // always_ff

// Data is in offset binary
//    0     (14'h0000) ->  0       (min scale)
//    8192  (14'h2000) ->  8192    (mid scale)
//   16383  (14'h3FFF) ->  16383   (full scale)

assign out = out_unsigned;

// timing and output logic
// always_ff @ (posedge clk or negedge reset_n) begin
always_ff @ (negedge clk or negedge reset_n) begin
    if (!reset_n) begin
        clock_counter <= 'b0; 
        // out <= 'b0;
    end
    else begin 
        clock_counter <= clock_counter + 1'b1;
        // out <= diff3;
    end
end // always_ff

endmodule

