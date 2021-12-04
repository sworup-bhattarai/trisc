
module IR #(parameter N = 4)
(
	input [N-1:0] D, 		
	input CLK, CLR,		 
	output reg [N-1:0] Q
); 		//declare N-bit data output


		always @ (posedge CLK, negedge CLR) 		
			begin
				if (CLR==1'b0) Q <= 0; 		
				else if (CLK==1'b1) Q <= D;
			end
endmodule
