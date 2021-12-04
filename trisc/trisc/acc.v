module acc  
( 
 input clear, load, inc, AB, //declare control inputs 
 input [3:0] A, B,  //declare data inputs 
 output [3:0] Z    //declare output 
); 
 wire [3:0] D;  //declare internal nodes 
 
//instantiate component modules 
two2one #(4) two2oneMUX 
( 
 .A(A) ,     // data input [3:0] A 
 .B(B) ,    // data input [3:0] B 
 .S(AB) ,    // select input  AB.  AB=0 selects A, AB=1 selects B. 
 .Y(D)     // data output [3:0] D 
); 
BinUp  #(4) RegCount 
( 
 .inc(inc) ,   // control input  inc 
 .clear(clear) ,   // input  clear 
 .load(load) ,   // input  load 
 .D(D) ,     // data input from MUX [3:0] D 
 .Q(Z)     // data output from Acc [3:0] Z 
); 
endmodule 