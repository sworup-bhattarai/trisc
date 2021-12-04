module AdderSubtractor(
	
	input [3:0] A, B, //declare input ports
	input Cin,
	
	output [3:0] S, //declare output ports for sum
	output Cout,
	output Ovr); //declare carry-out 
	
	
	wire [4:0] C; //declare internal nets
	assign C[0] = Cin; //assign 0 to least significant carry-i


   wire 	B0; 
   wire 	B1; 
   wire 	B2; 
   wire 	B3; 
   
   xor(B0, B[0], C[0]);
   xor(B1, B[1], C[0]);
   xor(B2, B[2], C[0]);
   xor(B3, B[3], C[0]);
   //xor(Cout, C[4], C[0]);     
		
	fulladder s0 (A[0], B0, C[0], S[0], C[1]); //stage 0
	fulladder s1 (A[1], B1, C[1], S[1], C[2]); //stage 1
	fulladder s2 (A[2], B2, C[2], S[2], C[3]); //stage 2
	fulladder s3 (A[3], B3, C[3], S[3], C[4]); //stage 3
	assign Cout = C[4]; 
	
	xor(Ovr, C[3], C[4]);
	
endmodule  