module Procesing_Unit (
	//inputs los mismos para los bloques
	input logic clk, //clk_i
	input logic cen,	//clk_en
	input logic rst,	//rst_i
	//chido
	input logic [17:0] inst_dat_i,
	//no se sabe
	input logic [7:0] data_dat_i,
	input logic [7:0] port_data_i,
	input logic ack_i, //enable
	//control unit inputs
		//muxes y flip flop
	input logic StmMux_c,
	input logic [1:0] RegMux_c,
	input logic RegWrt_c,
	input logic op2_c,
	//intreg inputs
	input logic intc_i,
	input logic intz_i,
		//control unit enables
	input logic port_we_c,
	input logic ALUEn_c,
	input logic reti_c,
	input logic ALUFR_c,
		//wxyz
	input logic [3:0] ALUOp_c,
	//IR output
	output logic [6:0] op_e,
	output logic [2:0] func_e,
	output logic [11:0] addr_e,
	output logic [7:0] disp_e,
	//register output
	output logic [7:0] port_data_o,
	output logic port_we_o,
	//Alu output and flags
	output logic [7:0] ALU_e,
		//flag outs
	output logic c_e,
	output logic z_e
	);
	
	//wires
	//inputs
	logic [7:0]data_dat;
	logic [7:0]port_dat;
	//IR
	logic [2:0] rs_e;
	logic [2:0] rs2_e;
	logic [2:0] rd_e;
	logic [2:0] rsd2_e;
	logic [7:0] immed_e;
	logic [2:0] count_e;
	//mux4to1
	logic [7:0] dat_e;
	//Register
	logic [7:0] Rs_e;
   logic [7:0] Rs2_e;
	//mux2to1
	logic [7:0] op2_e;
	//alu
	logic [7:0]alu_e;
	logic zero_e;
   logic carry_e;
	//no se usan pero las dejamos csm
	logic neg,ovr; 
	
	//clk div
	logic clkg;
	
	always_comb clkg = clk & cen;
	//assignments
	//inputs
	//flip flops data_dat
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if(rst)
			data_dat <= 0;
		else //guardamos al siguiente ciclo de reloj si el enable esta activado
			data_dat <= data_dat_i;
	end
	//flip flop port_dat
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if(rst)
			port_dat <= 0;
		else //guardamos al siguiente ciclo de reloj si el enable esta activado
			port_dat <= port_data_i;
	end
	//IR 
	IR ir ( .clk(clk),
			  .cen(cen),
			  .rst(rst),
			  .inst_i(inst_dat_i),
			  .ack_i(ack_i),
			  .op_o(op_e), 
			  .func_o(func_e),
			  .addr_o(addr_e), 
			  .disp_o(disp_e), 
			  .rs_o(rs_e),
			  .rs2_o(rs2_e),
			  .rd_o(rd_e),
			  .immed_o(immed_e),
			  .count_o(count_e)
			  );
	//mux2to1 rs2 y rd
	always_comb rsd2_e = StmMux_c ? rs2_e : rd_e;
	//mux4to1 4a1 ya quedo
	always_comb begin 
		case (RegMux_c)
			2'b00: dat_e = ALU_e; //a
			2'b01: dat_e = data_dat; //b
			2'b10: dat_e = port_dat; //c
			2'b11: dat_e = 'x; //no importa
			default: dat_e = 'x;
		endcase
	end
	//Registers ya quedo
	regbank_gunmut registers ( .clk(clk),
										.cen(cen),
										.rst(rst),
										.rs_i(rs_e),
										.rs2_i(rsd2_e),
										.rd_i(rd_e),
										.dat_i(dat_e),
										.we(RegWrt_c),
										//outputs
										.Rs_o(Rs_e),
										.Rs2_o(Rs2_e)
										);
										
	//mux2to1 ya quedo
	always_comb op2_e = op2_c ? Rs2_e : immed_e;
	//flagreg
	flagreg flags ( .clk(clk),
						 .cen(cen),
		 				 .rst(rst),
						 .we(ALUFR_c),
						 .iwe(reti_c),
						 .intz_i(intz_i),
						 .intc_i(intc_i),
						 .c_i(carry_e),
						 .z_i(zero_e),
						 .c_o(c_e),
						 .z_o(z_e)
						 );
						 
	//ALU
	ALU alu ( .rs_i(Rs_e),
				 .op2_i(op2_e), 
				 .ALUOp_i(ALUOp_c), 
				 .count_i(count_e), 
				 .carry_i(c_e), 
				 .res_o(alu_e),
				 .zero_o(zero_e),
				 .carry_o(carry_e)
				 //checar las otras dos banderas
				 );
				 
	//flip flop res_o
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if(rst)
			ALU_e <= 0;
		else if(ALUEn_c) //guardamos al siguiente ciclo de reloj si el enable esta activado
			ALU_e <= alu_e;
	end
	
	//flip flop port_data_o
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if(rst)
			port_data_o <= 0;
		else if(port_we_c) //guardamos al siguiente ciclo de reloj si el enable esta activo
			port_data_o <= Rs2_e;
	end
	
	//flip flop port_we_o
	always_ff @(posedge clkg or posedge rst) begin //guardar el carry de la operacion anterior
		if(rst)
			port_we_o <= 0;
		else //guardamos al siguiente ciclo de reloj
			port_we_o <= port_we_c;
	end
	
				 
endmodule 
	
	