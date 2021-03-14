module ALUA (
	//inputs
	input logic [7:0] A,
	input logic [7:0] B,
	input logic X, //y
	input logic Y, //z
	input logic cin,
	output logic [7:0] OUT,
	//banderas
	output logic Co,
	output logic Ov
	);
	//cables
	logic [7:0] eA,eB;
	logic ecin;	
	
	ALUEXT EXT ( .A(A), .B(B), .S({X,Y}), .cin(cin), .OPA(eA), .OPB(eB), .C(ecin) );
	ADDER add ( .IA(eA), .IB(eB), .Cin(ecin), .Sum(OUT), .Cout(Co), .Ov(Ov) );
	
	
endmodule 