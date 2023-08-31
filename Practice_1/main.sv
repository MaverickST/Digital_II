/* MODULO PRINCIPAL*/

module main #(fpga_f = 50_000_000, n = 4) 
	(clk, nreset, timeS, up, seg1, seg0);
	
	/* Entradas y salidas*/
	input logic clk, nreset, timeS, up; 
	output logic [6:0] seg1, seg0;
	
	logic reset; 
	assign reset = ~nreset;
	
	integer i = 0; /* Contador para el case */
	logic [n-1:0] numSeg = 0; /* En donde se guardará el numero a mostrar */
	logic [n-1:0] posNum = 0; /* Posición del numero a mostrar */
	
	/* Creación vector de la secuencia */
	logic [n - 1:0] sec [7:0];
	
	always_ff @(posedge clk) begin
		i <= i + 1;
		case (i)
			0: sec[i] <= 5;
			1: sec[i] <= 10;
			2: sec[i] <= 15;
			3: sec[i] <= 4;
			4: sec[i] <= 9;
			5: sec[i] <= 14;
			6: sec[i] <= 3;
			7: begin 
				sec[i] <= 8; 
				i <= 0;
			end 
			default: sec[i] <= 5;
		endcase
		
	end
	
	/* Generelación de las dos señales de reloj*/
	logic clk_500ms;
	cntdiv_n #(fpga_f/2) cntDiv (clk, reset, clk_500ms);
	logic chooseClk = 0; // Para decidir si el clk de 1s/1Hz o el de 0.5s/2Hz
	
	/* Creación de circuito secuencial para la FSM */
	always_ff @(posedge clk_500ms, posedge reset) begin
		
		if (reset) begin
			posNum <= 0;
			numSeg <= sec[posNum];
			
		end else begin // Hubo flaco de subida
			chooseClk <= chooseClk + 1;
			
			if (timeS) begin // Se hace el cambio con la de 0.5s
				if (up) begin
					posNum <= posNum + 1;
					numSeg <= sec[posNum];
				end else begin
					posNum <= posNum - 1;
					numSeg <= sec[posNum];
				end
				
			end else if (~chooseClk) begin
				if (up) begin
					posNum <= posNum + 1;
					numSeg <= sec[posNum];
				end else begin
					posNum <= posNum - 1;
					numSeg <= sec[posNum];
				end
			end
		end
	end
	
	/* Segmentos */
	
	logic [n-1:0] decSeg; /* Decenas */
	logic [n-1:0] unidSeg; /* Unidades */
	deco7seg_hexa deco1(decSeg, seg1);
	deco7seg_hexa deco0(unidSeg, seg0);
	
	always_comb begin
		if (numSeg/10 === 0) begin /* No hay decenas */
			decSeg = 0;
			unidSeg = numSeg;
		end else begin
			decSeg = numSeg/10;
			unidSeg = numSeg%10;
		end
	end
	
endmodule

/* MODULO DEL TESTBENCH */

module tb_main();
	// Parámetros locales
	localparam CLK_P = 20ns; 
	localparam FPGA_F = 8;
	
	// Señales internas
	logic clk, reset, timeS, up;
	logic [6:0] seg1, seg0;
	
	// Instanciacion del circuito
	main #(FPGA_F, 4) mainSec (clk, reset, timeS, up, seg1, seg0);
	
	initial begin
		clk = 0;
		reset = 0;
		timeS = 0;
		up = 0;
		#(CLK_P); /* Este bloque define el funcionamiento */
		reset = 1;
		timeS = 1;
		up = 1;
		#(CLK_P*10); /* Este bloque define el funcionamiento */
		reset = 1;
		timeS = 0;
		up = 0;
		#(CLK_P*10);
		
		$stop;
		
	end
	
	always #(CLK_P/2) clk = ~clk;
	
endmodule
