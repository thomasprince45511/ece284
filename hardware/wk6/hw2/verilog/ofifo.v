// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module ofifo (clk, in, out, rd, wr, o_full, reset, o_ready, o_valid);

  parameter col  = 8;
  parameter bw = 4;

  input  clk;
  input  [col-1:0] wr;
  input  rd;
  input  reset;
  input  [col-1:0][bw-1:0] in;
  output [col-1:0][bw-1:0] out;
  output o_full;
  output o_ready;
  output o_valid;

  wire [col-1:0] empty;
  wire [col-1:0] full;
  reg  rd_en;

  genvar i;

  assign o_ready = ~o_full ;
  assign o_full  = |full ;
  assign o_valid = ~(|empty) ;

  for (i=0; i<col; i=i+1) begin : col_num
    fifo #(.bw(bw)) fifo_instance (
      .clk(clk),
      .rd_req(rd_en),
      .wr_req(wr[i]),
      .o_empty(empty[i]),
      .o_full(full[i]),
      .in(in[i]),
      .out(out[i]),
      .reset(reset)
    );
  end

  always @ (posedge clk) begin
    if (reset) begin
      rd_en <= 0;
    end
    else begin
      rd_en <= rd;
    end
  end

endmodule
