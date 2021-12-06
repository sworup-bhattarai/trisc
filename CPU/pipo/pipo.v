//Verilog Model of an N-bit register with active-low asynchronous clear
module Pipo #(parameter N = 4)(
	input [N-1:0] D, 		//declare N-bit data input
	input CLK, CLR,		 //declare clock and clear inputs
	output reg [N-1:0] Q); 		//declare N-bit data output
		always @ (negedge CLK, negedge CLR) 		//detect change of clock or clear
			begin
				if (CLR==1'b0) Q <= 0; 		//register loaded with all 0’s
				else if (CLK==1'b0) Q <= D; 		//data input values loaded in register
			end
endmodule
