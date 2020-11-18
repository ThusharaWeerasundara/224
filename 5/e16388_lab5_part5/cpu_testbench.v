/*
E/16/388
lab 5 part 5
testbench for cpu
*/


`include "cpu.v"        //include cpu module


module cpu_tb;

    reg CLK, RESET;     //input signals
    wire [31:0] PC;     //store pc value
    reg [31:0] INSTRUCTION;     //32 bit instruction
    reg  [7 : 0] instr_mem[1024 : 0];   //tempory instruction memory
    integer count = 0;          //count array rows simillar to pc


cpu mycpu(PC, INSTRUCTION, CLK, RESET);    //to use cpu module
    
    

    initial
    begin
        
        //Test bench to check bonus instructions(Part 5 only)
        
        //loadi 4 x04
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000100;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000100;

        count = 4;
         //loadi 1 x02
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000001;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000010;

        count = 8;
        //srl 4 4 x01
        instr_mem[count + 0] = 8'b00001001;
        instr_mem[count + 1] = 8'b00000100;
        instr_mem[count + 2] = 8'b00000100;
        instr_mem[count + 3] = 8'b00000001;

        count = 12;
        //sll 4 4 x03
        instr_mem[count + 0] = 8'b00001010;
        instr_mem[count + 1] = 8'b00000100;
        instr_mem[count + 2] = 8'b00000100;
        instr_mem[count + 3] = 8'b00000011;

        count = 16;
        //loadi 2 0x05
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000010;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;

        
        count = 20;
        //ror 7 2 x04
        instr_mem[count + 0] = 8'b00001011;
        instr_mem[count + 1] = 8'b00000111;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000100;

        count = 24;
        ///loadi 6 xF8
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000110;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b11111000;


        count = 28;
        //sra 7 6 x02
        instr_mem[count + 0] = 8'b00001100;
        instr_mem[count + 1] = 8'b00000111;
        instr_mem[count + 2] = 8'b00000110;
        instr_mem[count + 3] = 8'b00000010;

        count = 32;
        ///loadi 2 x05
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000010;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;


        count = 36;
        ///loadi 3 x04
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000011;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000100;

        count = 40;
        ///mult 5 2 3
        instr_mem[count + 0] = 8'b00001101;
        instr_mem[count + 1] = 8'b00000101;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000011;


        count = 44;
        //bne x01 2 3
        instr_mem[count + 0] = 8'b00001000;
        instr_mem[count + 1] = 8'b00000001;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000011;

        count = 48;
        //add 3 5 6
        instr_mem[count + 0] = 8'b00000010;
        instr_mem[count + 1] = 8'b00000011;
        instr_mem[count + 2] = 8'b00000110;
        instr_mem[count + 3] = 8'b00000101;

        
        count = 52;
        ///loadi 2 x05
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000010;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;


        count = 56;
        ///loadi 3 x05
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000011;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;


        count = 60;
        //bne x01 2 3
        instr_mem[count + 0] = 8'b00001000;
        instr_mem[count + 1] = 8'b00000001;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000011;


        count = 64;
        ///mult 5 2 3
        instr_mem[count + 0] = 8'b00001101;
        instr_mem[count + 1] = 8'b00000101;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000011;


    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("e16388_cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;

        #6              //reset before use
        RESET = 1;
        #1
        RESET = 0;
        
            
        // finish simulation after some time
        #200
        $finish;
        
    end
    
    // clock signal generation
    always
        #5 CLK = ~CLK;
       
     always @(PC)
     #2
     begin //load instructions when pc change with 2 unit delay 
     		
     	INSTRUCTION = {instr_mem[PC],instr_mem[PC + 1], instr_mem[PC + 2], instr_mem[PC + 3]};
        //                  1st 8bits       2nd 8 bits         3rd 8 bits          4th 8 bits
     end   

endmodule

