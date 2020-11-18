/*
E/16/388
Lab 5 part 3 cpu module
cpu module supporting the instructions add, sub, and, or, mov, and loadi
*/

`include "regfile.v"			//to include sub modules
`include "alu.v"
`include "control_unit.v"
`include "converter.v"
`include "mux.v"
`include "mux_32bit.v"
`include "sign_extender_shifter.v"
`include "alu_32bit.v"
`include "program_counter.v"


module cpu(pc, INSTRUCTION, CLK, RESET, ALURESULT, REGOUT1, READDATA, mem_write, mem_read, busywait);		//module cpu. outputs - PC(32 bit),  inputs - INSTRUCTION(32 bit), CLK,RESET

input CLK, RESET, busywait;
input [31:0]INSTRUCTION;
input [7:0] READDATA;

output [31:0] pc;
output mem_write, mem_read;
output [7:0]  REGOUT1, ALURESULT;
	
wire [3:0] ALUOP;								//to move ALUOP signal
wire [7:0] REGOUT2, REGOUT1, ALURESULT;			//to use output values from register file and alu
wire WRITEENABLE, MUX1, MUX2, zero, select, branch, jump;	//control signals to muxes and register file and nux signals for beq, jump instructions
wire select_branch, instruction_select, b_notequal, zero_inverse, select_bne; //signals gererated in cpu module to choose addresses when branch

wire [31:0]  extended_val, target,new_val;		//to use in new address calculation
reg [31:0] temp, new_target; 					//32 bit tempory addresses
wire [7:0] minus_val, mux1_result, mux2_result, IMMEDIATE;	//outputs from muxes and control unit
wire  mem_read, mem_write;		//signals regarding to data memory operations 
wire [7:0] reg_in;		//signals in association with reg file
	

	program_counter my_pc(CLK, RESET, new_target, pc, busywait);		//to use program_counter module

	always @(posedge CLK) 	//pc increments after clk edges
	begin
		#1 
		if (!RESET && !busywait)//during resets and datamemory is busy avoid this operation
		begin
			#1				//pc increment delay.instruction read happens parallelly
			temp = pc;
			temp = temp + 4;				
		end
	end		

	always @(posedge RESET)		//reset pc at positive reset edge with 1 unit delay
		begin
			#1 
			temp = 0;			//to direct pc to 1st instruction in next positive edge
			new_target = 0;
		end	 

	

	control_unit controller(INSTRUCTION, RESET, WRITEENABLE, ALUOP, MUX1, MUX2, branch, jump, b_notequal, mem_read, mem_write);
	//control unit module

	sign_extender_shifter extend_shift_beq(INSTRUCTION[23:16], extended_val);
	//get a word address out of immediate value (INSTRUCTION[23:16])

	mux select_entry(ALURESULT, READDATA, mem_read, reg_in);
	//mux to decide reg file inputs. choose between data memory outputs and alu outputs as inputs

	regfile resistry(reg_in, REGOUT1, REGOUT2, INSTRUCTION[18 : 16], INSTRUCTION[10 : 8], INSTRUCTION[2 : 0],WRITEENABLE , CLK, RESET, busywait);
	//register file module. destination - INSTRUCTION[18 : 16], outregs - INSTRUCTION[10 : 8], INSTRUCTION[2 : 0], outputs - REGOUT1, REGOUT2
	//input - ALURESULT 

	converter my_converter(REGOUT2, minus_val);
	//2s complement converter

	mux mux1(REGOUT2, minus_val, MUX1, mux1_result);
	//mux to get minus value for sub operation

	mux mux2(mux1_result, INSTRUCTION[7 : 0], MUX2, mux2_result);
	//mux to get immeadiate value for loadi operation

	alu alu_system(REGOUT1, mux2_result, ALURESULT, ALUOP, zero);
	//to get zero value and alu results

	alu_32bit branch_target(temp, extended_val, target);
	//to add word address of immediate value to pc + 4 
	
	and and_gate(select_branch, branch, zero);
	//if zero and branch signals are 1, send signal to mux to choose beq address

	not not_gate(zero_inverse, zero);
	//inverse zero result to select bne address

	and and_bne(select_bne, b_notequal, zero_inverse);
	//generate select signal for bne

	or or_gate(instruction_select, select_branch, jump, select_bne);
	//to decide to use pc + 4 or new address for nest instruction

	mux_32bit select_instruction_beq(temp, target, instruction_select , new_val);
	//select whether to use pc + 4 or new target value for pc
	
	always @(new_val) 			
	begin
		new_target = new_val;	//new calculated instruction address
	end
	
	

endmodule














