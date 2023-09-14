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
	output logic [31:0] dataA, dataB;
	input logic  [31:0] dataR;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals and module instantiation for pulse generation
	logic pulse;
	peripheral_pulse pulse_generator (enter, clk, reset, pulse);
	
	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	logic change_position [2:0] = 3'b000;
	//logic current_position 
	always_ff @(posedge pulse, posedge reset) begin 
		if(reset) begin
			change_position <= 0;
			inputdata_ready <= 0;
		end else begin
			change_position <= change_position + 1;
		end
	end
	
	always_comb
		casez (change_position)
		3'b?00: current_position = 0;
		3'b?01: current_position = 8;
		3'b?10: current_position = 16;
		3'b?11: current_position = 24;
		endcase
	end
	
	// Internal signals and module instantiation for getting operands
	// WRITE HERE YOUR CODE

	// Internal signals, module instantiation and process for showing operands and result
	// WRITE HERE YOUR CODE
endmodule