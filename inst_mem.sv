module inst_mem ( 
	input logic  clk,
   input logic cyc_i,
   input logic stb_i,
   output logic ack_o,
   input logic [11:0]adr_i,
   output logic [17:0]dat_o 
	);

  logic [17:0] IMem [0:4095]; //?

  initial $readmemh("gasm_text.dat", IMem);

  always_comb dat_o = IMem[adr_i];

  always_comb ack_o = cyc_i & stb_i;

endmodule
