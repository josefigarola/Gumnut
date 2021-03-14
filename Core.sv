module Core(
	input logic clk,
	input logic cen, 
	input logic rst,
	//inst_mem
	input logic [17:0]inst_dat_i,
	input logic ack_i,
	//data_mem
	input logic [7:0]data_dat_i,
	input logic ack_o,
	//control unit enable
	input logic int_req,
	//outputs
		//alu
	output logic [7:0]ALU_e,
		//register
	output logic [7:0]port_data_o,
	output logic port_we_o,
		//control unit
	output logic data_we_o,
	output logic data_stb_o,
	output logic data_cyc_o,
	output logic int_ack_o,//salida? o regresa como enable
		//data & int MEM
	output logic stb_o,
	output logic cyc_o,
		//prog counter
	output logic [11:0]inst_addr_o
	);
	
	//wires
		//punit
	logic StmMux_c;
	logic port_we_c;
	logic [1:0]RegMux_c;
	logic RegWtr_c;
	logic op2_c;
	logic [3:0]ALUOp_c;
	logic ALUEn_c;
	logic ALUFR_c;
	logic reti_c;
	logic intc_e;
	logic intz_e;
	logic [6:0]op_e;
	logic [2:0]func_e;
	logic [11:0]addr_e;
	logic [7:0]disp_e;
		//pcunit
	logic c_e;
	logic z_e;
	logic push_c;
	logic pop_c;
	logic int_c;
	logic [3:0]PCoper_c;
	logic PCEn_c;
	
	//assignments
	Procesing_Unit punit ( .clk(clk),
								  .cen(cen),
								  .rst(rst),
								  .inst_dat_i(inst_dat_i),
								  .data_dat_i(data_dat_i),
								  .port_data_i(port_data_o),
								  .ack_i(ack_i),
								  .StmMux_c(StmMux_c),
								  .RegMux_c(RegMux_c),
								  .RegWrt_c(RegWtr_c),
								  .op2_c(op2_c),
									//intreg inputs
								  .intc_i(intc_e),
								  .intz_i(intz_e),
									//control unit enables
								  .port_we_c(port_we_c),
								  .ALUEn_c(ALUEn_c),
								  .reti_c(reti_c),
								  .ALUFR_c(ALUFR_c),
									//wxyz
								  .ALUOp_c(ALUOp_c),
									//IR output
								  .op_e(op_e),
								  .func_e(func_e),
								  .addr_e(addr_e),
								  .disp_e(disp_e),
									//register output
								  .port_data_o(port_data_o),
								  .port_we_o(port_we_o),
									//Alu output and flags
								  .ALU_e(ALU_e),
									//flag outs
								  .c_e(c_e),
								  .z_e(z_e)
								  );
	
	PCUnit pcunit ( .clk(clk), //clk_i
						  .cen(cen),	//clk_en
						  .rst(rst),	//rst_i
							//punit inputs
						  .z_e(z_e), 
						  .c_e(c_e), 
						  .addr_e(addr_e),
						  .disp_e(disp_e),
							//control unit input
							//intreg input
						  .int_c(int_c),//we
							//stack input
						  .pop_c(pop_c),//pop_i
						  .push_c(push_c),//push_i
							//progcounter
						  .PCEn_c(PCEn_c),
							//ctrl unit
						  .PCoper_c(PCoper_c),
							//output
						  .PC_e(inst_addr_o), //inst_adr_o & PC_e
							//intreg outputs
						  .intc_e(intc_e),
						  .intz_e(intz_e)
						  );
	
	Control_Unit CTRUnit ( .clk(clk),
								  .cen(cen),
								  .rst(rst),
								  .ack_i(ack_i),
									//processing unit outs
								  .op_i(op_e),
								  .func_i(func_e),
									//data mem out
								  .data_ack_i(ack_o),
										//no se sabe
								  .int_req(int_req),
									//outputs
										//enables processing unit
								  .op2_o(op2_c),
								  .ALUOp_o(ALUOp_c),
								  .ALUFR_o(ALUFR_c), //enable flags
							  	  .ALUEn_o(ALUEn_c), //enable res alu
							 	  .RegWtr_o(RegWtr_c),
								  .RegMux_o(RegMux_c),
									//PCUnit enables
							     .PCEn_o(PCEn_c),
								  .PCoper_o(PCoper_c),
								  .ret_o(pop_c), //pop
							  	  .jsb_o(push_c), //push
								  .StmMux_o(StmMux_c),
								  //data & int MEM
								  .reti_o(reti_c),
								  .int_o(int_c),
								  .stb_o(stb_o),
								  .cyc_o(cyc_o),
								  .port_we_o(port_we_c),
									//Data mem ints
							     .data_we_o(data_we_o),
								  .data_stb_o(data_stb_o),
								  .data_cyc_o(data_cyc_o),
								  .int_ack(int_ack_o)
								  );
								
endmodule 