module NewPC(
	input logic [3:0]PCoper_i, //enable
	input logic carry_i,
	input logic zero_i,
	input logic [11:0]ISRaddr_i, //te de manzanilla => intreg
	input logic [11:0]stackaddr_i, //stk_addr
	input logic [7:0]offset_i, //disp_e
	input logic [11:0]addr_i, //jmp_addr =>addr_e
	input logic [11:0]PC_i, //current pc
	output logic [11:0]Npc_o
	);
	
	//cases control unit => pcoper
	always_comb begin
		case(PCoper_i)
			4'b0000:	Npc_o = PC_i + 1;
			4'b0100: Npc_o = (zero_i) ? (PC_i + offset_i) : (PC_i + 1);
			4'b0101: Npc_o = (!zero_i) ? (PC_i + offset_i) : (PC_i + 1);
			4'b0110:	Npc_o = (carry_i) ? (PC_i + offset_i) : (PC_i + 1);
			4'b0111: Npc_o = (!carry_i) ? (PC_i + offset_i) : (PC_i + 1);
			4'b1000:	Npc_o = addr_i;
			4'b1100:	Npc_o = ISRaddr_i;
			4'b1010:	Npc_o = stackaddr_i;
			default:	Npc_o = 12'hxx;
		endcase
	end

	//sign ext		
	//mux2to1
	//dispi con stk y el sel es pcop[1]
	
	//mux4to1 s=pcop[3:2]
	//D=adrri C=mux2to1 B=pc+mux2to1(1 | signext)s=pc[2]&taken A=B
	
	//modulo branch taken 
	//inputs: pcop[1:0],zero,carry
	//logic?
	//counter
	//output: taken
endmodule 