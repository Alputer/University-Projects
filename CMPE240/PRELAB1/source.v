`timescale 1ns / 1ns
module source(y, x2, x1, x0);

input x2,x1,x0;
output y;
wire x0x2, notx0x2, x1notx0x2, notx1, x2notx1;


not(notx1, x1);
not(notx0x2, x0x2);

or(x0x2, x0, x2);
or(y, x1notx0x2, x2notx1);

and(x2notx1, x2, notx1);
and(x1notx0x2 ,x1, notx0x2);


endmodule
