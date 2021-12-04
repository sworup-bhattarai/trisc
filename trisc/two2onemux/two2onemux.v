module two2onemux #(parameter N = 4) ( // Sworup Bhattarai 1001093304
	input SELECT, 
	input [N-1:0] A, B,
	output reg [N-1:0] y );  
	
	always @ (SELECT,A,B)
	begin	
	
		if (SELECT==1'b1)
		begin
			y <= B;
		end
		
		else 
		begin
			y <= A;
		end
		
	end
endmodule
