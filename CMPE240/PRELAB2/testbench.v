`timescale 1ns / 1ns

module testbench();

reg x0,x1,x2,x3;
wire y;

source my_module(y,x3,x2, x1, x0);

initial begin

$dumpfile("TimingDiagram.vcd");
$dumpvars(0, y, x3, x2, x1, x0);

x3 = 1'b0;
x2 = 1'b0;
x1 = 1'b0;
x0 = 1'b0;

#20 
x3 = 1'b0;
x2 = 1'b0;
x1 = 1'b0;
x0 = 1'b1;

#20 
x3 = 1'b0;
x2 = 1'b0;
x1 = 1'b1;
x0 = 1'b0;

#20 
x3 = 1'b0;
x2 = 1'b0;
x1 = 1'b1;
x0 = 1'b1;

#20 
x3 = 1'b0;
x2 = 1'b1;
x1 = 1'b0;
x0 = 1'b0;

#20 
x3 = 1'b0;
x2 = 1'b1;
x1 = 1'b0;
x0 = 1'b1;

#20 
x3 = 1'b0;
x2 = 1'b1;
x1 = 1'b1;
x0 = 1'b0;

#20 
x3 = 1'b0;
x2 = 1'b1;
x1 = 1'b1;
x0 = 1'b1;
#20; 

x3 = 1'b1;
x2 = 1'b0;
x1 = 1'b0;
x0 = 1'b0;

#20 
x3 = 1'b1;
x2 = 1'b0;
x1 = 1'b0;
x0 = 1'b1;

#20 
x3 = 1'b1;
x2 = 1'b0;
x1 = 1'b1;
x0 = 1'b0;

#20 
x3 = 1'b1;
x2 = 1'b0;
x1 = 1'b1;
x0 = 1'b1;

#20 
x3 = 1'b1;
x2 = 1'b1;
x1 = 1'b0;
x0 = 1'b0;

#20 
x3 = 1'b1;
x2 = 1'b1;
x1 = 1'b0;
x0 = 1'b1;

#20 
x3 = 1'b1;
x2 = 1'b1;
x1 = 1'b1;
x0 = 1'b0;

#20 
x3 = 1'b1;
x2 = 1'b1;
x1 = 1'b1;
x0 = 1'b1;
#20  // Puts 20 ns delay

     $finish;
end
	 
	 
endmodule