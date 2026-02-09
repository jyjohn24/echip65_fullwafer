///////////////////////////////////////////////////////////////////
// File Name: sdm_rnm_sd_mod2_wrapper.sv
// Engineer:  Tarun Prakash (tprakash@lbl.gov)
// Description: Wrapper to make sd_mod2 compatible with sdm_rnm interface
//              This allows sd_mod2 to be used as a drop-in replacement 
//              for sdm_rnm in existing testbenches.
//
// Interface Compatibility:
//   - Maps clk -> p1 and p2 (non-overlapping clocks simulated)
//   - Maps reset_n -> rst
//   - Maps analog_in -> in (with appropriate scaling)
//   - Provides default values for analog supplies (vcm, vrefp, vrefn, etc.)
//
// Replace module name 'sdm_rnm' with 'sdm_rnm_sd_mod2_wrapper'
////////////////////////////////////////////////////////////////////

module sdm_rnm_sd_mod2_wrapper (
    output logic dout,
    input real analog_in,
    input logic clk,
    input logic reset_n
);

// Internal signals for non-overlapping clock generation
logic p1, p2;

// Default analog supply values (configurable via parameters)
parameter real VDD = 1.2;           // Supply voltage
parameter real VSS = 0.0;           // Ground
parameter real VCM = VDD/2.0;       // Common mode = VDD/2
parameter real VREFP = VDD/2.0 + 0.25;  // Upper reference
parameter real VREFN = VDD/2.0 - 0.25;  // Lower reference

// Bias voltages (not used in behavioral model but required for port compatibility)
real vbias1[1:4] = '{VDD/2.0, VDD/2.0, VDD/2.0, VDD/2.0};
real vbias2[1:4] = '{VDD/2.0, VDD/2.0, VDD/2.0, VDD/2.0};

// Wire for complementary output (not used in sdm_rnm interface)
logic doutb;

// Generate non-overlapping clocks p1 and p2 from single clock
// p1 = clk: active high during clock high phase
// p2 = ~clk: active high during clock low phase (non-overlapping with p1)
// When reset_n is low, both clocks are forced to 0
assign p1 = reset_n ? clk : 1'b0;
assign p2 = reset_n ? ~clk : 1'b0;

//TP: scaling the input from ±1.0 to VCM±0.25V range for sd_mod2
// Scale ±1.0 input to VCM±0.25V range  
real scaled_in;
assign scaled_in = (analog_in * 0.125) + VCM;  // Maps ±1→0.475V to 0.725V


// Instantiate the sd_mod2 module
sd_mod2 u_sd_mod2 (
    .dout(dout),
    .doutb(doutb),              // Not connected externally
    .vbias1(vbias1),
    .vbias2(vbias2),
    .vcm(VCM),
    .vdd(VDD),
    .vrefn(VREFN),
    .vrefp(VREFP),
    .vss(VSS),
    .in(scaled_in),
    .p1(p1),
    .p2(p2),
    .rst(reset_n)
);

endmodule
