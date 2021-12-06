module triscPCU
(
	input sysclock,sysreset,
	input [0:3]Sw,
	output [0:14] C
	
);
	wire [0:15] Y;

	fourtosixteen (Sw,Y);
	
	triscFSM (
	sysclock,sysreset,Y[0],Y[1],Y[2],Y[3],Y[4],Y[5],Y[6],Y[7],Y[8],Y[9],Y[10],
	C[0],C[1],C[2],C[3],C[4],C[7],C[8],C[9],C[5],C[10],C[11],C[12],C[13],C[14]
	);
	
endmodule
