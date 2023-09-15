// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	// WRITE HERE YOUR CODE
	logic [22:0] fraccA;
	logic [22:0] fraccB;
	logic [7:0] expA;
	logic [7:0] expB;
	logic [23:0] mantissaA;
	logic [23:0] mantissaB;
	
	logic singR;
	logic [7:0] expR;
	logic [22:0] fraccR;
	logic [47:0] resultProduct;
	
	assign fraccA = dataA[22:0];
	assign fraccB = dataB[22:0];
	assign mantissaA = {1'b1, fraccB};
	assign mantissaB = {1'b1, fraccB};
 	
	// Process: sign XORer
	assign singR = dataA[31] ^ dataB[31];
	
	// Process: exponent adder
	assign expA = dataA[30:23];
	assign expB = dataB[30:23];
	
	// Process: mantissa multiplier
	assign resultProduct = mantissaA*mantissaB;
	
	always_comb begin 
		fraccR = resultProduct[45:23];
		if ((dataA[30:0] == 0 & expB[]) | )
			
	end 
	
	// Process: operand validator and result normalizer and assembler
	assign expR = (resultProduct[47])? (expA + AxpB - 127) + 1: (expA + AxpB - 127);
	
	
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit ();
	// WRITE HERE YOUR CODE
endmodule