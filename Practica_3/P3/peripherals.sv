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
	// WRITE HERE YOUR CODE

	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	// WRITE HERE YOUR CODE
	
	// Internal signals and module instantiation for getting operands
	// WRITE HERE YOUR CODE

	// Internal signals, module instantiation and process for showing operands and result
	// WRITE HERE YOUR CODE
endmodule