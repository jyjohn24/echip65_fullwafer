//////////////////////////////////////////////////////////////////////////////
// Module: sd_mod2
// Description: 
//   Second-order sigma-delta modulator - SystemVerilog behavioral model
//   Converted from Verilog-A/AMS to pure SystemVerilog for digital simulation
//
// Original Author: Aikaterini Papadopoulou (katerina@lbl.gov)
// Original Code: ECHIP_modulator sd_mod2 adms_vlogams (Questa ADMS model)
// Original Reference: Based on the Designer's Guide Community publication 
//                     "Data Converters", authored by Monte Mar.
//
// Conversion: Verilog-A to SystemVerilog
// Conversion Author: Tarun Prakash (tprakash@lbl.gov)
// Conversion Date: 2026-01-26
// 
// Changes from original Verilog-A version:
//   - Removed electrical disciplines and analog blocks
//   - Changed electrical signals to 'real' type for analog inputs
//   - Removed V() voltage probe syntax (direct signal access)
//   - Capacitor parameters converted from 'f' suffix to 'e-15' notation
//   - Added doutb complement output generation
//
//////////////////////////////////////////////////////////////////////////////


module sd_mod2(
    output reg dout, doutb,
    input real vbias1[1:4], vbias2[1:4],  // Not used, kept for port compatibility
    input real vcm, vdd, vrefn, vrefp, vss,
    input real in,  // Changed from electrical to real
    input wire p1, p2, rst
);

parameter real c1 = 160e-15;  // 160f
parameter real c2 = 880e-15;  // 880f
parameter real c3 = 60e-15;   // 60f
parameter real c4 = 40e-15;   // 40f
parameter real c5 = 100e-15;  // 100f
parameter real aol1 = 1000;
parameter real aol2 = 1000;

real x1, x2, qs1, qs2, dacval;
real coeff11 = (aol1 + 1.0)/(aol1 + (c1/c2) + 1.0);
real coeff12 = (aol1)/(aol1 + (c1/c2) + 1.0);
real coeff13 = (aol1)/(aol1 + (c1/c2) + 1.0);
real coeff21 = (aol2 + 1.0)/(aol2 + (c3/c5) + 1.0);
real coeff22 = (aol2)/(aol2 + (c3/c5) + 1.0);
real coeff23 = (aol2)/(aol2 + (c4/c5) + 1.0);

// MODEL
initial begin
    qs1 = 0.0; qs2 = 0.0;
    x1 = 0.0; x2 = 0.0;    
    dacval = vrefn - vcm;  // Changed from V(vrefn)
end

always @(negedge p1) begin
    qs1 <= coeff12*c1*(in - vcm);      // Changed from V(in), V(vcm)
    qs2 <= coeff22*c3*(x1);
end

always @(negedge p2) begin
    x1 <= (qs1 + coeff11*c2*x1 - coeff13*dacval*c1)/c2;
    x2 <= (qs2 + coeff21*c5*x2 - coeff23*dacval*c4)/c5;
end

always @(posedge p2 or negedge rst) begin
    if (!rst) begin
        // TP: added reset logic, issues in simulation.
        dout <= 0;
        doutb <= 1;
        x1 <= 0.0;
        x2 <= 0.0;
        qs1 <= 0.0;
        qs2 <= 0.0;
        dacval <= vrefn - vcm;
    end else begin
        if (x2 > 0.0) begin
            dout <= 1;
            dacval <= vrefp - vcm;  // Changed from V(vrefp), V(vcm)
        end else begin
            dout <= 0;
            dacval <= vrefn - vcm;  // Changed from V(vrefn), V(vcm)
        end
        doutb <= ~dout;  // TP: Added complement output
    end
end

endmodule