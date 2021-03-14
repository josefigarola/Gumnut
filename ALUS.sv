module ALUS (
	input logic [7:0] A,
	input logic [2:0] Cnt,
	input logic [1:0] S, //agarramos YZ para las operaciones
	output logic [7:0] OUT,
	output logic Co
	);
	
	//mux4to1
	always_comb begin //checar operaciones
		case (S)
			2'b00: {Co,OUT} = {1'b0,A} << Cnt; //A[7] ? ({A[6:0],A[7]}) : ({A[6:0],~A[7]}); //shift izquierda <<
			2'b01: {OUT,Co} = {A,1'b0} >> Cnt; //A[0] ? ({A[0],A[7:1]}) : ({~A[0],A[7:1]}); //shift derecha >>
			2'b10: begin
							OUT = (A << Cnt) | (A >> (8 - Cnt) );
							Co = OUT[0];
						end
			2'b11: begin
							OUT = (A >> Cnt) | (A << (8 - Cnt) );
							Co = OUT[7];
						end
			default: {Co,OUT} = {1'b0,A} << Cnt;
		endcase
	end

endmodule 