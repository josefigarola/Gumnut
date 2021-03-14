module data_mem ( 
	input logic clk,
	input logic cen,
   input logic cyc_i,
   input logic stb_i,
   input logic we_i,
   output logic ack_o,
   input logic [7:0]adr_i,
   input logic [7:0]dat_i,
   output logic [7:0]dat_o 
);

   logic [7:0] DMem [0:255]; //?
 
   logic read_ack;
	logic clkg;
	always_comb clkg = clk & cen;
  initial $readmemh("gasm_data.dat", DMem);

  always_ff @(posedge clkg)
    if (cyc_i && stb_i)
      if (we_i) begin
        DMem[adr_i] <= dat_i;
        dat_o <= dat_i;
        read_ack <= 1'b0;
      end
      else begin
        dat_o <= DMem[adr_i];
        read_ack <= 1'b1;
      end
    else
      read_ack <= 1'b0;

  always_comb ack_o = cyc_i & stb_i & (we_i | read_ack);

endmodule 