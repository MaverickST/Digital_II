module alu #(n = 5) 
	(a, b, ALUControl, flags, outALU);
	
	/* Salidas y entradas */
	input logic [n - 1:0] a, b;
	input logic [1:0] ALUControl; 
	output logic [3:0] flags;
	output logic [n - 1:0] outALU;
	
	/* Señales internas */
	logic [n - 1:0] sum;
	logic [n - 1:0] auxB;
	logic Cout;
	
	/* Asignación de la salida */
	always_comb begin
		case (ALUControl)
			2'b0?: outALU = sum;
			2'b10: outALU = a & b;
			2'b11: outALU = a | b;
			default: outALU = sum;
		endcase
	end
	
	/* Realización de la suma */
	always_comb begin
		{Cout, sum} = {1'b0, a} + ({1'b0, auxB} + ALUControl[0]);
		case (ALUControl[0])
			1'b0: auxB = b;
			1'b1: auxB = ~b;
		endcase
	end
	
	/* Asignación de flags */
	always_comb begin
		flags[3] = outALU[n - 1]; /* N */
		flags[2] = (outALU == 0)? 1'b1 : 1'b0; /* Z */
		flags[1] = Cout & (~ALUControl[1]); /* C */
		flags[0] = (~(ALUControl[0] ^ a[n - 1] ^ b[n - 1])) & (a[n - 1] ^ sum[n - 1]) & (~ALUControl[1]); /* V */
	end
	
//	/* Asignación de N */
//	assign flags[3] = outALU[n - 1]; 
//	/* Asignación de Z */
//	assign flags[2] = (outALU == 0)? 1'b1 : 1'b0;
//	/* Asignación de C */
//	assign flags[1] = Cout & (~ALUControl[1]); 
//	/* Asignación de V */
//	assign flags[0] = (~(ALUControl[0] ^ a[n - 1] ^ b[n - 1])) & (a[n - 1] ^ sum[n - 1]) & (~ALUControl[1]); 
	
	
endmodule