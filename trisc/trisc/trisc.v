module trisc (

input Start, Mode, ClockIn, SysClock, ClearAddGen, RW,  //Mode = SW9, ClockIn = Key2, ClearAddGen = Key3, RW = Key5 
input [7:0]    DataIn,    //DataIn = {SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0} 


output [6:0] PC, MAR,
output [14:0] MDOut, MDIn,
output [3:0] IRout,
output [0:14] C
);

  
wire [3:0]  AddIn, AddGen, AQ, Acc2Alu, Alu2Br, Br2Acc; 
wire RAMin, RAMwrite, toggle; 
wire [7:0]  RAMdata,MDO, MDI,RAMadd; 




assign RAMadd = C[3] == 1'b0 ? MDO[3:0]: AQ ;  
assign AddIn = Mode == 1'b0 ? RAMadd : AddGen; //for MAR
assign RAMin = Mode == 1'b0 ? SysClock*C[4] : ClockIn; 
assign RAMdata = Mode == 1'b0 ? MDI : DataIn; //For MDIn
assign RAMwrite = Mode == 1'b0 ? C[5] : ~RW; 
assign Acc2Alu = MDI[3:0];  
  
  
IR InstructionReg
(
	.D(MDO[7:4]) ,	// input [N-1:0] D_sig
	.CLK(~C[7]) ,	// input  CLK_sig
	.CLR(Start) ,	// input  CLR_sig
	.Q(IRout) 	// output [N-1:0] Q_sig
);

triscPCU triscPCU_inst
(
	.sysclock(~SysClock) ,	// input  sysclock_sig
	.sysreset(Start) ,	// input  sysreset_sig
	.Sw(IRout) ,	// input [0:3] Sw_sig
	.C(C) 	// output [0:14] C_sig
);


nbitbinary ProgramCounter
(
	.COUNT(~C[2]) ,	// input  COUNT_sig
	.CLEAR(~C[0]) ,	// input  CLEAR_sig
	.LOAD(~C[1]) ,	// input  LOAD_sig
	.in(MDO[3:0]) ,	// input [N-1:0] in_sig
	.y(AQ) 	// output [N-1:0] y_sig
);

acc acc_inst
(
	.clear(~C[8]) ,	// input  clear_sig
	.load(~C[11]) ,	// input  load_sig
	.inc(~C[9]) ,	// input  inc_sig
	.AB(~C[10]) ,	// input  AB_sig
	.A(MDO[3:0]) ,	// input [3:0] A_sig
	.B(Br2Acc) ,	// input [3:0] B_sig
	.Z(MDI[3:0]) 	// output [3:0] Z_sig
);

IR BufferReg
(
	.D(Alu2Br) ,	// input [N-1:0] D_sig
	.CLK(~C[14]) ,	// input  CLK_sig
	.CLR(Start) ,	// input  CLR_sig
	.Q(Br2Acc) 	// output [N-1:0] Q_sig
);


alu alu_inst
(
	.A(MDI[3:0]) ,	// input [3:0] A_sig
	.B(MDO[3:0]) ,	// input [3:0] B_sig
	.S(C[12:13]) ,	// input [1:0] S_sig
	.R(Alu2Br) 	// output [3:0] R_sig
);



  
  
OnOffToggle DivideX2 
( 
	 .OnOff(ClockIn) ,   // input  OnOff_sig 
	 .IN(1'b1) ,    // input  IN_sig 
	 .OUT(toggle)     // output  OUT_sig 
);
 
BinUp AddressGen 
( 
	 .inc(toggle) ,    // input  inc_sig 
	 .clear(ClearAddGen) ,   // input  clear_sig 
	 .load(1'b1) ,    // input  load_sig 
	 .D(4'b0) ,    // input  [N-1:0] D_sig 
	 .Q(AddGen)     // output [N-1:0] Q_sig 
); 


triscRAM RAM 
( 
	 .address ( AddIn ), 
	 .clock ( ~RAMin ), 
	 .data ( RAMdata ), 
	 .wren ( RAMwrite ), 
	 .q ( MDO ) 
); 




binary2seven (AQ, PC);  //  PC (HEX5)
binary2seven (AddIn, MAR);  //  MAR (HEX4)??
binary2seven (MDO[7:4], MDOut[14:8]);  //  MDOut (HEX3)
binary2seven (MDO[3:0], MDOut[6:0]);  //  MDOut (HEX2)
binary2seven (RAMdata[7:4],  MDIn[14:8]);  //  MDOIn (HEX0)
binary2seven (RAMdata[3:0],  MDIn[6:0]);  //  MDOIn (HEX1)



endmodule
