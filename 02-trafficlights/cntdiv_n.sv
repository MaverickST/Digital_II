module cntdiv_n #(TOPVALUE = 10) (clk, rst, clkdiv);
	input logic clk, rst;
	output logic clkdiv;
	
	// Bits for the counter
	localparam BITS = $clog2(TOPVALUE);
	
	// counter register
	logic [BITS - 1 : 0] rCounter;

	// increment or reset the counter
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			rCounter <= 0;
			clkdiv <= 0;
		end else begin
			if (rCounter == (TOPVALUE - 1))
				rCounter <= 0;
			else	
				rCounter <= rCounter + 1;
				
			// Guarantee a registered clock
			clkdiv <= (rCounter >= (TOPVALUE/2)) ? 1'b1 : 1'b0;
		end	
	end		
endmodule			

