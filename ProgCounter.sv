module ProgCounter(
	input logic clk,
	input logic cen,
	input logic rst,
	input logic we,
	input logic [11:0]PC_i,
	output logic [11:0]PC_o
	);
	
	logic clkg;
	
	always_comb clkg = clk & cen;
	
	//Register w/clear and enable
	always_ff @(posedge clkg) begin
		if(rst)
			PC_o <= 0;
		else if(we)
			PC_o <= PC_i;
	end

endmodule 