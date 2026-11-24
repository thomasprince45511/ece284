// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fifo (clk, in, out, rd_req, wr_req, o_full, o_empty, reset);

  parameter depth = 64;
  parameter bw = 4;

  localparam addr_width = $clog2(depth);

  input  clk;
  input  rd_req;
  input  wr_req;
  input  reset;
  output o_full;
  output o_empty;
  input  [bw-1:0] in;
  output [bw-1:0] out;


  reg [depth-1:0][bw-1:0] buffer;

  reg [addr_width:0] wr_pointer = 0;
  wire [addr_width-1:0] wr_addr;
  reg [addr_width:0] rd_pointer = 0;
  wire [addr_width-1:0] rd_addr;


  wire o_full;
  wire o_empty;

  assign o_full = ({~wr_pointer[addr_width], wr_pointer[addr_width-1:0]} == rd_pointer );
  assign o_empty = ( wr_pointer == rd_pointer );

  assign wr_addr =  wr_pointer [addr_width-1:0];
  assign rd_addr =  rd_pointer [addr_width-1:0];



  always @ (posedge clk) begin
    if (reset) begin
      buffer <= 'b0;
      wr_pointer <= 'b0;
      rd_pointer <= 'b0;
    end
    else begin
      if (wr_req && !o_full) begin
        buffer[wr_addr] <= in;
	wr_pointer <= wr_pointer + 1;
      end

      if (rd_req && !o_empty) begin
        rd_pointer <= rd_pointer + 1;
      end
    end
  end

assign out = buffer[rd_addr];


endmodule
