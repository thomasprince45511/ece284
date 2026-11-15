// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [col-1:0][psum_bw-1:0] out_s;
  input  [row-1:0][bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [col-1:0][psum_bw-1:0] in_n;
  output [col-1:0] valid;

  // North-to-south psum chain, one slot per row boundary (row+1 slots).
  // Slot 0 is the array input; row i reads slot i-1 and drives slot i.
  wire [row:0][col-1:0][psum_bw-1:0] psum_chain;

  // valid vector of every row; only the last row's is the array output
  wire [row-1:0][col-1:0] row_valid;

  // instruction shift register: stage i-1 feeds row i, one cycle per row
  reg  [row-1:0][1:0] inst_pipe;

  assign psum_chain[0] = in_n;
  assign out_s = psum_chain[row];
  assign valid = row_valid[row-1];

  genvar i;
  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw), .col(col)) mac_row_instance (
         .clk(clk),
         .reset(reset),
         .in_w(in_w[i-1]),
         .inst_w(inst_pipe[i-1]),
         .in_n(psum_chain[i-1]),
         .out_s(psum_chain[i]),
         .valid(row_valid[i-1]));
  end

  integer j;
  always @ (posedge clk) begin
   // inst_w flows to row0 to row7
    if (reset)
      inst_pipe <= 0;
    else begin
      inst_pipe[0] <= inst_w;
      for (j = 1; j < row; j = j + 1)
        inst_pipe[j] <= inst_pipe[j-1];
    end
  end

endmodule
