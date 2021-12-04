module alu (
	
	input [3:0] A, B, //declare input ports
	input [1:0] S,
	
	output reg [3:0] R
 	//declare output ports for sum;
	);
	
	wire [3:0] Ad, La, Lx; 
	//wire [3:0] pr;
	wire Cw, Ow;
	
	AdderSubtractor ( A, B ,S[0], Ad , Cw, Ow);
	
	assign La = A & B;
	assign Lx = A ^ B; 
	
	always @ (S)
	begin 
		if (S == 2'b00) 
		begin
		R <= Ad;
		end
		
		else if (S == 2'b01)  
		begin
		R <= Ad;

		end
		
		else if (S == 2'b10) 
		begin
		R <= La;
		end
		
		else if (S == 2'b11)	
		begin
		R <= Lx; 
		end;
		
	end 
	
	//towscomplement towscomplement_inst(.in(R) ,	.a(pins) );

	
endmodule
