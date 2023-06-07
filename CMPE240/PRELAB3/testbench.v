`timescale 1ns/1ns
module testbench();

wire [1:0] out1;
wire [1:0] out2;
wire [1:0] out3;
wire [1:0] out4;
wire [1:0] out5;
reg inp1;
reg inp2;
reg inp3;
reg inp4;
reg inp5;
reg rst;
reg clk;
parameter inputsequence1 = 32'b01001010010001101001010010000101;
parameter inputsequence2 = 32'b11101111110101100010100010001101;
parameter inputsequence3 = 32'b10100011011010110010111101000100;
parameter inputsequence4 = 32'b01110111011010110000011101101010;
parameter inputsequence5 = 32'b01010101111101001101110101100010;
integer i;


myfsm fsm1(.out(out1), .inp(inp1), .clk(clk), .rst(rst));
myfsm fsm2(.out(out2), .inp(inp2), .clk(clk), .rst(rst));
myfsm fsm3(.out(out3), .inp(inp3), .clk(clk), .rst(rst));
myfsm fsm4(.out(out4), .inp(inp4), .clk(clk), .rst(rst));
myfsm fsm5(.out(out5), .inp(inp5), .clk(clk), .rst(rst));



initial begin
    $dumpfile("TimingDiagram.vcd");
    $dumpvars(0, inp1, inp2, inp3, inp4, inp5, out1, out2, out3, out4, out5, rst, clk, fsm1, fsm2, fsm3, fsm4, fsm5);
    
    rst = 1;
 
    inp1 = 0;
    inp2 = 0;
    inp3 = 0;
    inp4 = 0;
    inp5 = 0;
    #30;
    rst = 0;
    
    for (i=31; i>=0; i--) begin
        inp1 = inputsequence1[i];
        inp2 = inputsequence2[i];
        inp3 = inputsequence3[i];
        inp4 = inputsequence4[i];
        inp5 = inputsequence5[i];

		if (i == 31)  begin
        #15;
		end
		else begin
		#20;
		end
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
