`timescale 1ns / 1ns

module myfsm (out, inp, clk, rst);

output reg [1:0]out;
input wire inp;
input wire rst;
input wire clk;

parameter S0 = 3'b000,
	S1 = 3'b001,
	S2 = 3'b010,
	S3 = 3'b011,
    S4 = 3'b100,
	S5 = 3'b101,
	S6 = 3'b110,
    S7 = 3'b111;
	
reg [2:0] stateReg;
reg [2:0] nextStateReg;

initial out = 2'b00;

always@(inp, stateReg) begin
	case(stateReg)
		S0: begin
			if(inp == 0) begin
				nextStateReg <= S1;
			end
			else begin
				nextStateReg <= S0;
			end
			out <= 2'b00;
		end
		S1: begin
			if(inp == 0) begin
				nextStateReg <= S1;
			end
			else begin
				nextStateReg <= S2;
			end
			out <= 2'b00;
		end
		S2: begin
			if(inp == 0) begin
				nextStateReg <= S3;
			end
			else begin
				nextStateReg <= S6;
			end
			out <= 2'b00;
		end
		S3: begin
			if(inp == 0) begin
				nextStateReg <= S1;
			end
			else begin
				nextStateReg <= S2;
			end
			out <= 2'b01;
		end

		S4: begin
			if(inp == 0) begin
				nextStateReg <= S1;
			end
			else begin
				nextStateReg <= S2;
			end
			out <= 2'b11;
		end

		S5: begin
			if(inp == 0) begin
				nextStateReg <= S4;
			end
			else begin
				nextStateReg <= S5;
			end
			out <= 2'b00;
		end

		S6: begin
			if(inp == 0) begin
				nextStateReg <= S7;
			end
			else begin
				nextStateReg <= S5;
			end
			out <= 2'b00;
		end

		S7: begin
			if(inp == 0) begin
				nextStateReg <= S1;
			end
			else begin
				nextStateReg <= S2;
			end
			out <= 2'b10;
		end
	endcase
end

always@(posedge clk) begin
	if(rst) begin
		stateReg <= S0;
	end
	else begin
		stateReg <= nextStateReg;
	end
end

endmodule
	