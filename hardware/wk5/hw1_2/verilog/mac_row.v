// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac_row (clk, out_s, in_w, in_n, valid, inst_w, reset);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;

  input  clk, reset;
  output [col-1:0][psum_bw-1:0] out_s;
  output [col-1:0] valid;
  input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [col-1:0][psum_bw-1:0] in_n;

  // West-to-east chains, one slot per column boundary (col+1 slots).
  // Slot 0 is the row input; column i reads slot i-1 and drives slot i.
  wire [col:0][bw-1:0] weight_chain;    // activation / weight stream
  wire [col:0][1:0]    inst_chain;   // instruction stream

  assign weight_chain[0]  = in_w;
  assign inst_chain[0] = inst_w;

  genvar i;
  for (i=1; i < col+1 ; i=i+1) begin : col_num
      mac_tile #(.bw(bw), .psum_bw(psum_bw)) mac_tile_instance (
         .clk(clk),
         .reset(reset),
         .in_w(weight_chain[i-1]),
         .out_e(weight_chain[i]),
         .inst_w(inst_chain[i-1]),
         .inst_e(inst_chain[i]),
         .in_n(in_n[i-1]),
         .out_s(out_s[i-1]));

      // column i's output is ready once the execute bit has passed it
      assign valid[i-1] = inst_chain[i][1];
  end

endmodule
