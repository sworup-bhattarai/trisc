module triscCPU
(

	input Reset, SysClock, Mode, ClockIn, ClearAddGen, RW, //Mode = SW9, ClockIn = Key2, ClearAddGen = Key3, RW = Key5
	input [7:0] DataIn, //DataIn = {SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0}
	
	output [0:14] C,
	output [14:0] MDIout, MDOout,
	output [6:0] PC, MAR


);


	wire [3:0] AddIn, AddGen, AddBus, IRin, ACCbits, Buffer, ALUbits;
	wire RAMin, RAMwrite, toggle;
	wire [7:0] RAMdata, RAMadd, MDO, MDI;


	assign RAMadd = C[3] == 1'b0 ? MDO[3:0] : AddBus ;
	assign AddIn = Mode == 1'b0 ? RAMadd : AddGen;
	assign RAMin = Mode == 1'b0 ? SysClock*C[4] : ClockIn;
	assign RAMdata = Mode == 1'b0 ? MDI : DataIn;
	assign RAMwrite = Mode == 1'b0 ? C[5] : ~RW;	
	
IR InstructionRegester
(
	.D(MDO[7:4]) ,	// input [N-1:0] D_sig
	.CLK(~C[7]) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(IRin) 	// output [N-1:0] Q_sig
);	
	
triscPCU PCU
(
	.SysClock(~SysClock) ,	// input  SysClock_sig
	.SysReset(Reset) ,	// input  SysReset_sig
	.Switch(IRin) ,	// input [0:3] Switch_sig
	.C(C) 	// output [0:14] C_sig
);	
	
nbitbinary ProgramCounter
(
	.COUNT(~C[2]) ,	// input  COUNT_sig
	.CLEAR(~C[0]) ,	// input  CLEAR_sig
	.LOAD(~C[1]) ,	// input  LOAD_sig
	.in(MDO[3:0]) ,	// input [N-1:0] in_sig
	.y(AddBus) 	// output [N-1:0] y_sig
);


acc Accumulator
(
	.clear(~C[8]) ,	// input  clear_sig
	.load(~C[11]) ,	// input  load_sig
	.inc(~C[9]) ,	// input  inc_sig
	.AB(C[10]) ,	// input  AB_sig
	.A(MDO[3:0]) ,	// input [N-1:0] A_sig
	.B(Buffer) ,	// input [N-1:0] B_sig
	.Z(MDI[3:0]) 	// output [N-1:0] Z_sig
);	
	
IR BufferRegester
(
	.D(ALUbits) ,	// input [N-1:0] D_sig
	.CLK(~C[14]) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(Buffer) 	// output [N-1:0] Q_sig
);	
	
alu ArithmeticLogicUnit
(
	.A(MDI[3:0]) ,	// input [3:0] A_sig
	.B(MDO[3:0]) ,	// input [3:0] B_sig
	.S({C[13],C[12]}) ,	// input [1:0] S_sig
	.R(ALUbits) 	// output [3:0] R_sig
);	
	
	
binary2seven (AddBus, PC);  //  PC (HEX5)
binary2seven (AddIn, MAR);  //  MAR (HEX4)??
binary2seven (MDO[7:4], MDOout[14:8]);  //  MDOut (HEX3)
binary2seven (MDO[3:0], MDOout[6:0]);  //  MDOut (HEX2)
binary2seven (RAMdata[7:4],  MDIout[14:8]);  //  MDOIn (HEX0)
binary2seven (RAMdata[3:0],  MDIout[6:0]);  //  MDOIn (HEX1)	
	
	
	
	
	
OnOffToggle DivideX2
(
	.OnOff(ClockIn) , // input OnOff_sig
	.IN(1'b1) , // input IN_sig
	.OUT(toggle) // output OUT_sig
);


BinUp AddressGen
(
	.inc(toggle) , // input inc_sig
	.clear(ClearAddGen) , // input clear_sig
	.load(1'b1) , // input load_sig
	.D(4'b0) , // input [N-1:0] D_sig
	.Q(AddGen) // output [N-1:0] Q_sig	
);


triscRAM RAM
(
	.address ( AddIn ),
	.clock ( ~RAMin ),
	.data ( RAMdata ),
	.wren ( RAMwrite ),
	.q ( MDO )
);


endmodule
