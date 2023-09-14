// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;

	// Internal signals for state machine
	typedef enum logic {S0, S1} State;
	State currentState, nextState;

	// Process (Sequential): update currentState
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			currentState <= S0;
		else 
			currentState <= nextState;
	end
	
	// Process (Combinational): update nextState
	always_comb begin
		case (currentState)
			S0:	
				if(inputdata_ready)
					nextState = S1;
				else
					nextState = currentState;
			S1:	
				if(inputdata_ready)
					nextState = S1;
				else
					nextState = S0;
			default:		
				nextState = S0;
		endcase
	end

	// Process (Combinational): update outputs 
	always_comb begin
	loaddata = 1;
	if (currentState == S1)
		loaddata = 0;
	end
endmodule

// ************************** 
// Testbench for Control Unit
// ************************** 
module tb_controlunit ();

	logic  clk, reset;
	logic  loaddata;
	logic inputdata_ready;
	
	localparam fpga_freq = 8;
	localparam delay = 20ps;
	
	controlunit uut (clk, reset, loaddata, inputdata_ready);
	
	initial begin
		clk = 0;
		reset = 0;
		inputdata_ready = 0;
		#(delay);
		reset = 1;
		#(delay*2);
		inputdata_ready = 0;
		#(delay*2);
		inputdata_ready = 1;
		#(delay*4);
		inputdata_ready = 1;
		#(delay*2);
		inputdata_ready = 0;
		#(delay*2);
		reset = 0;
		inputdata_ready = 0;
		#(delay*2);
		inputdata_ready = 1;
		#(delay*4);
		inputdata_ready = 1;
		#(delay*4);
		inputdata_ready = 0;
		#(delay*4);
		inputdata_ready = 0;
		$stop;
	end
	
	always #(delay/2) clk = ~clk;
	
endmodule