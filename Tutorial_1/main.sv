module main #(BITS = 25) (
	input logic CLK,
	input logic RST,
	input logic EN,
	input logic [1:0] S,
	input logic [3:0] D,
	output logic [6:0] SEG);
	
	reg internalClk;
	logic [3:0] Q; 
	
	cntdiv_n #(BITS) cntDiv (CLK, ~RST, internalClk);
	contador contador0(~RST, EN, internalClk, D, S, Q);
	deco7seg_hexa deco0(Q, SEG);
endmodule

module tb_main();
	// local parameters
	localparam CLK_PERIOD = 20ns;
	// internal signals
	logic CLK;
	logic RST;
	logic EN;
	logic [1:0] S;
	logic [3:0] D;
	logic [6:0] SEG;
	// circuit instance
	main #(4) main_u0 (CLK, RST, EN, S, D, SEG);
	// Simulation process
	initial begin
		CLK = 0;
		RST = 0;
		EN = 1;
		S = 2'b10;
		 D = 4'b0000;
		#(CLK_PERIOD * 8); //Se mantiene durante un tiempo determinado (8 ciclos de reloj) antes de ejecutar la siguiente instruccion
		RST = 1;
		#(CLK_PERIOD * 256);
		$stop;
	end
	always #(CLK_PERIOD / 2) CLK = ~CLK;
endmodule
