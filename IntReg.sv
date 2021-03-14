module IntReg (
	//de a egg globales
	input logic clk,
	input logic cen,
	input logic rst,
	input logic we,
	input logic [11:0]pc_i, //viene de progcounter
	//alu flags inputs
	input logic zero_i, //z_i
	input logic carry_i, //c_i
	//output
	output logic [11:0]ipc_o,
	output logic intc_o,
	output logic intz_o
	);
	
	logic clkg;
	always_comb clkg = clk & cen;
	
	//flip flop carry
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if (rst)
			intc_o <= 0; //esta bien
		else if(we) //guardamos al siguiente ciclo de reloj si el enable esta activado
			intc_o <= carry_i;
	end

	//flip flop zero
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if (rst)
			intz_o <= 0; //esta bien
		else if(we) //guardamos al siguiente ciclo de reloj si el enable esta activado
			intz_o <= zero_i;
	end
	
	//flip flop ipc_o
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if (rst)
			ipc_o <= 0; //esta bien
		else if(we) //guardamos al siguiente ciclo de reloj si el enable esta activado
			ipc_o <= pc_i;
	end

	
endmodule 
	