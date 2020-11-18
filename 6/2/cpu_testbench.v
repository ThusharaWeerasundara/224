/*
E/16/388
lab 5 part 4 
testbench for cpu
*/


`include "cpu.v"        //include cpu module
`include "data_memory.v"
`include "dcache.v"

module cpu_tb;

    reg CLK, RESET;     //input signals
    wire [31:0] PC;     //store pc value
    reg [31:0] INSTRUCTION;     //32 bit instruction
    reg  [7 : 0] instr_mem[1023 : 0];   //tempory instruction memory
    integer count = 0;          //count array rows simillar to pc
    wire mem_read, mem_write, busywait, data_read, data_write;
    wire [7:0] ADDRESS, WRITEDATA, READDATA; //to work with data words with cache between cpu and data cache
    wire[5:0] mem_address; //block addresses
    wire [31:0] mem_writedata, mem_readdata; //to work between data cache and data memory using blocks

cpu mycpu(PC, INSTRUCTION, CLK, RESET, ADDRESS, WRITEDATA, READDATA, data_write, data_read, busywait);    //to use cpu module

dcache datacache(CLK, RESET, busywait, data_read, data_write, WRITEDATA, READDATA, ADDRESS, mem_busywait, mem_read, mem_write, mem_writedata, mem_readdata, mem_address);
//to use data cache
data_memory datamemory(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);
//to use data memory



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

        count = 8;
        //swd 1 5
        instr_mem[count + 0] = 8'b00010100;
        instr_mem[count + 1] = 8'b00000000;
        instr_mem[count + 2] = 8'b00000001;
        instr_mem[count + 3] = 8'b00000101;

        count = 12;
        //lwd 3 5 
        instr_mem[count + 0] = 8'b00010010;
        instr_mem[count + 1] = 8'b00000011;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;

        //swi 5 0x85
        count = 16;
        instr_mem[count + 0] = 8'b00010011;
        instr_mem[count + 1] = 8'b00000000;
        instr_mem[count + 2] = 8'b00000101;
        instr_mem[count + 3] = 8'b10000101;

        //swi 1 0x86
        count = 20;
        instr_mem[count + 0] = 8'b00010011;
        instr_mem[count + 1] = 8'b00000000;
        instr_mem[count + 2] = 8'b00000001;
        instr_mem[count + 3] = 8'b10000110;

        count = 24;
        //lwi 7 0x05 
        instr_mem[count + 0] = 8'b00010001;
        instr_mem[count + 1] = 8'b00000111;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000101;

        count = 28;        
        //loadi 2 0x86
        instr_mem[count + 0] = 8'b00000000;
        instr_mem[count + 1] = 8'b00000010;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b10000110;

        count = 32;
        //lwd 6 2 
        instr_mem[count + 0] = 8'b00010010;
        instr_mem[count + 1] = 8'b00000110;
        instr_mem[count + 2] = 8'b00000000;
        instr_mem[count + 3] = 8'b00000010;

        count = 36;
        //add 0 7 6
        instr_mem[count + 0] = 8'b00000010;
        instr_mem[count + 1] = 8'b00000000;
        instr_mem[count + 2] = 8'b00000111;
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
        #1200
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

