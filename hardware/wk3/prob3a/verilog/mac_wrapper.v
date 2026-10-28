// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, reset, out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;
parameter array_length = 4;

output [psum_bw-1:0] out;
input  [array_length-1:0][bw-1:0] a ;
input  [array_length-1:0][bw-1:0] b ;
input  [psum_bw-1:0] c;
input  clk;
input  reset;

reg    [array_length-1:0][bw-1:0] a_q;
reg    [array_length-1:0][bw-1:0] b_q;
reg    [psum_bw-1:0] c_q;

big_mac #(.bw(bw), .psum_bw(psum_bw), .array_length(array_length)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
	.out(out)
); 

always @ (posedge clk) begin
  if (!reset) begin
        b_q  <= '0;
        a_q  <= '0;
        c_q  <= '0;	
  end 
  else begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;
  end
end

endmodule
