`timescale 1ns/1ns
module testbench();

wire [1:0] y;
reg a;
reg b;
reg rst;
reg clk;
parameter inputsequence_a = 32'b11010100101100110101101011011101;
parameter inputsequence_b = 32'b01011000011010101001010010111001;
integer i;

source fsm(y, a, b, clk, rst);

initial begin
    $dumpfile("TimingDiagram.vcd");
    $dumpvars(0, y, a, b, rst, clk, fsm);
    
    rst = 1;
    a = 0;
	b = 0;
    #30;
    rst = 0;
    
    for(i=31; i>=0; i--) begin
        a = inputsequence_a[i];
		b = inputsequence_b[i];
        #40;
    end
    
    $finish;
end

always begin	
	clk = 0;
	#20;
	clk = 1;
	#20;
end

endmodule
