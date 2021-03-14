module flagreg(
	input logic clk,
	input logic cen,
	input logic rst,
	input logic we,
	input logic iwe,
	input logic intz_i,
	input logic intc_i,
	input logic c_i,
	input logic z_i,
	output logic c_o,
	output logic z_o
	);
	//wires
	logic c;
	logic z;
	logic clkg;
	
	always_comb clkg = clk & cen;
	//mux2to1 carry
	always_comb c = we ? c_i :
									iwe ? intc_i : 0;
	//mux2to1 zero
	always_comb z = we ? z_i :
									iwe ? intz_i : 0;
	//flip flop carry
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if (rst)
			c_o <= 0; //esta bien
		else if(we|iwe) //guardamos al siguiente ciclo de reloj si el enable esta activado
			c_o <= c;
	end

	//flip flop zero
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if (rst)
			z_o <= 0; //esta bien
		else if(we|iwe) //guardamos al siguiente ciclo de reloj si el enable esta activado
			z_o <= z;
	end
	
endmodule 