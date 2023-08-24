module contador(
	input logic RST, // reset
	input logic EN, // enable
	input logic CLK, // clock
	input logic [3:0] D, // data
	input logic [1:0] S, // function selector
	output logic [3:0] Q ); // output
	
	logic [3:0] k; // internal counter signal

	always_ff @(posedge CLK, posedge RST) begin
	if (RST)
		k <= 4'b0000; // reset
	else
	if (EN)
		case (S)
			2'b01: k <= D; // data load
			2'b10: k <= k+1; // count up
			2'b11: k <= k-1; // count down
			default: k <= k; // memory
		endcase 
	end
	assign Q = k; // assign the internal counter signal to the output Q
endmodule
