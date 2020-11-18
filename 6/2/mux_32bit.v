/*
E/16/388
lab 5 part 4
Mux to select between 4 8bit values
*/
`timescale 1ns/100ps
module mux_32bit (in0, in1, sel, out);
	
	input [31:0] in0, in1;
	input sel;    
	output reg[31:0] out;
	
	always @(sel, in0, in1)		//sensitivity list
	begin

		case(sel)				//select out value on sel signal

			0 : out = in0; 
			1 : out = in1;

		endcase
	end	

endmodule