module GumnutCore(
	input logic clk,
	input logic cen,
	input logic rst,
	input logic [7:0]data_dat_i,
	//crtl unit
	input logic int_req,
	//outputs
	output logic int_ack,
		//register
	output logic [7:0]port_data_o,
	output logic [7:0]data_dat_o,
	output logic ack_o,
	output logic port_we_o
	);
	
	//wires
		//inst_mem
	logic [17:0]inst_dat_i;
	logic ack_i;
	//outputs
		//alu
	logic [7:0]ALU_e;
		//control unit
	logic data_we_o;
	logic data_stb_o;
	logic data_cyc_o;
	logic stb_o;
	logic cyc_o;
		//prog counter
	logic [11:0]inst_addr_o;
	
	//assignments
	inst_mem inst_mem ( .clk(clk),
							  .cyc_i(cyc_o),
							  .stb_i(stb_o),
							  .ack_o(ack_i),
							  .adr_i(inst_addr_o),
							  .dat_o(inst_dat_i)
							 );
							 
	 data_mem data_mem ( .clk(clk),
								.cen(cen),
							   .cyc_i(data_cyc_o),
							   .stb_i(data_stb_o),
							   .we_i(data_we_o),
							   .ack_o(ack_o),
							   .adr_i(ALU_e),
							   .dat_i(port_data_o),
							   .dat_o(data_dat_o) 
								);
								
	Core core ( .clk(clk),
				   .cen(cen), 
				   .rst(rst),
					//inst_mem
				   .inst_dat_i(inst_dat_i),
				   .ack_i(ack_i),
					//data_mem
				   .data_dat_i(data_dat_i),
				   .ack_o(ack_o),
					//control unit enable
				   .int_req(int_req),
					//outputs
						//alu
				   .ALU_e(ALU_e),
						//register
				   .port_data_o(port_data_o),
					.port_we_o(port_we_o),
						//control unit
				   .data_we_o(data_we_o),
				   .data_stb_o(data_stb_o),
				   .data_cyc_o(data_cyc_o),
				   .int_ack_o(int_ack),//salida? o regresa como enable
						//data & int MEM
				   .stb_o(stb_o),
				   .cyc_o(cyc_o),
						//prog counter
				   .inst_addr_o(inst_addr_o)
					);
endmodule 