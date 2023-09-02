module main #(fpga_f = 50_000_000, n = 5)
	(clk, nreset, A, B, nOperSel, flags, currentOp, segMinus2, segTens1, segUnits0); 
	
	/* Entradas y salidas */
	input logic clk, nreset, nOperSel;
	input logic [n - 1:0] A, B;
	
	output logic [3:0] flags, currentOp;
	output logic [6:0] segMinus2, segTens1, segUnits0;
	
	/* Señales internas */
	logic [n - 1:0] outALU;
	
	logic reset;
	assign reset = ~nreset;
	
	logic OperSel;
	assign OperSel = ~nOperSel;
	
	logic [1:0] ALUControl = 2'b00; /* Controlar qué peración realizar */
	alu #(n) aluM (A, B, ALUControl, flags, outALU);
	logic pulse;
	
	/* Generación del pulso */
	pulse genPulse (OperSel, clk, reset, pulse);
	
	/* Control del tipo de operación */
	always_ff @(posedge pulse) begin 
		ALUControl <= ALUControl + 1;
		case (ALUControl)
			2'b00: currentOp <= 4'b1000;
			2'b01: currentOp <= 4'b0100;
			2'b10: currentOp <= 4'b0010;
			2'b11: currentOp <= 4'b0001;
		endcase
	end
	
	/* Asignación de la salida de la ALU a los 7 segmentos */
	logic [3:0] tens1;
	logic [3:0] units0;
	logic [n - 1:0] resultOp;
	
	deco7seg_hexa decoTens1(tens1, segTens1);
	deco7seg_hexa decoUnits0(units0, segUnits0);
	
	always_comb begin
		resultOp = outALU;
		
		if (flags[3] & ~ALUControl[1]) begin /* Si es N y es suma/resta */
			segMinus2 = 7'b011_1111;
			resultOp = ~outALU + 1'b1; /* Complemento a dos */
			tens1 = resultOp/10;
			units0 = resultOp%10;
			
		end else begin /* Considera que: no sea negativo, y que sea una OP lógica */
			segMinus2 = 7'b111_1111;
			tens1 = resultOp/10;
			units0 = resultOp%10;
			
		end 
	end
	
	
endmodule

module tb_main();
	// Parámetros locales
	localparam CLK_P = 20ns; 
	localparam FPGA_F = 8;
	localparam n = 5;
	
	// Señales internas
	logic clk, nreset, nOperSel;
	logic [n - 1:0] A, B;
	
	logic [3:0] flags, currentOp;
	logic [6:0] segMinus2, segTens1, segUnits0;
	
	// Instanciacion del circuito
	main #(FPGA_F, n) mainALU (clk, nreset, A, B, nOperSel, flags, currentOp, segMinus2, segTens1, segUnits0);
	
	initial begin
		clk = 0;
		nreset = 0;
		A = 10;
		B = 2;
		nOperSel = 0;
		#(CLK_P*1);
		nreset = 1;
		A = 10;
		B = 2;
		nOperSel = 0;
		#(CLK_P*512);
		
		$stop;
		
	end
	
	always #(CLK_P/2) clk = ~clk;
	
endmodule



	
	