module main #(fpga_f = 50_000_000, n = 5)
	(clk, nreset, A, B, nOperSel, flags, curretOp, segMinus2, segTens1, segUnits0); 
	
	/* Entradas y salidas */
	input logic clk, nreset, nOperSel;
	input logic [n - 1:0] A, B;
	
	output logic [3:0] flags, curretOp;
	output logic [6:0] segMinus2, segTens1, segUnits0;
	
	/* Señales internas */
	
	logic reset;
	assign reset = ~nreset;
	
	logic OperSel;
	assign OperSel = ~nOperSel;
	
	logic [1:0] ALUControl = 2'b00; /* Controlar qué peración realizar */
	logic pulse;
	
	/* Generación del pulso */
	pulse genPulse (OperSel, clk, reset, pulse);
	
	/* Control del tipo de operación */
	always_ff @(posedge pulse) begin 
		ALUControl <= ALUControl + 1;
	end
	
endmodule



	
	