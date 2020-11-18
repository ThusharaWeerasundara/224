/*
E/16/388
lab 5 part 3
Mux to select between 2 8bit values
*/

module mux (in0, in1, sel, out);
	
	input [7:0] in0, in1;
	input sel;    
	output reg[7:0] out;
	
	always @(sel, in0, in1)		//sensitivity list
	begin

		case(sel)				//select out value on sel signal

			0 : out = in0; 
			1 : out = in1;

		endcase
	end	

endmodule