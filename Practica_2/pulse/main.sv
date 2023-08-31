module main (na, clk, nreset, disp);
	input logic na, clk, nreset;
	output logic [6:0] disp;
	
	// Internal signals
	logic a, reset, intPulse;
	logic [3:0] cnt;
	
	// Parallel circuits
	assign reset = ~nreset;
	assign a = ~na;
	pulse p0 (a, clk, reset, intPulse);
	deco7seg_hexa deco0 (cnt, disp);
	
	// Counter process. Activates each time intPulse is 1'b1
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			cnt <= 0;
		else if (intPulse)
			cnt <= cnt + 1;
	end
endmodule