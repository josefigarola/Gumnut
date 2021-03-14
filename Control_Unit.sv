module Control_Unit(
	input logic clk,
	input logic cen,
	input logic rst,
	input logic ack_i, //int_ack_i
		//processing unit outs
	input logic [6:0]op_i,
	input logic [2:0]func_i,
		//data mem out
	input logic data_ack_i,
		//interrupt
	input logic int_req,
	//outputs
		//enables processing unit
	output logic op2_o,
	output logic [3:0]ALUOp_o,
	output logic ALUFR_o, //enable flags
	output logic ALUEn_o, //enable res alu
	output logic RegWtr_o,
	output logic [1:0]RegMux_o,
		//PCUnit enables
	output logic PCEn_o,
	output logic [3:0]PCoper_o,
	output logic ret_o, //pop
	output logic jsb_o, //push
	output logic StmMux_o,
	output logic reti_o,
	output logic int_o,
		//int MEM
	output logic stb_o,
	output logic cyc_o,
		//enable core output
	output logic port_we_o,
		//Data mem ints
	output logic data_we_o,
	output logic data_stb_o,
	output logic data_cyc_o,
	output logic int_ack
	);
	
	//STATES
	parameter FETCH = 3'b000;
	parameter DECODE = 3'b001;
	parameter INT = 3'b010;
	parameter EXECUTE = 3'b011;
	parameter MEM = 3'b100;
	parameter WRITEBACK = 3'b101;
	
	//instructions
	parameter memory = 2'b10;
	parameter shift = 3'b110;
	parameter arithmetic = 4'b1110;
	parameter jump = 5'b11110;
	parameter branch = 6'b111110;
	parameter misc = 7'b1111110;
	
	//miscellaneous instruction
	parameter wt = 3'b100; //wait
	parameter stby = 3'b100;
	
	//memory and input instructions
	parameter ldm = 2'b00;
	parameter stm = 2'b01;
	parameter inp = 2'b10;
	parameter out = 2'b11;
	//wires
	logic [2:0]STATE;
	logic [2:0]NXT_STATE;
	logic clkg;
	
	always_comb clkg = clk & cen;
	always_ff @(posedge clkg) begin
		if(rst) STATE <= FETCH;
		else STATE <= NXT_STATE;
	end
	//STATE LOGICS
	always_comb begin
		case(STATE)
			FETCH: NXT_STATE = ack_i ? DECODE : FETCH;
			DECODE: if(int_req & ((op_i[6:1]==branch) | (op_i[6:2]==jump) | (op_i==misc))) NXT_STATE = INT;
					  else if(!int_req & ((op_i[6:1]==branch) | (op_i[6:2]==jump) | ((op_i==misc) & (func_i==wt) | (func_i==stby)))) NXT_STATE = FETCH;
					  else if((op_i==misc) & (func_i==wt) | (func_i==stby)) NXT_STATE = DECODE;
					  else NXT_STATE = EXECUTE;
			INT: NXT_STATE = FETCH;
			EXECUTE: if((op_i[6:5]==memory) & (func_i==stm) & data_ack_i & int_req) NXT_STATE = INT;
						else if((op_i[6:5]==memory) & (func_i==stm) & data_ack_i & !int_req) NXT_STATE = FETCH;
						else if((op_i[6:5]==memory) & (func_i==ldm) | (func_i==stm) & !data_ack_i) NXT_STATE = MEM;
						else NXT_STATE = WRITEBACK;
			MEM: if((func_i==stm) & data_ack_i & int_req) NXT_STATE = INT;
				  else if((func_i==stm) & data_ack_i & !int_req) NXT_STATE = FETCH;
				  else if(func_i==ldm & data_ack_i) NXT_STATE = WRITEBACK;
				  else NXT_STATE = MEM;
			WRITEBACK: NXT_STATE = int_req ? INT : FETCH;
			default: NXT_STATE = FETCH;
		endcase
	end
	//asignar salidas cuando sepamos donde se activan
	always_comb begin
			//punit enables
		  op2_o = STATE == EXECUTE ? 1 : 0;
		  if(op_i[6:4]!=shift & op_i[6:5]!=memory & op_i[6:1]!=branch & op_i[6:2]!=jump)
			if(func_i == 3'b000 | func_i == 3'b001) ALUOp_o = 4'b0001;//add
			else if(func_i == 3'b010 | func_i == 3'b011) ALUOp_o = 4'b0011;//sub
			else if(func_i == 3'b100) ALUOp_o = 4'b0010;//and
			else if(func_i == 3'b101) ALUOp_o = 4'b0011;//or
			else if(func_i == 3'b110) ALUOp_o = 4'b0100;//xor
			else if(func_i == 3'b111) ALUOp_o = 4'b0101;//mask
			else ALUOp_o = 4'bxxxx;
		  else ALUOp_o = 0;
		  ALUFR_o = STATE == INT ? 1 : 0;
		  ALUEn_o = STATE == EXECUTE ? 1 : 0;
		  RegWtr_o = STATE == EXECUTE ? 1 : 0;
		  if(op_i[6:5]==memory & (func_i == 3'b00 | func_i == 3'b01)) RegMux_o = 2'b01;
		  else if(op_i[6:5]==memory & (func_i == 3'b10 | func_i == 3'b11)) RegMux_o = 2'b10;
		  else RegMux_o = 2'b00;
			//PCUnit enables
		  PCEn_o = STATE==WRITEBACK ? 1 : 0;
		  if(STATE == MEM)
				PCoper_o = 4'b0000;
		  else
			if(op_i[6:1]==branch & func_i == 3'b00) PCoper_o = 4'b0100;
			else if(op_i[6:1]==branch & func_i == 3'b01) PCoper_o = 4'b0101;
			else if(op_i[6:1]==branch & func_i == 3'b10) PCoper_o = 4'b0110;
			else if(op_i[6:1]==branch & func_i == 3'b11) PCoper_o = 4'b0111;
			else if(op_i[6:2]==jump) PCoper_o = 4'b1000;
			else PCoper_o = 4'b0000;
		  ret_o = (STATE==FETCH | STATE==INT) ? 1 : 0; //no importan
		  jsb_o = (STATE==FETCH | STATE==INT) ? 1 : 0; //no tiene nada escrito el stack
		  StmMux_o = STATE==FETCH ? 1 : 0;
		  reti_o = STATE == INT ? 1 : 0;
		  int_o = STATE==FETCH ? 1 : 0;
			//int mem
		  stb_o = (STATE==FETCH | STATE==INT) ? 1 : 0;
		  cyc_o = (STATE==FETCH | STATE==INT) ? 1 : 0;
			//enable core out
		  port_we_o = STATE == EXECUTE ? 1 : 0;
			//Data mem ints
		  data_we_o = (STATE == FETCH | STATE==MEM) ? 1 : 0;
		  data_stb_o = (STATE == FETCH | STATE==MEM) ? 1 : 0;
		  data_cyc_o = (STATE == FETCH | STATE==MEM) ? 1 : 0;
		  int_ack = STATE== EXECUTE ? 1 : 0;
		end
endmodule 