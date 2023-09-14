/* Módulo controlador de tráfico de luces */
module trafficlight #(fpga_freq = 50_000_000, 
   tgreen_main = 8, tyellow_main = 2, tgreen_sec = 6, tyellow_sec = 2)
   (clk, nreset, main_lights, sec_lights, clk_seconds);

	/* Entradas y salidas */
	input logic clk, nreset;
	output logic [2:0] main_lights;
	output logic [2:0] sec_lights;
	output logic clk_seconds;

	/* Circuito para invertir señal de reloj */
	logic reset;
	assign reset = ~nreset;
	
	/* Señales internas para contar segundos a partir del reloj de la FPGA */
	logic [3:0] cnt_seconds;		// 4-bits para contar hasta 16 segundos
	logic cnt_timeIsUp;				// Tiempo completado en estado actual
	// Generador de señal de relol clk_seconds de 1 hz.
	cntdiv_n #(fpga_freq) cntDiv (clk, reset, clk_seconds);

	/* Definición de estados de la FSM y señales internas para estado actual y siguiente */
	typedef enum logic [1:0] {Smg, Smy, Ssg, Ssy} State;
	State currentState, nextState;
	
	/* Circuito secuencial para actualizar estado actual con el estado siguiente (cada segundo). 
		Se emplea señal de reloj de 1 hz. Tenga en cuenta que si la máquina de estados finitos debe
		sensar cambios rápidos en las entradas (us, ms, etc.), se debería usar directamente el reloj
		de la FPGA */
	always_ff @(posedge clk_seconds, posedge reset) 
		if (reset)
			currentState <= Smg;
		else 
			currentState <= nextState;
	
	/* Circuito combinacional para determinar siguiente estado de la FSM */
	always_comb begin
		nextState = currentState;	// Para evitar escribir los else
		case (currentState)
			Smg:	
				if(cnt_timeIsUp)
					nextState = Smy;
			Smy:	
				if(cnt_timeIsUp)
					nextState = Ssg;
			Ssg:	
				if(cnt_timeIsUp)
					nextState = Ssy;
			Ssy:	
				if(cnt_timeIsUp)
					nextState = Smg;
			default:		
				nextState = Smg;
		endcase
	end	
	
	/* Circuito combinacional para manejar las salidas */
	always_comb begin
		main_lights = 3'b100;			// Para simplificar cada case
		sec_lights = 3'b100;				// Para simplificar cada case
		case (currentState)
			Smg: 
				main_lights = 3'b001;
			Smy: 
				main_lights = 3'b010;
			Ssg: 
				sec_lights = 3'b001;
			Ssy: 
				sec_lights = 3'b010;
		endcase
	end	

	/* Circuito secuencial para el contador de segundos */
	always_ff @(posedge clk_seconds, posedge reset) begin
		if (reset) begin
			cnt_seconds <= 0;
			cnt_timeIsUp <= 0;
		end else begin
			cnt_seconds <= cnt_seconds + 1;	// No cambia hasta finalizar proceso (<=)
			cnt_timeIsUp <= 0;

			case (currentState)
				Smg:	
					if(cnt_seconds == (tgreen_main-1)) begin
						cnt_timeIsUp <= 1;
						cnt_seconds <= 0;
					end
				Smy:	
					if(cnt_seconds == (tyellow_main-1)) begin
						cnt_timeIsUp <= 1;
						cnt_seconds <= 0;
					end
				Ssg:	
					if(cnt_seconds == (tgreen_sec-1)) begin
						cnt_timeIsUp <= 1;
						cnt_seconds <= 0;
					end
				Ssy:	
					if(cnt_seconds == (tyellow_sec-1)) begin
						cnt_timeIsUp <= 1;
						cnt_seconds <= 0;
					end
			endcase
		end
	end
endmodule

/* Módulo testbench */
module testbench();
	/* Declaración de señales y variables internas */
	logic clk, reset, clk_seconds;
	logic [2:0] main_lights, sec_lights;
	localparam fpga_freq = 8;
	localparam delay = 20ps;
	
	// Instanciar objeto
	trafficlight #(fpga_freq) tl (clk, reset, main_lights, sec_lights, clk_seconds);
	
	initial begin
		clk = 0;
		reset = 0;
		#(delay);
		reset = 1;
		#(delay*(8+2+6+2)*fpga_freq*2);

		$stop;
	end
	
	always #(delay/2) clk = ~clk;

endmodule