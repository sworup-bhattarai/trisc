module fourtosixteen 
	(
	input [0:3] S,
	output reg [0:15] Y
	);
	
	always @ (S)
	case({S})
		4'b0000: Y = 16'b1000000000000000; //LDA 
		4'b0001: Y = 16'b0100000000000000; //STA 
		4'b0010: Y = 16'b0010000000000000; //ADD 
		4'b0011: Y = 16'b0001000000000000; //SUB - NOT USED  
		4'b0100: Y = 16'b0000100000000000; //XOR - NOT USED   
		4'b0110: Y = 16'b0000010000000000; //INC 
		4'b0111: Y = 16'b0000001000000000; //CLR 
		4'b1000: Y = 16'b0000000100000000; //JMP 
		4'b1100: Y = 16'b0000000010000000; //JPN - NOT USED
		4'b1001: Y = 16'b0000000001000000; //JPZ - NOT USED     
		4'b1111: Y = 16'b0000000000100000; //HLT - NOT USED 
		default: Y = 16'b0000000000000000; //Defaults to all 0s
	endcase                                         
endmodule
