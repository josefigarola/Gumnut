module ALUL (
	input logic [7:0] A,
	input logic [7:0] B,
	input logic [1:0] S, //yz
	output logic [7:0] OUT
	);
	
	//modificador de variables ALUEXT
	//mux4to1
	always_comb begin 
		case (S)
			2'b00: OUT = A&B; 
			2'b01: OUT = A|B;
			2'b10: OUT = A^B;
			2'b11: OUT = A & ~B;
			default: OUT = 8'bxx;
		endcase
	end

endmodule 