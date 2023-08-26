/* MODULO PRINCIPAL*/

module main #(fpga_f = 50_000_000, n = 4) 
	(clk, nreset, timeS, up, clk_500ms, seg1, seg0);
	
	/* Entradas y salidas*/
	input logic clk, nreset, timeS, up; 
	output logic clk_500ms;
	output logic [6:0] seg1, seg0;
	
	
	logic reset; 
	assign reset = ~nreset;
	
	
	integer i; /* Contador para el for */
	logic [n-1:0] numSeg = 0; /* En donde se guardará el numero a mostrar */
	logic [n-1:0] posNum = 0; /* Posición del numero a mostrar */
	
	/* Creación vector de la secuencia */
	logic [n - 1:0] sec [7:0];
	
	always_comb begin
		for (i = 0; i < 8; i = i + 1) begin
			case (i)
				0: sec[i] = 5;
				1: sec[i] = 10;
				2: sec[i] = 15;
				3: sec[i] = 4;
				4: sec[i] = 9;
				5: sec[i] = 14;
				6: sec[i] = 3;
				7: sec[i] = 8;
				default: sec[i] = 0;
			endcase
		end
		
	end
	
	/* Generelación de las dos señales de reloj*/
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
	
endmodule
