module ALUEXT (
	input logic [7:0] A,
	input logic [7:0] B,
	input logic [1:0] S,
	input logic cin,
	output logic [7:0] OPA,
	output logic [7:0] OPB,
	output logic C
	);
	
	//mux4to1 bitwise B
	always_comb begin
		case (S)				
			2'b00: OPB = B;
			2'b01: OPB = B;
			2'b10: OPB = ~B;
			2'b11: OPB = ~B;
			default: OPB = B;
		endcase
	end
	
	//mux4to1 
	always_comb begin
		case (S)				
			2'b00: C = 1'b0;	//A+B
			2'b01: C = cin;	//A+B+cin
			2'b10: C = 1'b1;	//A-B =>  A+~B+1
			2'b11: C = ~cin;	//A-B-cin => A+~B+~cin
			default: C = cin;
		endcase
	end
	always_comb OPA = A; //in this case OPA doesn't change
	
endmodule 