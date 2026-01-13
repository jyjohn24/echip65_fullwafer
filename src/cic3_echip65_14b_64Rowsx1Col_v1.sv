///////////////////////////////////////////////////////////////////
// File Name: cic3_echip65_14b_64Rowsx1Col_v1.sv
// Engineer:  Jyothisraj Johnson (jyothisrajjohnson@lbl.gov)
// Description: 64x1 array of digital filters 
//              (simple, no integrated digital monitor always_comb block or cfg. bits)
//              clk is common input and divided_clk generated internally
///////////////////////////////////////////////////////////////////

/*
JJ (03/06/25): keeping same module name for the moment for iterating through implementation power checks
               this assumes cic3_echip65_simple.sv as root src code
JJ (03/13/25): creating 24 sets of 25-bit filter outputs to make association of outputs w/ filter instances explicit
JJ (01/12/26): updating to use cic3_echip65_14b.sv as root src code (14-bit output version) and an array of 64x1 filters
*/

module cic3_echip65_14b_64Rowsx1Col
#(
parameter NUM_FILTERS_PERCOLUMN = 64,
parameter NUM_COLUMNS = 1
)
(//outputs are all directly sent to current starved buffers right below bottom power rings at design boundry edge
output logic [(14-1):0] out0, 
output logic [(14-1):0] out1,
output logic [(14-1):0] out2, 
output logic [(14-1):0] out3,
output logic [(14-1):0] out4, 
output logic [(14-1):0] out5,
output logic [(14-1):0] out6, 
output logic [(14-1):0] out7,
output logic [(14-1):0] out8, 
output logic [(14-1):0] out9,
output logic [(14-1):0] out10, 
output logic [(14-1):0] out11,
output logic [(14-1):0] out12, 
output logic [(14-1):0] out13,
output logic [(14-1):0] out14, 
output logic [(14-1):0] out15,
output logic [(14-1):0] out16, 
output logic [(14-1):0] out17,
output logic [(14-1):0] out18, 
output logic [(14-1):0] out19,
output logic [(14-1):0] out20, 
output logic [(14-1):0] out21,
output logic [(14-1):0] out22, 
output logic [(14-1):0] out23,
output logic [(14-1):0] out24, 
output logic [(14-1):0] out25,
output logic [(14-1):0] out26, 
output logic [(14-1):0] out27,
output logic [(14-1):0] out28, 
output logic [(14-1):0] out29,
output logic [(14-1):0] out30, 
output logic [(14-1):0] out31,
output logic [(14-1):0] out32, 
output logic [(14-1):0] out33,
output logic [(14-1):0] out34, 
output logic [(14-1):0] out35,
output logic [(14-1):0] out36, 
output logic [(14-1):0] out37,
output logic [(14-1):0] out38, 
output logic [(14-1):0] out39,
output logic [(14-1):0] out40, 
output logic [(14-1):0] out41,
output logic [(14-1):0] out42, 
output logic [(14-1):0] out43,
output logic [(14-1):0] out44, 
output logic [(14-1):0] out45,
output logic [(14-1):0] out46, 
output logic [(14-1):0] out47,
output logic [(14-1):0] out48, 
output logic [(14-1):0] out49,
output logic [(14-1):0] out50, 
output logic [(14-1):0] out51,
output logic [(14-1):0] out52, 
output logic [(14-1):0] out53,
output logic [(14-1):0] out54, 
output logic [(14-1):0] out55,
output logic [(14-1):0] out56, 
output logic [(14-1):0] out57,
output logic [(14-1):0] out58, 
output logic [(14-1):0] out59,
output logic [(14-1):0] out60, 
output logic [(14-1):0] out61,
output logic [(14-1):0] out62, 
output logic [(14-1):0] out63, 
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

logic [(NUM_FILTERS_PERCOLUMN*NUM_COLUMNS*14-1):0] out_int; //output bits from filters
logic [(NUM_FILTERS_PERCOLUMN-1):0] inC0; //input bits from modulators to filters in column 0

/*
in is a large 1D array of bits from modulators feeding into each filter instance.
For 4 columns, in[0] would be top filter input (of column 1), in[1] would be top filter input (of column 1), in[4] would be second row filter (column 1), etc.
*/
genvar k;
generate
    for (k=0; k<NUM_FILTERS_PERCOLUMN; k=k+1) begin : FILTER_INPUTS
        assign inC0[k] = in[k];
        // assign inC0[k] = in[k*4+0];
        // assign inC1[k] = in[k*4+1];
        // assign inC2[k] = in[k*4+2];
        // assign inC3[k] = in[k*4+3];
    end
endgenerate

/*
To make it easier for grouping of output bits to each filter instance, we have to get explicit.
Digital filter numbering starts w/ instance 0 at top left edge and 63 at bottom left edge.
For each, [MSB:LSB] pin ordering --> out0[0] is top-most bit and out23[13] is bottom-most bit on left edge
*/
assign out0 = out_int[(14*1 -1):14*0];
assign out1 = out_int[(14*2 -1):14*1];
assign out2 = out_int[(14*3 -1):14*2];
assign out3 = out_int[(14*4 -1):14*3];
assign out4 = out_int[(14*5 -1):14*4];
assign out5 = out_int[(14*6 -1):14*5];
assign out6 = out_int[(14*7 -1):14*6];
assign out7 = out_int[(14*8 -1):14*7];
assign out8 = out_int[(14*9 -1):14*8];
assign out9 = out_int[(14*10 -1):14*9];
assign out10 = out_int[(14*11 -1):14*10];
assign out11 = out_int[(14*12 -1):14*11];
assign out12 = out_int[(14*13 -1):14*12];
assign out13 = out_int[(14*14 -1):14*13];
assign out14 = out_int[(14*15 -1):14*14];
assign out15 = out_int[(14*16 -1):14*15];
assign out16 = out_int[(14*17 -1):14*16];
assign out17 = out_int[(14*18 -1):14*17];
assign out18 = out_int[(14*19 -1):14*18];
assign out19 = out_int[(14*20 -1):14*19];
assign out20 = out_int[(14*21 -1):14*20];
assign out21 = out_int[(14*22 -1):14*21];
assign out22 = out_int[(14*23 -1):14*22];
assign out23 = out_int[(14*24 -1):14*23];
assign out24 = out_int[(14*25 -1):14*24];
assign out25 = out_int[(14*26 -1):14*25];
assign out26 = out_int[(14*27 -1):14*26];
assign out27 = out_int[(14*28 -1):14*27];
assign out28 = out_int[(14*29 -1):14*28];
assign out29 = out_int[(14*30 -1):14*29];
assign out30 = out_int[(14*31 -1):14*30];
assign out31 = out_int[(14*32 -1):14*31];
assign out32 = out_int[(14*33 -1):14*32];
assign out33 = out_int[(14*34 -1):14*33];
assign out34 = out_int[(14*35 -1):14*34];
assign out35 = out_int[(14*36 -1):14*35];
assign out36 = out_int[(14*37 -1):14*36];
assign out37 = out_int[(14*38 -1):14*37];
assign out38 = out_int[(14*39 -1):14*38];
assign out39 = out_int[(14*40 -1):14*39];
assign out40 = out_int[(14*41 -1):14*40];
assign out41 = out_int[(14*42 -1):14*41];
assign out42 = out_int[(14*43 -1):14*42];
assign out43 = out_int[(14*44 -1):14*43];
assign out44 = out_int[(14*45 -1):14*44];
assign out45 = out_int[(14*46 -1):14*45];
assign out46 = out_int[(14*47 -1):14*46];
assign out47 = out_int[(14*48 -1):14*47];
assign out48 = out_int[(14*49 -1):14*48];
assign out49 = out_int[(14*50 -1):14*49];
assign out50 = out_int[(14*51 -1):14*50];
assign out51 = out_int[(14*52 -1):14*51];
assign out52 = out_int[(14*53 -1):14*52];
assign out53 = out_int[(14*54 -1):14*53];
assign out54 = out_int[(14*55 -1):14*54];
assign out55 = out_int[(14*56 -1):14*55];
assign out56 = out_int[(14*57 -1):14*56];
assign out57 = out_int[(14*58 -1):14*57];
assign out58 = out_int[(14*59 -1):14*58];
assign out59 = out_int[(14*60 -1):14*59];
assign out60 = out_int[(14*61 -1):14*60];
assign out61 = out_int[(14*62 -1):14*61];
assign out62 = out_int[(14*63 -1):14*62];
assign out63 = out_int[(14*64 -1):14*63];

/*
out_int[14:0] corresponds to inC0[0] and out_int[895:882] corresponds to inC0[63]
*/
genvar j;
generate
    for (j=0; j<NUM_FILTERS_PERCOLUMN; j=j+1) begin : FILTERS_COL0
        cic3_echip65_14b
            cic3_echip65_14b (
                .out                    (out_int[(j+1)*14-1:j*14]), //14-bit digital output for filter
                .in                     (inC0[j]),
                .clk                    (clk),
                .reset_n                (reset_n)
            );
    end
endgenerate

endmodule