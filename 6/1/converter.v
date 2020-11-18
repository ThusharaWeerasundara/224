/*
E/16/388
lab 5 part 3
unit to get 2s complement of 8bit values
*/

module converter(in_val, out_val);

	input [7:0] in_val;			//input value
	output reg[7:0] out_val;	//output 2s complement value

	always @(in_val)
	begin
	#1
	out_val = ~ in_val + 8'b00000001;	//2s complement conversion

	end

endmodule


