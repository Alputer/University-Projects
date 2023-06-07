`timescale 1ns / 1ns
module source(y, x3, x2, x1, x0);

input x3,x2,x1,x0;
output y;
wire x0x1, x0xorx1;


and(x0x1, x0, x1);
xor(x0xorx1, x0, x1);

myMux Mux  (x2, x3, x0x1, x0, x1, x0xorx1, y);

endmodule