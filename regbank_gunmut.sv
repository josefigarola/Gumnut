module regbank_gunmut(
	input logic clk,
	input logic cen,
	input logic rst,
	input logic [2:0] rs_i,
	input logic [2:0] rs2_i,
	
	input logic [2:0] rd_i,
	input logic [7:0] dat_i,
	input logic we,
	
	output logic [7:0] Rs_o,
	output logic [7:0] Rs2_o
);
	
	integer i;
	
	logic [7:0] mem [7:0];
	logic clkg;
	
	always_comb clkg = clk & cen;
	//flip flop 
	always_ff @(posedge clkg or posedge rst) begin
		if (rst)
			for (i=0; i<=7; i = i+1)
				mem[i] <= 0;
			else if (we)
				mem[rd_i] <= dat_i;
	end
	//mux2to1
	always_ff @(posedge clkg)begin
		Rs_o <= mem[rs_i];
		Rs2_o <= mem[rs2_i];
	end
	//ya quedo este bloque
endmodule 