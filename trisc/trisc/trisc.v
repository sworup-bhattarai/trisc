module trisc (

input Start, Mode, ClockIn, SysClock, ClearAddGen, RW,  //Mode = SW9, ClockIn = Key2, ClearAddGen = Key3, RW = Key5 
input [7:0]    DataIn,    //DataIn = {SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0} 


output [6:0] PC, MAR,
output [15:0] MDOut, MDIn,
output [0:14] C
);

  
wire [3:0]  AddIn, AddGen, RAMadd; 
wire [3:0]  Acc2Alu, Alu2Br, Br2Acc;
wire RAMin, RAMwrite, toggle; 
wire [7:0]  RAMdata; 
wire [3:0] IRout;
wire [7:0] MDO, MDI;
wire [3:0] AQ;


assign RAMadd = C[3] == 1'b0 ? MDO[3:0] : AQ;  
assign AddIn = Mode == 1'b0 ? RAMadd : AddGen; //for MAR
assign RAMin = Mode == 1'b0 ? SysClock*C[4] : ClockIn; 
assign RAMdata = Mode == 1'b0 ? MDI : DataIn; //For MDIn
assign RAMwrite = Mode == 1'b0 ? C[5] : ~RW; 
  
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




IR IR(MDO[7:4],/*~*/C[7], ~Start, IRout);
	
triscPCU(SysClock,Start, IRout, C);

acc( ~C[8], ~C[11], ~C[9], C[10], MDO, Br2Acc, MDI[3:0]); 

IR BR(Alu2Br,C[14], ~Start, Br2Acc);

alu (MDO[3:0], MDI[3:0], {C[12],C[13]}, Alu2Br);

BinUp(~C[2], ~C[0], ~C[1], MDO[7:4], AQ); //PC




binary2seven  ( AQ, PC);  //  PC (HEX5)
binary2seven  ( AddIn, MAR);  //  MAR (HEX4)??
binary2seven  ( MDO[7:4], MDOut[14:8]);  //  MDOut (HEX3)
binary2seven  ( MDO[3:0], MDOut[6:0]);  //  MDOut (HEX2)
binary2seven  ( RAMdata[7:4],  MDIn[14:8]);  //  MDOIn (HEX0)
binary2seven  ( RAMdata[3:0],  MDIn[6:0]);  //  MDOIn (HEX1)



endmodule
