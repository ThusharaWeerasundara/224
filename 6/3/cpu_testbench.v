/*
E/16/388
lab 5 part 4 
testbench for cpu
*/


`include "cpu.v"        //include cpu module
`include "data_memory.v"
`include "dcache.v"
`include "ins_memory.v"
`include "ins_cache.v"

module cpu_tb;

    reg CLK, RESET;     //input signals
    wire [31:0] PC;     //store pc value
    wire [31:0] INSTRUCTION;     //32 bit instruction
    reg  [7 : 0] instr_mem[1023 : 0];   //tempory instruction memory
    integer count = 0;          //count array rows simillar to pc
    wire mem_read, mem_write, busywait, data_read, data_write, data_busywait;
    wire [7:0] ADDRESS, WRITEDATA, READDATA; //to work with data words with cache between cpu and data cache
    wire[5:0] mem_address; //block addresses
    wire [31:0] mem_writedata, mem_readdata; //to work between data cache and data memory using blocks
    wire ins_read, ins_busywait, ins_c_busywait; //signals between instruction memory and instruction cache
    wire [5:0] ins_address; 					//6 bit block addresses between instruction cache and memory 
    wire [127:0] ins_readdata;


cpu mycpu(PC, INSTRUCTION, CLK, RESET, ADDRESS, WRITEDATA, READDATA, data_write, data_read, busywait);    //to use cpu module

or is_busy(busywait, data_busywait, ins_c_busywait);

dcache datacache(CLK, RESET, data_busywait, data_read, data_write, WRITEDATA, READDATA, ADDRESS, mem_busywait, mem_read, mem_write, mem_writedata, mem_readdata, mem_address);
//to use data cache
data_memory datamemory(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);
//to use data memory

ins_memory insmemory(CLK, ins_read, ins_address, ins_readdata, ins_busywait);
//to use instruction memory

ins_cache instructioncache(CLK, RESET, ins_c_busywait, INSTRUCTION, PC[9:0], ins_busywait, ins_read, ins_readdata, ins_address);
//to use instruction cache

//generates busy signal when datamemory is working
//get addresses from alu, inputs from reg file, functionality depends on mem_read, mem_write control signals   
    
    initial
    begin
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
        #1400
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
       
     

endmodule

