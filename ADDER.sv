module ADDER (
	input logic[7:0] IA,
	input logic[7:0] IB,
	input logic Cin, 
	output logic [7:0] Sum, 
	output logic Cout, //1bit checar cuando es borrow o sea negar el carry 
	output logic Ov
	);
	
	
	always_comb {Cout,Sum} = IA + IB + Cin;
	always_comb Ov = ( (!IA[7]&!IB[7]&Sum[7]) | (IA[7]&IB[7]&!Sum[7]) );//1bit
	
endmodule 