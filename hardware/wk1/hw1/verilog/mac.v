// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

wire [psum_bw-1:0] psum;
wire signed [psum_bw-1:0] psum_form0;
wire unsigned [psum_bw-1:0] psum_form1;


wire [psum_bw-1:0] summand;
reg signed [psum_bw-1:0] summand_form0;
reg signed [bw-1:0] a_form0;
reg signed [bw-1:0] b_form0;


assign out = psum_q;

// Flopping inputs and outputs
always @ (posedge clk) begin
  if (reset) begin
    psum_q <= 0;
    a_q <= 0;
    b_q <= 0;
  end else begin
    psum_q <= psum;
    a_q <= A;
    b_q <= B;
  end
end


assign summand = acc ? psum_q : 0;

// Converting format 1 (sign and magnitude) to format0 (2s complement) for the
// inputs
always_comb begin
  case (format)
    1'b0: begin
      summand_form0 = summand;	
      a_form0 = a_q;
      b_form0 = b_q;
    end
  1'b1: begin
      summand_form0 = summand[psum_bw-1]? ( ~({1'b0,summand[psum_bw-2:0]}) + 1 ) : summand;
      a_form0 = a_q[bw-1]? ( ~({1'b0,a_q[bw-2:0]}) + 1 ) : a_q;
      b_form0 = b_q[bw-1]? ( ~({1'b0,b_q[bw-2:0]}) + 1 ) : b_q;
    end
  endcase
end

assign psum_form0 = summand_form0 + a_form0*b_form0;

// Converting format0 to format1 for output
assign psum_form1[psum_bw-1] = psum_form0[psum_bw-1];
assign psum_form1[psum_bw-2:0] = psum_form0[psum_bw-1] ? ~(psum_form0[psum_bw-2:0]) + 1 : psum_form0[psum_bw-2:0];

// Assigning output based on format
assign psum = format ? psum_form1 : psum_form0;

endmodule
