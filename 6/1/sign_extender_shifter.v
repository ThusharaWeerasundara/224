/*
Lab 5 part 4
program_counter module
does sign extension to get 32 bit byte address the left shift by 2 to get word address for add with pc + 4
*/

module sign_extender_shifter(in, out);

input [7:0] in;
reg [31:0] temp;
output reg[31:0] out;

always @(in) 
begin
	temp =  { {24{in[7]}}, in };	//sign extension
	out = {temp[29:0], 2'b00};				//shift operation
end




endmodule