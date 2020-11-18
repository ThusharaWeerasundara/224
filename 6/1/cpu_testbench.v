/*
E/16/388
lab 5 part 4 
testbench for cpu
*/


`include "cpu.v"        //include cpu module
`include "data_memory.v"

module cpu_tb;

    reg CLK, RESET;     //input signals
    wire [31:0] PC;     //store pc value
    reg [31:0] INSTRUCTION;     //32 bit instruction
    reg  [7 : 0] instr_mem[1023 : 0];   //tempory instruction memory
    integer count = 0;          //count array rows simillar to pc
    wire mem_read, mem_write, mem_busywait;     //signals to data memory
    wire [7:0] ADDRESS, WRITEDATA, READDATA;    //to deal between cpu and memory

cpu mycpu(PC, INSTRUCTION, CLK, RESET, ADDRESS, WRITEDATA, READDATA, mem_write, mem_read, mem_busywait);    //to use cpu module
data_memory datamemory(CLK, RESET, mem_read, mem_write, ADDRESS, WRITEDATA, READDATA, mem_busywait);
//generates busy signal when datamemory is working
//get addresses from alu, inputs from reg file, functionality depends on mem_read, mem_write control signals   
    
    initial
    begin
        
        //loadi 1 0x01
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000001;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000001;      
             
        count = 4;
        //loadi 5 0x05
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000101;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;


        //swi 5 0x07
        count = 8;
        instr_mem[count + 0] = 8'b00010011;
        instr_mem[count + 1] = 8'b00000101;
        instr_mem[count + 2] = 8'b00000101;
        instr_mem[count + 3] = 8'b00000111;

        count = 12;
        //swd 1 7
        instr_mem[count + 0] = 8'b00010100;
        instr_mem[count + 1] = 8'b00000111;
        instr_mem[count + 2] = 8'b00000001;
        instr_mem[count + 3] = 8'b00000111;

        count = 16;
        //lwi 6 0x07 
        instr_mem[count + 0] = 8'b00010001;
        instr_mem[count + 1] = 8'b00000110;
        instr_mem[count + 2] = 8'b00000110;
        instr_mem[count + 3] = 8'b00000111;
 
        count = 20;
        //lwd 2 7
        instr_mem[count + 0] = 8'b00010010;
        instr_mem[count + 1] = 8'b00000010;
        instr_mem[count + 2] = 8'b00000001;
        instr_mem[count + 3] = 8'b00000111;

        count = 24;
        //add 3 2 6
        instr_mem[count + 0] = 8'b00000010;
        instr_mem[count + 1] = 8'b00000011;
        instr_mem[count + 2] = 8'b00000010;
        instr_mem[count + 3] = 8'b00000110;

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
        #500
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
       
     always @(PC)
     #2
     begin //load instructions when pc change with 2 unit delay 
        
              INSTRUCTION = {instr_mem[PC],instr_mem[PC + 1], instr_mem[PC + 2], instr_mem[PC + 3]};
        //                  1st 8bits       2nd 8 bits         3rd 8 bits          4th 8 bits  
        
        
     end   

endmodule

