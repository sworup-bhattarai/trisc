module pipo #(parameter N = 4)( // Sworup Bhattarai 1001093304
	input [N-1:0] D, 		
	input CLK,		 
	output reg [N-1:0] Q);

	
	always @ (posedge CLK)
	
		begin
		
		if (CLK==1'b1)
			begin
				Q <= D;
			end
			
		end
		
endmodule
