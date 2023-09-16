// *********************** 
// Peripherals Unit Module
// *********************** 
module peripherals (clk, reset, enter, inputdata,
					loaddata, inputdata_ready,
                    dataA, dataB, dataR, 
					disp3, disp2, disp1, disp0);

	input logic  clk, reset, enter;
	input logic  [7:0] inputdata;
	input logic  loaddata;
	output logic inputdata_ready;
	output logic [31:0] dataA = 0;
	output logic [31:0] dataB = 0;
	input logic  [31:0] dataR;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals and module instantiation for pulse generation
	logic pulse;
	peripheral_pulse pulse_generator (enter, clk, reset, pulse);
	
	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	logic [3:0] array_position = 3'b000;

	always_ff @(posedge pulse, posedge reset) begin 
		if(reset) begin
			array_position <= 0;
			inputdata_ready <= 0;
			dataA <= 0;
			dataB <= 0;
		end else begin
			if (array_position >= 8) begin
				inputdata_ready <= 1;
			end else begin
				if(array_position[2] == 0) begin
					dataA = dataA << 8;					
					dataA[7:0] = inputdata;
				end else begin
					dataB = dataB << 8;
					dataB[7:0] = inputdata;
				end

				array_position <= array_position + 1;
				inputdata_ready <= 0;
			end
		end
	end

	// Internal signals and module instantiation for getting operands
	// WRITE HERE YOUR CODE

	// Internal signals, module instantiation and process for showing operands and result
	// WRITE HERE YOUR CODE
endmodule


// ************************** 
// Testbench for peripherals
// ************************** 
module tb_peripherals ();

	logic  clk, reset, enter;
	logic  loaddata;
	logic inputdata_ready;
	logic [7:0] inputdata;
	logic [31:0] dataA, dataB, dataR;
	logic [6:0] disp3, disp2, disp1, disp0;
	
	localparam fpga_freq = 8;
	localparam delay = 20ps;
	
	peripherals peripherals (clk, reset, enter, inputdata,
							 loaddata, inputdata_ready,
							 dataA, dataB, dataR, 
							 disp3, disp2, disp1, disp0);

	initial begin
		clk = 0;
		reset = 0;
		enter = 0;

		#(delay);
		inputdata = 8'hAF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hAF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h12;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hFF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hAF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h12;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hFF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hAF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h12;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hFF;
		enter = 1;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 1;
		$stop;
	end
	
	always #(delay/2) clk = ~clk;
	
endmodule