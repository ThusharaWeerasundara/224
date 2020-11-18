module shifter(DATA1, DATA2, RESULT, SELECT);

    input [7:0] DATA1, DATA2;								//8 bit input operands to ALU
	input [3:0] SELECT;										//3 bit selection input to ALU
	output  reg[7:0] RESULT;								//8 bit output register to store reults
	


always @(DATA1, DATA2, SELECT, RESULT) 							//always block sensitive to these inputs
	begin
		
		case(SELECT)
		4'b0100:

			begin
				case(DATA2)

					0 :  RESULT = DATA1;

					1 :  RESULT = {1'b0,DATA1[7:1]};

					2 :  RESULT = {2'b00,DATA1[7:2]};
				
					3 :  RESULT = {3'b000,DATA1[7:3]};

					4 :  RESULT = {4'b0000,DATA1[7:4]};

					5 :  RESULT = {5'b00000,DATA1[7:5]};

					6 :  RESULT = {6'b000000,DATA1[7:6]};

					7 :  RESULT = {7'b0000000,DATA1[7]};

					default :  RESULT = 8'b00000000;
				endcase
			end

		4'b0101:
			
			begin
				case(DATA2)

					0 :  RESULT = DATA1;

					1 :  RESULT = {DATA1[6:0], 1'b0};

					2 :  RESULT = {DATA1[5:0], 2'b00};

					3 :  RESULT = {DATA1[4:0], 3'b000};

					4 :  RESULT = {DATA1[3:0], 4'b0000};

					5 :  RESULT = {DATA1[2:0], 5'b00000};

					6 :  RESULT = {DATA1[1:0], 6'b000000};

					7 :  RESULT = {DATA1[0], 7'b0000000};

					default :  RESULT = 8'b00000000;
				endcase	
			end

		4'b0110:
			
			begin
				case(DATA2)
					
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
		endcase	
	end

endmodule 	