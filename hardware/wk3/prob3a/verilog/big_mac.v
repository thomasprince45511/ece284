// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module big_mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;
parameter array_length = 4;

input unsigned [array_length-1:0][bw-1:0] a;
input signed [array_length-1:0][bw-1:0] b;
input signed [psum_bw-1:0] c;

output signed [psum_bw-1:0] out;

assign out = c + $signed(b[0]) * $signed({1'b0,a[0]})
               + $signed(b[1]) * $signed({1'b0,a[1]})
               + $signed(b[2]) * $signed({1'b0,a[2]})
               + $signed(b[3]) * $signed({1'b0,a[3]});

endmodule
