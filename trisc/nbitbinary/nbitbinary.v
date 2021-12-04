module nbitbinary #(parameter N = 4) ( // Sworup Bhattarai 1001093304
	input COUNT, CLEAR, LOAD, 
	input [N-1:0] in,
	output reg [N-1:0] y );   
	


	always @ (posedge COUNT, posedge LOAD, negedge CLEAR)
	begin	
		if (LOAD==1'b1)
		begin
			y <= in;
		end
		
		else if (CLEAR==1'b0) 
		begin
			y <= 0;       
		end
		
		else if (COUNT ==1'b1)
		begin
			y <=  y+ 1'b1;            
		end
		
	end	
endmodule
