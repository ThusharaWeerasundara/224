/*
lab 5 part 5

multiplier module to do for multiplication
input 2 8 bit input
output is 8 bits, most significant 8 bits are neflected

*/

`include "Full_adder8bit.v"		//import adder

module multiplier (in1, in2, out);
	
	input  [7:0]  in1, in2;    
	output reg [7:0] out ;

	wire [7:0]  result1,result2, result3, result4, result5, result6, result7;		//datapath to alu results for each step
	wire c1, c2, c3, c4, c5, c6, c7;												//datapath for carry bits for each step


//below adders adds partial multiplication results of each step and generate 1 bit at a time for final results


Full_adder8bit adder1(1'b0 ,in1[7]&in2[0], in1[6]&in2[0], in1[5]&in2[0], in1[4]&in2[0], in1[3]&in2[0] , in1[2]&in2[0], in1[1]&in2[0]  ,
					  in2[1]&in1[7], in2[1]&in1[6], in2[1]&in1[5], in2[1]&in1[4], in2[1]&in1[3], in2[1]&in1[2], in2[1]&in1[1], in2[1]&in1[0],
					  result1, c1);

Full_adder8bit adder2(c1, result1[7], result1[6], result1[5], result1[4], result1[3], result1[2], result1[1],	 
					  in2[2]&in1[7], in2[2]&in1[6], in2[2]&in1[5], in2[2]&in1[4], in2[2]&in1[3], in2[2]&in1[2], in2[2]&in1[1], in2[2]&in1[0],  
					  result2,c2);

Full_adder8bit adder3(c2, result2[7], result2[6], result2[5], result2[4], result2[3], result2[2], result2[1], 
					  in2[3]&in1[7], in2[3]&in1[6], in2[3]&in1[5], in2[3]&in1[4], in2[3]&in1[3], in2[3]&in1[2], in2[3]&in1[1], in2[3]&in1[0], 
					  result3,c3);

Full_adder8bit adder4(c3, result3[7], result3[6], result3[5], result3[4], result3[3], result3[2], result3[1],
					  in2[4]&in1[7], in2[4]&in1[6], in2[4]&in1[5], in2[4]&in1[4], in2[4]&in1[3], in2[4]&in1[2], in2[4]&in1[1], in2[4]&in1[0], 
					  result4,c4);

Full_adder8bit adder5(c4, result4[7], result4[6], result4[5], result4[4], result4[3], result4[2], result4[1],
					  in2[5]&in1[7], in2[5]&in1[6], in2[5]&in1[5], in2[5]&in1[4], in2[5]&in1[3], in2[5]&in1[2], in2[5]&in1[1], in2[5]&in1[0], 
					  result5,c5);

Full_adder8bit adder6(c5, result5[7], result5[6], result5[5], result5[4], result5[3], result5[2], result5[1], 
					  in2[6]&in1[7], in2[6]&in1[6], in2[6]&in1[5], in2[6]&in1[4], in2[6]&in1[3], in2[6]&in1[2], in2[6]&in1[1], in2[6]&in1[0], 
					  result6,c6);

Full_adder8bit adder7(c6, result6[7], result6[6], result6[5], result6[4], result6[3], result6[2], result6[1], 
					  in2[7]&in1[7], in2[7]&in1[6], in2[7]&in1[5], in2[7]&in1[7], in2[7]&in1[7], in2[7]&in1[7], in2[7]&in1[1], in2[7]&in1[0], 
					  result7,c7);


always @(in1, in2, result1[0],result2[0], result3[0], result4[0], result5[0], result6[0], result7[0])		//sensitive to alu results of eachstep. 
																											//least significant bit is considerd because it is directl going to be a bit in results
begin
	
	out[0] = in1[0]&in2[0];

	out[1] = result1[0];
	
	out[2] = result2[0];
	
	out[3] = result3[0];
	
	out[4] = result4[0];
	
	out[5] = result5[0];
	
	out[6] = result6[0];
	
	out[7] = result7[0];	

	//each step produce 1 bit for the results

end	
endmodule