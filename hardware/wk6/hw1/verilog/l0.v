// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module l0 (clk, in, out, rd, rd_stagger, wr, o_full, reset, o_ready);

  parameter row  = 8;
  parameter bw = 4;

  input  clk;
  input  wr;
  input  rd;
  input  rd_stagger;
  input  reset;
  input  [row-1:0][bw-1:0] in;
  output [row-1:0][bw-1:0] out;
  output o_full;
  output o_ready;

  wire [row-1:0] empty;
  wire [row-1:0] full;
  reg [row-1:0] rd_en;
  
  genvar i;

  assign o_full  = |full ;
  assign o_ready = ~o_full ;


  for (i=0; i<row ; i=i+1) begin : row_num
      fifo #(.bw(bw)) fifo_instance (
	 .clk(clk),
	 .rd_req(rd_en[i]),
	 .wr_req(wr),
         .o_empty(empty[i]),
         .o_full(full[i]),
	 .in(in[i]),
	 .out(out[i]),
         .reset(reset));
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 'b0;
   end
   else
      if (rd_stagger) begin
        rd_en <= {rd_en[row-2:0], rd};
      end
      else begin
        rd_en <= {row{rd}};
      end
    end

endmodule
