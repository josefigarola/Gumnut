module PCUnit (
	input logic clk, //clk_i
	input logic cen,	//clk_en
	input logic rst,	//rst_i
	//punit inputs
	input logic z_e, 
	input logic c_e, 
	input logic [11:0]addr_e,
	input logic [7:0]disp_e,
	//control unit input
		//intreg input
	input logic int_c,//we
		//stack input
	input logic pop_c,//pop_i
	input logic push_c,//push_i
		//progcounter
	input logic PCEn_c,
		//ctrl unit
	input logic [3:0]PCoper_c,
	//output
	output logic [11:0]PC_e, //inst_adr_o & PC_e
		//intreg outputs
	output logic intc_e,
	output logic intz_e
	);
	
	//intreg out wire
	logic [11:0]int_e;
	//stack out wire
	logic [11:0]stk_e;
	//newpc out wire
	logic [11:0]PCnew_e;
	
	//assignments
	//IntReg
	IntReg intreg ( .clk(clk),
						 .cen(cen),
						 .rst(rst),
						 .we(int_c),
						 .pc_i(PC_e),
						 .zero_i(z_e),
						 .carry_i(c_e),
						 .ipc_o(int_e),
						 .intc_o(intc_e),
						 .intz_o(intz_e)
						 );
						 
	//Stack
	Stack stack ( .clk(clk),
					  .cen(cen),
					  .rst(rst),
					  .pop_i(pop_c),
					  .push_i(push_c),
					  .pc_i(PC_e),
					  .spc_o(stk_e)
					  );
			
	//NewPC
	NewPC newpc ( .PCoper_i(PCoper_c),
					  .carry_i(c_e),
					  .zero_i(z_e),
					  .ISRaddr_i(int_e),
					  .stackaddr_i(stk_e),
					  .offset_i(disp_e),
					  .addr_i(addr_e),
					  .PC_i(PC_e),
					  .Npc_o(PCnew_e)
					  );
					 
	//ProgCounter
	ProgCounter counter ( .clk(clk),
								 .cen(cen),
								 .rst(rst),
								 .we(PCEn_c),
								 .PC_i(PCnew_e),
								 .PC_o(PC_e)
								 );
								 
endmodule 