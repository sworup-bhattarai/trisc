module two2one #(parameter N=4) 
  ( 
   input [N-1:0] A, B,   //declare data inputs 
   input S,   //declare select input 
   output reg [N-1:0] Y  //declare output 
  ); 
	always @ (S)
		if (S == 1'b1) Y <= B; 
		else if (S == 1'b0) Y <= A;
		
	endmodule 
 