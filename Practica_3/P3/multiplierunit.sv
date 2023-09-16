// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	// WRITE HERE YOUR CODE
	logic [22:0] fraccA, fraccB;
	logic [7:0] expA, expB;
	logic [23:0] mantissaA, mantissaB;
	
	logic singR;
	logic [7:0] expR;
	logic [22:0] fraccR;
	logic [47:0] resultProduct;
	
	assign fraccA = dataA[22:0];
	assign fraccB = dataB[22:0];
	assign mantissaA = {1'b1, fraccA};
	assign mantissaB = {1'b1, fraccB};
 	
	// Process: sign XORer
	assign singR = dataA[31] ^ dataB[31];
	
	// Process: exponent adder
	assign expA = dataA[30:23];
	assign expB = dataB[30:23];
	
	// Process: mantissa multiplier
	assign resultProduct = mantissaA*mantissaB;
	
	always_comb begin 
		expR = expA + expB - 127;
		fraccR = resultProduct[45:23];
		
		if (expA == 255 | expB == 255 | dataA[30:0] == 0 | dataB[30:0] == 0) begin // Casos especiales
		
			if (dataA[30:0] == 0 | dataB[30:0] == 0) begin // Casos cero por algo
				if (expA == 255 | expB == 255) begin // Es 0xinf o 0xNaN 
					expR = 255;
					fraccR = 1;
				end else begin // Un número por cero es cero
					expR = 0;
					fraccR = 0;
				end 
			// Caso NaN: lo que sea por NaN es NaN
			end else if ((expA == 255 & fraccA != 0) | (expB == 255 & fraccB != 0)) begin 
				expR = 255;
				fraccR = 1;
			// Casos fintxinf, infxinf
			end else begin 
				expR = 255;
				fraccR = 0;
			end
			
		end 
		
		// Normalización
		if (resultProduct[47]) begin
			expR = expA + expB - 127 + 1;
			fraccR = resultProduct[46:24];
		end 
		
	end 
	
	// Process: operand validator and result normalizer and assembler
	assign dataR = {singR, expR, fraccR};
	
	
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit ();
	// WRITE HERE YOUR CODE
	
	localparam fpga_freq = 8;
	localparam delay = 20ps;
	logic clk;
	
	logic [31:0] dataA, dataB;
	logic [31:0] dataR;
	
	multiplierunit mt (dataA, dataB, dataR);
	
	initial begin
		dataA = 32'b01000111100110101010111100010101;
		dataB = 32'b01000110000110010001101010011100;
		
		#(delay*100);
	
	end 
	
	always #(delay/2) clk = ~clk;
	
endmodule