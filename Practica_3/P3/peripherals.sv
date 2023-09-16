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
			//processes to store data into proper registers
			if (array_position >= 8) begin
				inputdata_ready <= 1;

				if (array_position < 12) begin
					array_position <= array_position + 1;
				end

			end else if (loaddata == 1) begin

				if(array_position[2] == 0) begin
					dataA = dataA >> 8;					
					dataA[31:24] = inputdata;
				end else begin
					dataB = dataB << 8;
					dataB[31:24] = inputdata;
				end

				array_position <= array_position + 1;
				inputdata_ready <= 0;
			end
		end
	end

	// Internal signals, module instantiation and process for showing operands and result
	logic [3:0] show0, show1, show2, show3 = 0;
	logic a = 1;
	logic b = 0;
	peripheral_deco7seg deco7seg3 (show3, a, disp3);
	peripheral_deco7seg deco7seg2 (show2, b, disp2);
	peripheral_deco7seg deco7seg1 (show1, b, disp1);
	peripheral_deco7seg deco7seg0 (show0, b, disp0);

	always_comb begin
		show2 = array_position[1:0];
		case (array_position[3:2])
			2'b00: show3 = 4'b1010;
			2'b01: show3 = 4'b1011;
			2'b10: show3 = 4'b1100;
			default: show3 = 4'b1100;
		endcase

		show1 = inputdata[7:4];
		show0 = inputdata[3:0];
		case (array_position)
			4'b1001: begin
				show1 = dataR[7:4];
				show0 = dataR[3:0];
				end
			4'b1010: begin
				show1 = dataR[15:12];
				show0 = dataR[11:8];
				end
			4'b1011: begin
				show1 = dataR[23:20];
				show0 = dataR[19:16];
				end
			4'b1100: begin
				show1 = dataR[31:28];
				show0 = dataR[27:24];
				end
		endcase
	end
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
		dataR = 32'hABCD;

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
		reset = 1;
		#(delay);
		reset = 0;
		enter = 0;
		#(delay);
		inputdata = 8'h0F;
		enter = 0;
		#(delay);
		enter = 0;
		#(delay);
		inputdata = 8'hFF;
		enter = 0;
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