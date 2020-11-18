/*
Lab 5 part 3(Updated)
Control unit module
generates pc and decodes instructions
*/

`timescale 1ns/100ps
module control_unit(INSTRUCTION, RESET, WRITEENABLE, ALUOP, mux_minus, mux_immediate, branch, jump, b_notequal, mem_read, mem_write);
/*
	inputs - INSTRUCTION, CLK, RESET
	outputs -  pc, READREG1, WRITEREG, WRITEENABLE, ALUOP, mux_minus, mux_immediate ,IMMEDIATE
*/
	input  RESET;
	input [31:0]INSTRUCTION;
	output reg [3:0]  ALUOP;


	output reg WRITEENABLE, mux_minus , mux_immediate, branch, jump, b_notequal, mem_read, mem_write;
	reg [7:0]OPCODE;

	

	always @(INSTRUCTION)		//only if instruction is chenged
		begin
			 					//wait for pc update
	
							
				OPCODE = INSTRUCTION[31 : 24];		//opcode seperation
				mem_read = 0;						//make these signals 0 initially for functionality
				mem_write = 0;
				
				#1									//decode delay
				case(OPCODE)						//case statement to generate control signals

				/*above 1st 6 instructions are write to registers threr for WRITEENABLE = 1.Requires unique 
				 ALUOP signals for each.Register operands matter, need to decide wether to use immediate/minus/original 
				 register values for the ALU operation.*/

				8'b00000010: 						//add
						begin 						//set required control signals
							ALUOP = 4'b0001;
							mux_minus = 0;
							mux_immediate = 0;					
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000011:						//sub

						begin 						//set required control signals
							ALUOP = 4'b0001;
							mux_minus = 1;			//to get minus value
							mux_immediate = 0;		
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000100:						//and
						begin 						//set required control signals
							ALUOP = 4'b0010;
							mux_minus = 0;
							mux_immediate = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000101:						//or
						begin 						//set required control signals
							ALUOP = 4'b0011;
							mux_minus = 0;
							mux_immediate = 0;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000001:						//mov
						begin 						//set required control signals
							ALUOP = 4'b0000;
							mux_minus = 0;
							mux_immediate = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000000:						//loadi
						begin                       //set required control signals
							ALUOP = 4'b0000;
							mux_immediate = 1;		//to get immediate value.result from mux_minus is dont care
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end		

						//both beq and jump doesnt write to registers

				8'b00000111:						//beq
						begin  						//set required control signals
							branch = 1;
							mux_minus = 1;			//need minus operand
							mux_immediate = 0;		//select register operand			
							WRITEENABLE = 0;
							jump = 0;
							ALUOP = 4'b0001;			//for 2s complement addition		
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end

				8'b00000110:						//jump. ALU op or register operands doesnt matter for alu operation.
						begin  						//set required control signals
							WRITEENABLE = 0;							
							jump = 1;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end


						//bonus parts


  				8'b00001000:						//bne
  						begin
  							b_notequal = 1;			//generate this signal
  							mux_minus = 1;			//need minus operand
							mux_immediate = 0;		//select register operand			
							WRITEENABLE = 0;
							jump = 0;
							ALUOP = 4'b0001;			//for 2s complement addition
							mem_read = 0;
							mem_write = 0;	

 						end		


 						//Above 4 control settings are for shift operations.They are not branch or jump instructions therefor all brancj/jump signals are 0.
 						//Results are written to reg file therefore WRITEENABLE = 1.
 						//They require unique ALUOP signals to decide ALU functionality

				8'b00001001:						//logical shift right
						begin                       //set required control signals
							ALUOP = 4'b0100;
							mux_immediate = 1;		//to get immediate value
							//mux_minus = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end		


				8'b00001010:						//logical shift left
						begin                       //set required control signals
							ALUOP = 4'b0101;
							mux_immediate = 1;		//to get immediate value
							//mux_minus = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end		

				8'b00001011:						//ror
						begin                       //set required control signals
							ALUOP = 4'b0110;
							mux_immediate = 1;		//to get immediate value
							//mux_minus = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end		


				8'b00001100:						//sra
						begin                       //set required control signals
							ALUOP = 4'b0111;
							mux_immediate = 1;		//to get immediate value
							//mux_minus = 0;
							WRITEENABLE = 1;
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 0;
						end				

				8'b00001101:						//multiplication
						begin                       //set required control signals
							ALUOP = 4'b1000;
							mux_immediate = 0;		//use original register operands
							mux_minus = 0;
							WRITEENABLE = 1;		//writes the value to destination
							branch = 0;				//not a branch/jump instruction
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write =0 ;
						end				

				//below 4 instructions are not jump or any kind of a branch instructions.Therefore those signals are off

				8'b00010001:						//lwi
						begin
							ALUOP = 4'b0000;		//for mov input to result
							mux_immediate = 1;		//get imediate value as input
							WRITEENABLE = 1;		//write results to reg
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 1;			//read from memory
							mem_write = 0;
							//mux_minus = 0 		this signal dont care because we use immediate value
						end

				8'b00010010:						//lwd
						begin
							ALUOP = 4'b0000;		//for mov input to result
							mux_immediate = 0;		//get reg value as input
							mux_minus = 0;			//get original value in register
							WRITEENABLE = 1;		//write results to reg
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 1;			//read from memory
							mem_write = 0;
						end

				8'b00010011:						//swi
						begin
							ALUOP = 4'b0000;		//for mov input to result
							mux_immediate = 1;		//get imediate value as input
							//mux_minus = 0 		this signal dont care because we use immediate value
							WRITEENABLE = 0;		//not write results to reg
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 1;			//write to memory
						end

				8'b00010100:						//swd
						begin
							ALUOP = 4'b0000;		//for mov input to result
							mux_immediate = 0;		//get reg value as input
							mux_minus = 0;			//get original value in register
							WRITEENABLE = 0;		//not write results to reg
							branch = 0;
							jump = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write = 1;			//write to memory
						end




				default: 							//if instruction is unknown(RESET situation)
						begin						//generate control signals to load next instruction without changing pc and not to write anything to reg file and memory
							branch = 0;				
							jump = 0;
							WRITEENABLE = 0;
							b_notequal = 0;
							mem_read = 0;
							mem_write =0 ;
							ALUOP = 0;
						end		

				endcase
	end
		

endmodule