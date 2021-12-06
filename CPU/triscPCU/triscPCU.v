module triscPCU
(
	input SysClock,SysReset,
	input [0:3]Switch,	// 1000
	output [0:14] C,
	output clock, reset, 
	output [0:3]Sout
);
	wire [0:15] Y;
	assign Sout = Switch;
	assign clock = SysClock;
	assign reset = SysReset;
	
	fourtosixteen(Switch,Y);
	
	triscFSM FSM(
	SysClock,SysReset,Y[0],Y[1],Y[2],Y[3],Y[4],Y[5],Y[6],Y[7],Y[8],Y[9],Y[10],
	C[0],C[1],C[2],C[3],C[4],C[7],C[8],C[9],C[5],C[10],C[11],C[12],C[13],C[14] );
	
endmodule
