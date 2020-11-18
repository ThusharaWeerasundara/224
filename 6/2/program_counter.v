/*
Lab 5 part 4
program_counter module
pc updates and resets
*/
`timescale 1ns/100ps
module program_counter(CLK, RESET,next, pc, busy);

input CLK, RESET , busy;
output reg[31:0] pc;
input [31:0] next;			//next instruction address

always @(posedge CLK) 		//update pc at a positice clock edge with 1 unit delay
	begin
		#1
		if (!RESET && CLK && !busy)
		begin			
			pc = next; 		//update pc	
		end
	end		

	

	always @(posedge RESET)		//reset pc at positive reset edge with 1 unit delay
		begin
			#1 
			pc = -4;			//reset pc value such that next positive clk edge will restart program						
		end	 



endmodule