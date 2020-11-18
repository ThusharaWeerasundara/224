
/*
E/16/388
Lab 05 part 1
8 bit ALU
Supports  add, sub, and, or, mov, and loadi instructions.
*/

/*
Below 8 bit alu can do addition, mov/loadi, bitwise AND, bitwise OR operations in this level.
Also use zero output for decide beq operations
Updated version can do srl,sll,sra,ror,mult instruction and produce 8 bit results
*/

`include "multiplier.v"		//import adder


module alu(DATA1, DATA2, RESULT, SELECT, zero);					//8 bit ALU
															
	input [7:0] DATA1, DATA2;								//8 bit input operands to ALU
	input [3:0] SELECT;										//3 bit selection input to ALU
	output  reg[7:0] RESULT;								//8 bit output register to store reults
	output wire zero;
	wire [7:0]multiply_results;											

	wire [7:0] SUM, MOV, AND_OP, OR_OP;

    assign #1 MOV = DATA2;
    assign #2 SUM = DATA1 + DATA2;
    assign #1 AND_OP =  DATA1 & DATA2;
    assign #1 OR_OP = DATA1 | DATA2;

	always @(*) 							//always block sensitive to these inputs
	begin

		case(SELECT)										//case block sensitive to SELECT input

		4'b0000 :  RESULT = MOV;						//if SELECT = 000 mov/loadi instruction with 1 time unit delay
		4'b0001 :  RESULT = SUM;					//if SELECT = 001 add/sub instruction 2 time unit delay
		4'b0010 :  RESULT = AND_OP;					//if SELECT = 010 bitwise & operation of DATA1 and DATA2 1 time unit delay
		4'b0011 :  RESULT = OR_OP;					//if SELECT = 011 bitwise or operation of DATA1 and DATA2 1 time unit delay
		
		endcase
	end

	always @(DATA1, DATA2, SELECT, RESULT) 							//always block sensitive to these inputs
	begin

		#1
		case(SELECT)												//logical shift right
		4'b0100:
																	//in here, shifting to right we lost the least significant bit.Most significant bit becomes 0.Sign lost for negative numbers
			begin
				case(DATA2)
																	//data positions were changed by concatenation (Like changing wires in a circuit)
					0 :  RESULT = DATA1;

					1 :  RESULT = {1'b0,DATA1[7:1]};

					2 :  RESULT = {2'b00,DATA1[7:2]};
				
					3 :  RESULT = {3'b000,DATA1[7:3]};

					4 :  RESULT = {4'b0000,DATA1[7:4]};

					5 :  RESULT = {5'b00000,DATA1[7:5]};

					6 :  RESULT = {6'b000000,DATA1[7:6]};

					7 :  RESULT = {7'b0000000,DATA1[7]};

					default :  RESULT = 8'b00000000;			//if no of shifts exceed 7 we lost all the bits and new value is 0
				endcase
			end

		4'b0101:	
			
			begin
				case(DATA2)										//logical shift left
																//in here, shifting to left we lost the most significant bit.least significant bit becomes 0.Sign can be changed when shifting
					0 :  RESULT = DATA1;
																//data positions were changed by concatenation (Like changing wires in a circuit)
					1 :  RESULT = {DATA1[6:0], 1'b0};

					2 :  RESULT = {DATA1[5:0], 2'b00};

					3 :  RESULT = {DATA1[4:0], 3'b000};

					4 :  RESULT = {DATA1[3:0], 4'b0000};

					5 :  RESULT = {DATA1[2:0], 5'b00000};

					6 :  RESULT = {DATA1[1:0], 6'b000000};

					7 :  RESULT = {DATA1[0], 7'b0000000};

					default :  RESULT = 8'b00000000;		 //if no of shifts exceed 7 we lost all the bits and new value is 0
				endcase	
			end

		4'b0110:											//rotate right
															//in here bits are shifted to right.New sign is the least significant bit of the number before shift
			begin											//we will not loose bits no matter how many time rotated
				case(DATA2[2:0])							//data positions were changed by concatenation (Like changing wires in a circuit).Data bits will not loose but the positions may change
															//maximum number of rotations is 7.therefore only consider 3 least significant bits in immediate value								
					0 :  RESULT = DATA1;

					1 :  RESULT = {DATA1[0],DATA1[7:1]};

					2 : RESULT = {DATA1[1],DATA1[0],DATA1[7:2]};
				
					3 :  RESULT = {DATA1[2],DATA1[1],DATA1[0],DATA1[7:3]};

					4 :  RESULT = {DATA1[3],DATA1[2],DATA1[1],DATA1[0],DATA1[7:4]};

					5 :  RESULT = {DATA1[4],DATA1[3],DATA1[2],DATA1[1],DATA1[0],DATA1[7:5]};

					6 :  RESULT = {DATA1[5],DATA1[4],DATA1[3],DATA1[2],DATA1[1],DATA1[0],DATA1[7:6]};

					7 :  RESULT = {DATA1[6],DATA1[5],DATA1[4],DATA1[3],DATA1[2],DATA1[1],DATA1[0],DATA1[7]};

					
				endcase 
			end

		4'b0111:

			begin
				case(DATA2)									//arithmatic shift right
															//in here, shifting to right we lost the least significant bit.Most significant uses as sign.It duplicates therefore sign preserved
					0 :  RESULT = DATA1;					

					1 :  RESULT = {DATA1[7],DATA1[7:1]};

					2 :  RESULT = { {2{DATA1[7]}},DATA1[7:2]};
				
					3 :  RESULT = {{3{DATA1[7]}},DATA1[7:3]};

					4 :  RESULT = {{4{DATA1[7]}},DATA1[7:4]};

					5 :  RESULT = {{5{DATA1[7]}},DATA1[7:5]};

					6 :  RESULT = {{6{DATA1[7]}},DATA1[7:6]};

					7 :  RESULT = {{7{DATA1[7]}},DATA1[7]};

					default :  RESULT = 8'b00000000;
				endcase
			end

		4'b1000:		//multiplication operation
			begin
				#3     //Assuming this as a fair delay for multiplication 
				RESULT = multiply_results;
			end

		endcase	
	end
	
	nor zero_signal(zero, RESULT[0],  RESULT[1],  RESULT[2],  RESULT[3],  RESULT[4],  RESULT[5],  RESULT[6],  RESULT[7] );		//using nor gate to decide operands are equal or not		
	
	multiplier fast_multiplication(DATA1, DATA2, multiply_results);		//module to multiply inputs 

endmodule






















