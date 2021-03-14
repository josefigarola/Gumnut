module ALU (
	input logic [7:0] rs_i, //A
	input logic [7:0] op2_i, //B
	input logic [3:0] ALUOp_i, //ctrl wxyz
	input logic [2:0] count_i,
	input logic carry_i,
	output logic [7:0] res_o, //res_o
	//banderas
	output logic carry_o, Ov, Ng, zero_o //1 bit
	);
	//cables auxiliares de las banderas
	logic ov,co_a,co_s;
	//salidas alus
	logic [7:0] exa, exl,exs;
	
	ALUA Alua ( .A(rs_i), .B(op2_i), .X(ALUOp_i[1]), .Y(ALUOp_i[0]), .cin(carry_i), .OUT(exa), .Co(co_a), .Ov(ov) );
	ALUL Alul ( .A(rs_i), .B(op2_i), .S({ALUOp_i[1],ALUOp_i[0]}), .OUT(exl) );
	ALUS Alus ( .A(rs_i), .Cnt(count_i), .S({ALUOp_i[1],ALUOp_i[0]}), .OUT(exs), .Co(co_s) );
	
	//asignar el resultado
	always_comb res_o = ALUOp_i[3] ? exs :
													ALUOp_i[2] ? exl : exa;
													
	//confirmar el carry out y el overflow en las tres alus
	always_comb carry_o = (ALUOp_i[3] ? co_s : co_a) & ~ALUOp_i[2] ; //si es logica no hay carry
	always_comb Ov = (ALUOp_i[3] | ALUOp_i[2]) ? 0 : ov; //no hay overflow en operaciones logicas y shifts 
	//estas banderas funcionan desde la alu
	always_comb Ng = res_o[7]; //1 bit
	always_comb zero_o = (8'd0 == res_o); //comparamos 0 con salida final se puede con nor ~|
	
endmodule 