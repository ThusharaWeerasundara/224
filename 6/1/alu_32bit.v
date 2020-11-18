/*
E/16/388
Lab 05 part 4
32 bit ALU
Supports  add instruction.
*/



module alu_32bit(in1, in2, out);

	input [31:0] in1, in2;
	output reg [31:0] out;

	always @(in1,in2) 
	begin	
	#2	
		//#2 for add operation like main alu_system module.works parrallal to main alu
		out =  in1 + in2;
	end


endmodule