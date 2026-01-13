///////////////////////////////////////////////////////////////////
// File Name: cic3_echip65_14b_64Rowsx4Cols_v1.sv
// Engineer:  Jyothisraj Johnson (jyothisrajjohnson@lbl.gov)
// Description: 64x1 array of digital filters 
//              (simple, no integrated digital monitor always_comb block or cfg. bits)
//              clk is common input and divided_clk generated internally
///////////////////////////////////////////////////////////////////

/*
JJ (03/06/25): keeping same module name for the moment for iterating through implementation power checks
               this assumes cic3_echip65_simple.sv as root src code
JJ (03/13/25): creating 24 sets of 25-bit filter outputs to make association of outputs w/ filter instances explicit
JJ (01/12/26): updating to use cic3_echip65_14b.sv as root src code (14-bit output version) and an array of 64x4 filters
*/

module cic3_echip65_14b_64Rowsx4Cols
#(
parameter NUM_FILTERS_PERCOLUMN = 64,
parameter NUM_COLUMNS = 4
)
(//outputs are all directly sent to current starved buffers right below bottom power rings at design boundry edge
output logic [(14-1):0] out0_0, 
output logic [(14-1):0] out0_1,
output logic [(14-1):0] out0_2, 
output logic [(14-1):0] out0_3,
output logic [(14-1):0] out1_0, 
output logic [(14-1):0] out1_1,
output logic [(14-1):0] out1_2, 
output logic [(14-1):0] out1_3,
output logic [(14-1):0] out2_0, 
output logic [(14-1):0] out2_1,
output logic [(14-1):0] out2_2, 
output logic [(14-1):0] out2_3,
output logic [(14-1):0] out3_0, 
output logic [(14-1):0] out3_1,
output logic [(14-1):0] out3_2, 
output logic [(14-1):0] out3_3,
output logic [(14-1):0] out4_0, 
output logic [(14-1):0] out4_1,
output logic [(14-1):0] out4_2, 
output logic [(14-1):0] out4_3,
output logic [(14-1):0] out5_0, 
output logic [(14-1):0] out5_1,
output logic [(14-1):0] out5_2, 
output logic [(14-1):0] out5_3,
output logic [(14-1):0] out6_0, 
output logic [(14-1):0] out6_1,
output logic [(14-1):0] out6_2, 
output logic [(14-1):0] out6_3,
output logic [(14-1):0] out7_0, 
output logic [(14-1):0] out7_1,
output logic [(14-1):0] out7_2, 
output logic [(14-1):0] out7_3,
output logic [(14-1):0] out8_0, 
output logic [(14-1):0] out8_1,
output logic [(14-1):0] out8_2, 
output logic [(14-1):0] out8_3,
output logic [(14-1):0] out9_0, 
output logic [(14-1):0] out9_1,
output logic [(14-1):0] out9_2, 
output logic [(14-1):0] out9_3,
output logic [(14-1):0] out10_0, 
output logic [(14-1):0] out10_1,
output logic [(14-1):0] out10_2, 
output logic [(14-1):0] out10_3,
output logic [(14-1):0] out11_0, 
output logic [(14-1):0] out11_1,
output logic [(14-1):0] out11_2, 
output logic [(14-1):0] out11_3,
output logic [(14-1):0] out12_0, 
output logic [(14-1):0] out12_1,
output logic [(14-1):0] out12_2, 
output logic [(14-1):0] out12_3,
output logic [(14-1):0] out13_0, 
output logic [(14-1):0] out13_1,
output logic [(14-1):0] out13_2, 
output logic [(14-1):0] out13_3,
output logic [(14-1):0] out14_0, 
output logic [(14-1):0] out14_1,
output logic [(14-1):0] out14_2, 
output logic [(14-1):0] out14_3,
output logic [(14-1):0] out15_0, 
output logic [(14-1):0] out15_1,
output logic [(14-1):0] out15_2, 
output logic [(14-1):0] out15_3,
output logic [(14-1):0] out16_0, 
output logic [(14-1):0] out16_1,
output logic [(14-1):0] out16_2, 
output logic [(14-1):0] out16_3,
output logic [(14-1):0] out17_0, 
output logic [(14-1):0] out17_1,
output logic [(14-1):0] out17_2, 
output logic [(14-1):0] out17_3,
output logic [(14-1):0] out18_0, 
output logic [(14-1):0] out18_1,
output logic [(14-1):0] out18_2, 
output logic [(14-1):0] out18_3,
output logic [(14-1):0] out19_0, 
output logic [(14-1):0] out19_1,
output logic [(14-1):0] out19_2, 
output logic [(14-1):0] out19_3,
output logic [(14-1):0] out20_0, 
output logic [(14-1):0] out20_1,
output logic [(14-1):0] out20_2, 
output logic [(14-1):0] out20_3,
output logic [(14-1):0] out21_0, 
output logic [(14-1):0] out21_1,
output logic [(14-1):0] out21_2, 
output logic [(14-1):0] out21_3,
output logic [(14-1):0] out22_0, 
output logic [(14-1):0] out22_1,
output logic [(14-1):0] out22_2, 
output logic [(14-1):0] out22_3,
output logic [(14-1):0] out23_0, 
output logic [(14-1):0] out23_1,
output logic [(14-1):0] out23_2, 
output logic [(14-1):0] out23_3,
output logic [(14-1):0] out24_0, 
output logic [(14-1):0] out24_1,
output logic [(14-1):0] out24_2, 
output logic [(14-1):0] out24_3,
output logic [(14-1):0] out25_0, 
output logic [(14-1):0] out25_1,
output logic [(14-1):0] out25_2, 
output logic [(14-1):0] out25_3,
output logic [(14-1):0] out26_0, 
output logic [(14-1):0] out26_1,
output logic [(14-1):0] out26_2, 
output logic [(14-1):0] out26_3,
output logic [(14-1):0] out27_0, 
output logic [(14-1):0] out27_1,
output logic [(14-1):0] out27_2, 
output logic [(14-1):0] out27_3,
output logic [(14-1):0] out28_0, 
output logic [(14-1):0] out28_1,
output logic [(14-1):0] out28_2, 
output logic [(14-1):0] out28_3,
output logic [(14-1):0] out29_0, 
output logic [(14-1):0] out29_1,
output logic [(14-1):0] out29_2, 
output logic [(14-1):0] out29_3,
output logic [(14-1):0] out30_0, 
output logic [(14-1):0] out30_1,
output logic [(14-1):0] out30_2, 
output logic [(14-1):0] out30_3,
output logic [(14-1):0] out31_0, 
output logic [(14-1):0] out31_1,
output logic [(14-1):0] out31_2, 
output logic [(14-1):0] out31_3,
output logic [(14-1):0] out32_0, 
output logic [(14-1):0] out32_1,
output logic [(14-1):0] out32_2, 
output logic [(14-1):0] out32_3,
output logic [(14-1):0] out33_0, 
output logic [(14-1):0] out33_1,
output logic [(14-1):0] out33_2, 
output logic [(14-1):0] out33_3,
output logic [(14-1):0] out34_0, 
output logic [(14-1):0] out34_1,
output logic [(14-1):0] out34_2, 
output logic [(14-1):0] out34_3,
output logic [(14-1):0] out35_0, 
output logic [(14-1):0] out35_1,
output logic [(14-1):0] out35_2, 
output logic [(14-1):0] out35_3,
output logic [(14-1):0] out36_0, 
output logic [(14-1):0] out36_1,
output logic [(14-1):0] out36_2, 
output logic [(14-1):0] out36_3,
output logic [(14-1):0] out37_0, 
output logic [(14-1):0] out37_1,
output logic [(14-1):0] out37_2, 
output logic [(14-1):0] out37_3,
output logic [(14-1):0] out38_0, 
output logic [(14-1):0] out38_1,
output logic [(14-1):0] out38_2, 
output logic [(14-1):0] out38_3,
output logic [(14-1):0] out39_0, 
output logic [(14-1):0] out39_1,
output logic [(14-1):0] out39_2, 
output logic [(14-1):0] out39_3,
output logic [(14-1):0] out40_0, 
output logic [(14-1):0] out40_1,
output logic [(14-1):0] out40_2, 
output logic [(14-1):0] out40_3,
output logic [(14-1):0] out41_0, 
output logic [(14-1):0] out41_1,
output logic [(14-1):0] out41_2, 
output logic [(14-1):0] out41_3,
output logic [(14-1):0] out42_0, 
output logic [(14-1):0] out42_1,
output logic [(14-1):0] out42_2, 
output logic [(14-1):0] out42_3,
output logic [(14-1):0] out43_0, 
output logic [(14-1):0] out43_1,
output logic [(14-1):0] out43_2, 
output logic [(14-1):0] out43_3,
output logic [(14-1):0] out44_0, 
output logic [(14-1):0] out44_1,
output logic [(14-1):0] out44_2, 
output logic [(14-1):0] out44_3,
output logic [(14-1):0] out45_0, 
output logic [(14-1):0] out45_1,
output logic [(14-1):0] out45_2, 
output logic [(14-1):0] out45_3,
output logic [(14-1):0] out46_0, 
output logic [(14-1):0] out46_1,
output logic [(14-1):0] out46_2, 
output logic [(14-1):0] out46_3,
output logic [(14-1):0] out47_0, 
output logic [(14-1):0] out47_1,
output logic [(14-1):0] out47_2, 
output logic [(14-1):0] out47_3,
output logic [(14-1):0] out48_0, 
output logic [(14-1):0] out48_1,
output logic [(14-1):0] out48_2, 
output logic [(14-1):0] out48_3,
output logic [(14-1):0] out49_0, 
output logic [(14-1):0] out49_1,
output logic [(14-1):0] out49_2, 
output logic [(14-1):0] out49_3,
output logic [(14-1):0] out50_0, 
output logic [(14-1):0] out50_1,
output logic [(14-1):0] out50_2, 
output logic [(14-1):0] out50_3,
output logic [(14-1):0] out51_0, 
output logic [(14-1):0] out51_1,
output logic [(14-1):0] out51_2, 
output logic [(14-1):0] out51_3,
output logic [(14-1):0] out52_0, 
output logic [(14-1):0] out52_1,
output logic [(14-1):0] out52_2, 
output logic [(14-1):0] out52_3,
output logic [(14-1):0] out53_0, 
output logic [(14-1):0] out53_1,
output logic [(14-1):0] out53_2, 
output logic [(14-1):0] out53_3,
output logic [(14-1):0] out54_0, 
output logic [(14-1):0] out54_1,
output logic [(14-1):0] out54_2, 
output logic [(14-1):0] out54_3,
output logic [(14-1):0] out55_0, 
output logic [(14-1):0] out55_1,
output logic [(14-1):0] out55_2, 
output logic [(14-1):0] out55_3,
output logic [(14-1):0] out56_0, 
output logic [(14-1):0] out56_1,
output logic [(14-1):0] out56_2, 
output logic [(14-1):0] out56_3,
output logic [(14-1):0] out57_0, 
output logic [(14-1):0] out57_1,
output logic [(14-1):0] out57_2, 
output logic [(14-1):0] out57_3,
output logic [(14-1):0] out58_0, 
output logic [(14-1):0] out58_1,
output logic [(14-1):0] out58_2, 
output logic [(14-1):0] out58_3,
output logic [(14-1):0] out59_0, 
output logic [(14-1):0] out59_1,
output logic [(14-1):0] out59_2, 
output logic [(14-1):0] out59_3,
output logic [(14-1):0] out60_0, 
output logic [(14-1):0] out60_1,
output logic [(14-1):0] out60_2, 
output logic [(14-1):0] out60_3,
output logic [(14-1):0] out61_0, 
output logic [(14-1):0] out61_1,
output logic [(14-1):0] out61_2, 
output logic [(14-1):0] out61_3,
output logic [(14-1):0] out62_0, 
output logic [(14-1):0] out62_1,
output logic [(14-1):0] out62_2, 
output logic [(14-1):0] out62_3,
output logic [(14-1):0] out63_0, 
output logic [(14-1):0] out63_1,
output logic [(14-1):0] out63_2, 
output logic [(14-1):0] out63_3,
input logic [(NUM_FILTERS_PERCOLUMN*NUM_COLUMNS-1):0] in, //will be seperate modulator inputs (clocked on modulator clk)
input logic clk, //common "high speed" filter clk (same frequency, adjustable phase as modulator clk)
input logic reset_n // common async. reset active low
);

/*
The filter column is formed by 64 rows of 1 filter and generate blocks are set-up accordingly.
All 64 filters will have seperate modulator input pins.
They will also share a common clk input (high speed filter clk) and reset active low (async) input.
divided_clk is generated internally to each filter.
Will have only svt flavour synthesized.
*/

logic [(NUM_FILTERS_PERCOLUMN*14-1):0] out_int_C1; //output bits from filters in column 1
logic [(NUM_FILTERS_PERCOLUMN*14-1):0] out_int_C2; //output bits from filters in column 2
logic [(NUM_FILTERS_PERCOLUMN*14-1):0] out_int_C3; //output bits from filters in column 3
logic [(NUM_FILTERS_PERCOLUMN*14-1):0] out_int_C4; //output bits from filters in column 4

logic [(NUM_FILTERS_PERCOLUMN-1):0] inC0; //input bits from modulators to filters in column 0
logic [(NUM_FILTERS_PERCOLUMN-1):0] inC1; //input bits from modulators to filters in column 1
logic [(NUM_FILTERS_PERCOLUMN-1):0] inC2; //input bits from modulators to filters in column 2
logic [(NUM_FILTERS_PERCOLUMN-1):0] inC3; //input bits from modulators to filters in column 3

/*
in is a large 1D array of bits from modulators feeding into each filter instance.
For 4 columns, in[0] would be top filter input (of column 1), in[1] would be top filter input (of column 1), in[4] would be second row filter (column 1), etc.
*/
genvar k;
generate
    for (k=0; k<NUM_FILTERS_PERCOLUMN; k=k+1) begin : FILTER_INPUTS
        assign inC0[k] = in[k*4+0];
        assign inC1[k] = in[k*4+1];
        assign inC2[k] = in[k*4+2];
        assign inC3[k] = in[k*4+3];
    end
endgenerate

/*
To make it easier for grouping of output bits to each filter instance, we have to get explicit.
Digital filter numbering starts w/ instance 0 at top left edge and 63 at bottom left edge.
For each, [MSB:LSB] pin ordering --> out0[0] is top-most bit and out23[13] is bottom-most bit on left edge
*/
assign out0_0 = out_int_C1[(14*1 -1):14*0];
assign out1_0 = out_int_C1[(14*2 -1):14*1];
assign out2_0 = out_int_C1[(14*3 -1):14*2];
assign out3_0 = out_int_C1[(14*4 -1):14*3];
assign out4_0 = out_int_C1[(14*5 -1):14*4];
assign out5_0 = out_int_C1[(14*6 -1):14*5];
assign out6_0 = out_int_C1[(14*7 -1):14*6];
assign out7_0 = out_int_C1[(14*8 -1):14*7];
assign out8_0 = out_int_C1[(14*9 -1):14*8];
assign out9_0 = out_int_C1[(14*10 -1):14*9];
assign out10_0 = out_int_C1[(14*11 -1):14*10];
assign out11_0 = out_int_C1[(14*12 -1):14*11];
assign out12_0 = out_int_C1[(14*13 -1):14*12];
assign out13_0 = out_int_C1[(14*14 -1):14*13];
assign out14_0 = out_int_C1[(14*15 -1):14*14];
assign out15_0 = out_int_C1[(14*16 -1):14*15];
assign out16_0 = out_int_C1[(14*17 -1):14*16];
assign out17_0 = out_int_C1[(14*18 -1):14*17];
assign out18_0 = out_int_C1[(14*19 -1):14*18];
assign out19_0 = out_int_C1[(14*20 -1):14*19];
assign out20_0 = out_int_C1[(14*21 -1):14*20];
assign out21_0 = out_int_C1[(14*22 -1):14*21];
assign out22_0 = out_int_C1[(14*23 -1):14*22];
assign out23_0 = out_int_C1[(14*24 -1):14*23];
assign out24_0 = out_int_C1[(14*25 -1):14*24];
assign out25_0 = out_int_C1[(14*26 -1):14*25];
assign out26_0 = out_int_C1[(14*27 -1):14*26];
assign out27_0 = out_int_C1[(14*28 -1):14*27];
assign out28_0 = out_int_C1[(14*29 -1):14*28];
assign out29_0 = out_int_C1[(14*30 -1):14*29];
assign out30_0 = out_int_C1[(14*31 -1):14*30];
assign out31_0 = out_int_C1[(14*32 -1):14*31];
assign out32_0 = out_int_C1[(14*33 -1):14*32];
assign out33_0 = out_int_C1[(14*34 -1):14*33];
assign out34_0 = out_int_C1[(14*35 -1):14*34];
assign out35_0 = out_int_C1[(14*36 -1):14*35];
assign out36_0 = out_int_C1[(14*37 -1):14*36];
assign out37_0 = out_int_C1[(14*38 -1):14*37];
assign out38_0 = out_int_C1[(14*39 -1):14*38];
assign out39_0 = out_int_C1[(14*40 -1):14*39];
assign out40_0 = out_int_C1[(14*41 -1):14*40];
assign out41_0 = out_int_C1[(14*42 -1):14*41];
assign out42_0 = out_int_C1[(14*43 -1):14*42];
assign out43_0 = out_int_C1[(14*44 -1):14*43];
assign out44_0 = out_int_C1[(14*45- 1):14*44];
assign out45_0 = out_int_C1[(14*46- 1):14*45];
assign out46_0 = out_int_C1[(14*47- 1):14*46];
assign out47_0 = out_int_C1[(14*48- 1):14*47];
assign out48_0 = out_int_C1[(14*49- 1):14*48];
assign out49_0 = out_int_C1[(14*50- 1):14*49];
assign out50_0 = out_int_C1[(14*51- 1):14*50];
assign out51_0 = out_int_C1[(14*52- 1):14*51];
assign out52_0 = out_int_C1[(14*53- 1):14*52];
assign out53_0 = out_int_C1[(14*54- 1):14*53];
assign out54_0 = out_int_C1[(14*55- 1):14*54];
assign out55_0 = out_int_C1[(14*56- 1):14*55];
assign out56_0 = out_int_C1[(14*57- 1):14*56];
assign out57_0 = out_int_C1[(14*58- 1):14*57];
assign out58_0 = out_int_C1[(14*59- 1):14*58];
assign out59_0 = out_int_C1[(14*60- 1):14*59];
assign out60_0 = out_int_C1[(14*61- 1):14*60];
assign out61_0 = out_int_C1[(14*62- 1):14*61];
assign out62_0 = out_int_C1[(14*63- 1):14*62];
assign out63_0 = out_int_C1[(14*64- 1):14*63];

assign out0_1 = out_int_C2[(14*1 -1):14*0];
assign out1_1 = out_int_C2[(14*2 -1):14*1];
assign out2_1 = out_int_C2[(14*3 -1):14*2];
assign out3_1 = out_int_C2[(14*4 -1):14*3];
assign out4_1 = out_int_C2[(14*5 -1):14*4];
assign out5_1 = out_int_C2[(14*6 -1):14*5];
assign out6_1 = out_int_C2[(14*7 -1):14*6];
assign out7_1 = out_int_C2[(14*8 -1):14*7];
assign out8_1 = out_int_C2[(14*9 -1):14*8];
assign out9_1 = out_int_C2[(14*10 -1):14*9];
assign out10_1 = out_int_C2[(14*11 -1):14*10];
assign out11_1 = out_int_C2[(14*12 -1):14*11];
assign out12_1 = out_int_C2[(14*13 -1):14*12];
assign out13_1 = out_int_C2[(14*14 -1):14*13];
assign out14_1 = out_int_C2[(14*15 -1):14*14];
assign out15_1 = out_int_C2[(14*16 -1):14*15];
assign out16_1 = out_int_C2[(14*17 -1):14*16];
assign out17_1 = out_int_C2[(14*18 -1):14*17];
assign out18_1 = out_int_C2[(14*19 -1):14*18];
assign out19_1 = out_int_C2[(14*20 -1):14*19];
assign out20_1 = out_int_C2[(14*21 -1):14*20];
assign out21_1 = out_int_C2[(14*22 -1):14*21];
assign out22_1 = out_int_C2[(14*23 -1):14*22];
assign out23_1 = out_int_C2[(14*24 -1):14*23];
assign out24_1 = out_int_C2[(14*25 -1):14*24];
assign out25_1 = out_int_C2[(14*26 -1):14*25];
assign out26_1 = out_int_C2[(14*27 -1):14*26];
assign out27_1 = out_int_C2[(14*28 -1):14*27];
assign out28_1 = out_int_C2[(14*29 -1):14*28];
assign out29_1 = out_int_C2[(14*30 -1):14*29];
assign out30_1 = out_int_C2[(14*31 -1):14*30];
assign out31_1 = out_int_C2[(14*32 -1):14*31];
assign out32_1 = out_int_C2[(14*33 -1):14*32];
assign out33_1 = out_int_C2[(14*34 -1):14*33];
assign out34_1 = out_int_C2[(14*35 -1):14*34];
assign out35_1 = out_int_C2[(14*36 -1):14*35];
assign out36_1 = out_int_C2[(14*37 -1):14*36];
assign out37_1 = out_int_C2[(14*38 -1):14*37];
assign out38_1 = out_int_C2[(14*39 -1):14*38];
assign out39_1 = out_int_C2[(14*40 -1):14*39];
assign out40_1 = out_int_C2[(14*41 -1):14*40];
assign out41_1 = out_int_C2[(14*42 -1):14*41];
assign out42_1 = out_int_C2[(14*43 -1):14*42];
assign out43_1 = out_int_C2[(14*44 -1):14*43];
assign out44_1 = out_int_C2[(14*45 -1):14*44];
assign out45_1 = out_int_C2[(14*46 -1):14*45];
assign out46_1 = out_int_C2[(14*47 -1):14*46];
assign out47_1 = out_int_C2[(14*48 -1):14*47];
assign out48_1 = out_int_C2[(14*49 -1):14*48];
assign out49_1 = out_int_C2[(14*50 -1):14*49];
assign out50_1 = out_int_C2[(14*51 -1):14*50];
assign out51_1 = out_int_C2[(14*52 -1):14*51];
assign out52_1 = out_int_C2[(14*53 -1):14*52];
assign out53_1 = out_int_C2[(14*54 -1):14*53];
assign out54_1 = out_int_C2[(14*55 -1):14*54];
assign out55_1 = out_int_C2[(14*56 -1):14*55];
assign out56_1 = out_int_C2[(14*57 -1):14*56];
assign out57_1 = out_int_C2[(14*58 -1):14*57];
assign out58_1 = out_int_C2[(14*59 -1):14*58];
assign out59_1 = out_int_C2[(14*60 -1):14*59];
assign out60_1 = out_int_C2[(14*61 -1):14*60];
assign out61_1 = out_int_C2[(14*62 -1):14*61];
assign out62_1 = out_int_C2[(14*63 -1):14*62];
assign out63_1 = out_int_C2[(14*64 -1):14*63];

assign out0_2 = out_int_C3[(14*1 -1):14*0];
assign out1_2 = out_int_C3[(14*2 -1):14*1];
assign out2_2 = out_int_C3[(14*3 -1):14*2];
assign out3_2 = out_int_C3[(14*4 -1):14*3];
assign out4_2 = out_int_C3[(14*5 -1):14*4];
assign out5_2 = out_int_C3[(14*6 -1):14*5];
assign out6_2 = out_int_C3[(14*7 -1):14*6];
assign out7_2 = out_int_C3[(14*8 -1):14*7];
assign out8_2 = out_int_C3[(14*9 -1):14*8];
assign out9_2 = out_int_C3[(14*10 -1):14*9];
assign out10_2 = out_int_C3[(14*11 -1):14*10];
assign out11_2 = out_int_C3[(14*12 -1):14*11];
assign out12_2 = out_int_C3[(14*13 -1):14*12];
assign out13_2 = out_int_C3[(14*14 -1):14*13];
assign out14_2 = out_int_C3[(14*15 -1):14*14];
assign out15_2 = out_int_C3[(14*16 -1):14*15];
assign out16_2 = out_int_C3[(14*17 -1):14*16];
assign out17_2 = out_int_C3[(14*18 -1):14*17];
assign out18_2 = out_int_C3[(14*19 -1):14*18];
assign out19_2 = out_int_C3[(14*20 -1):14*19];
assign out20_2 = out_int_C3[(14*21 -1):14*20];
assign out21_2 = out_int_C3[(14*22 -1):14*21];
assign out22_2 = out_int_C3[(14*23 -1):14*22];
assign out23_2 = out_int_C3[(14*24 -1):14*23];
assign out24_2 = out_int_C3[(14*25 -1):14*24];
assign out25_2 = out_int_C3[(14*26 -1):14*25];
assign out26_2 = out_int_C3[(14*27 -1):14*26];
assign out27_2 = out_int_C3[(14*28 -1):14*27];
assign out28_2 = out_int_C3[(14*29 -1):14*28];
assign out29_2 = out_int_C3[(14*30 -1):14*29];
assign out30_2 = out_int_C3[(14*31 -1):14*30];
assign out31_2 = out_int_C3[(14*32 -1):14*31];
assign out32_2 = out_int_C3[(14*33 -1):14*32];
assign out33_2 = out_int_C3[(14*34 -1):14*33];
assign out34_2 = out_int_C3[(14*35 -1):14*34];
assign out35_2 = out_int_C3[(14*36 -1):14*35];
assign out36_2 = out_int_C3[(14*37 -1):14*36];
assign out37_2 = out_int_C3[(14*38 -1):14*37];
assign out38_2 = out_int_C3[(14*39 -1):14*38];
assign out39_2 = out_int_C3[(14*40 -1):14*39];
assign out40_2 = out_int_C3[(14*41 -1):14*40];
assign out41_2 = out_int_C3[(14*42 -1):14*41];
assign out42_2 = out_int_C3[(14*43 -1):14*42];
assign out43_2 = out_int_C3[(14*44 -1):14*43];
assign out44_2 = out_int_C3[(14*45 -1):14*44];
assign out45_2 = out_int_C3[(14*46 -1):14*45];
assign out46_2 = out_int_C3[(14*47 -1):14*46];
assign out47_2 = out_int_C3[(14*48 -1):14*47];
assign out48_2 = out_int_C3[(14*49 -1):14*48];
assign out49_2 = out_int_C3[(14*50 -1):14*49];
assign out50_2 = out_int_C3[(14*51 -1):14*50];
assign out51_2 = out_int_C3[(14*52 -1):14*51];
assign out52_2 = out_int_C3[(14*53 -1):14*52];
assign out53_2 = out_int_C3[(14*54 -1):14*53];
assign out54_2 = out_int_C3[(14*55 -1):14*54];
assign out55_2 = out_int_C3[(14*56 -1):14*55];
assign out56_2 = out_int_C3[(14*57 -1):14*56];
assign out57_2 = out_int_C3[(14*58 -1):14*57];
assign out58_2 = out_int_C3[(14*59 -1):14*58];
assign out59_2 = out_int_C3[(14*60 -1):14*59];
assign out60_2 = out_int_C3[(14*61 -1):14*60];
assign out61_2 = out_int_C3[(14*62 -1):14*61];
assign out62_2 = out_int_C3[(14*63 -1):14*62];
assign out63_2 = out_int_C3[(14*64 -1):14*63];

assign out0_3 = out_int_C4[(14*1 -1):14*0];
assign out1_3 = out_int_C4[(14*2 -1):14*1];
assign out2_3 = out_int_C4[(14*3 -1):14*2];
assign out3_3 = out_int_C4[(14*4 -1):14*3];
assign out4_3 = out_int_C4[(14*5 -1):14*4];
assign out5_3 = out_int_C4[(14*6 -1):14*5];
assign out6_3 = out_int_C4[(14*7 -1):14*6];
assign out7_3 = out_int_C4[(14*8 -1):14*7];
assign out8_3 = out_int_C4[(14*9 -1):14*8];
assign out9_3 = out_int_C4[(14*10 -1):14*9];
assign out10_3 = out_int_C4[(14*11 -1):14*10];
assign out11_3 = out_int_C4[(14*12 -1):14*11];
assign out12_3 = out_int_C4[(14*13 -1):14*12];
assign out13_3 = out_int_C4[(14*14 -1):14*13];
assign out14_3 = out_int_C4[(14*15 -1):14*14];
assign out15_3 = out_int_C4[(14*16 -1):14*15];
assign out16_3 = out_int_C4[(14*17 -1):14*16];
assign out17_3 = out_int_C4[(14*18 -1):14*17];
assign out18_3 = out_int_C4[(14*19 -1):14*18];
assign out19_3 = out_int_C4[(14*20 -1):14*19];
assign out20_3 = out_int_C4[(14*21 -1):14*20];
assign out21_3 = out_int_C4[(14*22 -1):14*21];
assign out22_3 = out_int_C4[(14*23 -1):14*22];
assign out23_3 = out_int_C4[(14*24 -1):14*23];
assign out24_3 = out_int_C4[(14*25 -1):14*24];
assign out25_3 = out_int_C4[(14*26 -1):14*25];
assign out26_3 = out_int_C4[(14*27 -1):14*26];
assign out27_3 = out_int_C4[(14*28 -1):14*27];
assign out28_3 = out_int_C4[(14*29 -1):14*28];
assign out29_3 = out_int_C4[(14*30 -1):14*29];
assign out30_3 = out_int_C4[(14*31 -1):14*30];
assign out31_3 = out_int_C4[(14*32 -1):14*31];
assign out32_3 = out_int_C4[(14*33 -1):14*32];
assign out33_3 = out_int_C4[(14*34 -1):14*33];
assign out34_3 = out_int_C4[(14*35 -1):14*34];
assign out35_3 = out_int_C4[(14*36 -1):14*35];
assign out36_3 = out_int_C4[(14*37 -1):14*36];
assign out37_3 = out_int_C4[(14*38 -1):14*37];
assign out38_3 = out_int_C4[(14*39 -1):14*38];
assign out39_3 = out_int_C4[(14*40 -1):14*39];
assign out40_3 = out_int_C4[(14*41 -1):14*40];
assign out41_3 = out_int_C4[(14*42 -1):14*41];
assign out42_3 = out_int_C4[(14*43 -1):14*42];
assign out43_3 = out_int_C4[(14*44 -1):14*43];
assign out44_3 = out_int_C4[(14*45 -1):14*44];
assign out45_3 = out_int_C4[(14*46 -1):14*45];
assign out46_3 = out_int_C4[(14*47 -1):14*46];
assign out47_3 = out_int_C4[(14*48 -1):14*47];
assign out48_3 = out_int_C4[(14*49 -1):14*48];
assign out49_3 = out_int_C4[(14*50 -1):14*49];
assign out50_3 = out_int_C4[(14*51 -1):14*50];
assign out51_3 = out_int_C4[(14*52 -1):14*51];
assign out52_3 = out_int_C4[(14*53 -1):14*52];
assign out53_3 = out_int_C4[(14*54 -1):14*53];
assign out54_3 = out_int_C4[(14*55 -1):14*54];
assign out55_3 = out_int_C4[(14*56 -1):14*55];
assign out56_3 = out_int_C4[(14*57 -1):14*56];
assign out57_3 = out_int_C4[(14*58 -1):14*57];
assign out58_3 = out_int_C4[(14*59 -1):14*58];
assign out59_3 = out_int_C4[(14*60 -1):14*59];
assign out60_3 = out_int_C4[(14*61 -1):14*60];
assign out61_3 = out_int_C4[(14*62 -1):14*61];
assign out62_3 = out_int_C4[(14*63 -1):14*62];
assign out63_3 = out_int_C4[(14*64 -1):14*63];


/*
out_int[14:0] corresponds to inC0[0] and out_int[895:882] corresponds to inC0[63]
*/
genvar j;
generate
    for (j=0; j<NUM_FILTERS_PERCOLUMN; j=j+1) begin : FILTERS_COL1
        cic3_echip65_14b
            cic3_echip65_14b (
                .out                    (out_int_C1[(j+1)*14-1:j*14]), //14-bit digital output for filter
                .in                     (inC0[j]),
                .clk                    (clk),
                .reset_n                (reset_n)
            );
    end
endgenerate

genvar l;
generate
    for (l=0; l<NUM_FILTERS_PERCOLUMN; l=l+1) begin : FILTERS_COL2
        cic3_echip65_14b
            cic3_echip65_14b (
                .out                    (out_int_C2[(l+1)*14-1:l*14]), //14-bit digital output for filter
                .in                     (inC1[l]),
                .clk                    (clk),
                .reset_n                (reset_n)
            );
    end
endgenerate

genvar m;
generate
    for (m=0; m<NUM_FILTERS_PERCOLUMN; m=m+1) begin : FILTERS_COL3
        cic3_echip65_14b
            cic3_echip65_14b (
                .out                    (out_int_C3[(m+1)*14-1:m*14]), //14-bit digital output for filter
                .in                     (inC2[m]),
                .clk                    (clk),
                .reset_n                (reset_n)
            );
    end
endgenerate

genvar n;
generate
    for (n=0; n<NUM_FILTERS_PERCOLUMN; n=n+1) begin : FILTERS_COL4
        cic3_echip65_14b
            cic3_echip65_14b (
                .out                    (out_int_C4[(n+1)*14-1:n*14]), //14-bit digital output for filter
                .in                     (inC3[n]),
                .clk                    (clk),
                .reset_n                (reset_n)
            );
    end
endgenerate

endmodule