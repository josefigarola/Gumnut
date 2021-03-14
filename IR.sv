module IR(
	//input
	input logic clk,
	input logic cen,
	input logic rst,
	input logic [17:0]inst_i,
	input logic ack_i, //enable data
	//output
	output logic [6:0]op_o,
	output logic [2:0]func_o,
	output logic [11:0]addr_o,
	output logic [7:0]disp_o,
	output logic [2:0]rs_o,
	output logic [2:0]rs2_o,
	output logic [2:0]rd_o,
	output logic [7:0]immed_o,
	output logic [2:0]count_o
	);
	
	//distribuir salidas con la entrada de 18b
	logic [17:0] IR;
	logic [17:0] nxt_IR;
	
	logic clkg;
	always_comb clkg = clk & cen;
	always_comb nxt_IR = ack_i ? inst_i : IR;
	
	always_ff @(posedge  clkg)
		IR <= (rst) ? 0 : nxt_IR;
	
	always_comb begin
		op_o = IR[17:11];
		func_o = IR[2:0];
		addr_o = IR[11:0]; 
		disp_o = IR[7:0];
		rs_o = IR[10:8];
		rs2_o = IR[7:5];
		rd_o = IR[13:11];
		immed_o = IR[7:0]; 
		count_o = IR[7:5];
	end


endmodule 
	
	