module cntdiv_n #(BITS = 4) (clk, rst, tick);// el numeral (#) denota parametro
	input logic clk, rst;
	output logic tick;
	
	// counter register
	logic [BITS - 1 : 0] rCounter;

	// increment or reset the counter
	always @(posedge clk, posedge rst) begin
		if (rst)
			rCounter <= 0;
		else
			rCounter <= rCounter + 1;
	end		

	// generate a tick when rCounter reaches the last value
	assign tick = (rCounter >= 2 ** (BITS - 1)) ? 1'b1 : 1'b0;
endmodule			