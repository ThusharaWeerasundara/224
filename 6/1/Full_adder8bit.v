/*
lab 5 part 5

Full_adder8bit module to do fast adition for multiplication
input 2 8 bit inputs as single bits

*/



module Full_adder8bit(a1,a2,a3,a4,a5,a6,a7,a8, b1,b2,b3,b4,b5,b6,b7,b8, result, cout);

input a1,a2,a3,a4,a5,a6,a7,a8, b1,b2,b3,b4,b5,b6,b7,b8;

reg [7:0] operand1, operand2;
reg [8:0]temp;					//to hold 9 bit full adder results

output reg [7:0] result;
output reg cout;

always @(a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8)
begin

	
	operand1 = {a1,a2,a3,a4,a5,a6,a7,a8};
	operand2 = {b1,b2,b3,b4,b5,b6,b7,b8};
	
	temp = operand1 + operand2;
	result = temp[7:0];											//get 8 bit half adder results
	cout = temp[8];												//get carry bit

end

endmodule

