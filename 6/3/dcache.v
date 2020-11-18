`timescale 1ns/100ps
`include "tagcomparator.v"  //to use tag comparator module

module dcache (clock, reset, busywait, read, write, WRITEDATA, READDATA, ADDRESS, mem_busywait, mem_read, mem_write, mem_writedata, mem_readdata, mem_address);
    
    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */
    integer i;											//for reset operations
    input read, write, clock, reset, mem_busywait;      //control signals
    input [7:0] WRITEDATA, ADDRESS;                     //input word data and adress from cpu
    input [31:0] mem_readdata;                          //input data blocks from memory
    output  [7:0] READDATA;                          	//output data words to cpu
    output reg busywait, mem_read, mem_write;           //output control signals from cache
    output reg [31:0] mem_writedata;                    //output data blocks to memory
    output reg [5:0] mem_address;                       //data block addresses to memory

    reg [7:0] valid, dirty;                             //to hold valid and dirty bits
    reg [2:0] tag[7:0];                                 //to hold address tag
    reg [31:0] data[7:0];                               //to hold data blocks

    wire [31:0] stored_block;                            //extracted block
    wire [2:0] req_tag, req_index, stored_tag;           //to hold address tag, index of current address
    wire [1:0] req_offset;                               //to hold offset of current address
    wire stored_valid, stored_dirty;                     //to hold valid and dirty bits of current block
    //reg [7:0] extracted_word;
    //reg hit;												

    wire tag_results, hitstatus;                         //results from tag comparator and hit checker
    wire [7:0] required_word;                            //to read required word from cpu

    always @(posedge read, posedge write)               //at read/write signals module is busy
    begin
        busywait = 1'b1;
    end

    always @(posedge reset)                             //at reset set all fields to 0
    begin
       for (i=0;i<7; i=i+1)
       begin
          valid[i] = 0;
          dirty[i] = 0;
          data[i] = 0; 
          tag[i] = 0;
          busywait = 0;  
       end  
    end

   
    assign    req_tag = ADDRESS[7:5];                   //seperating input address into required fields tag, index, offset
    assign    req_index = ADDRESS[4:2];
    assign    req_offset = ADDRESS[1:0];      
    assign #1   stored_block = data[ADDRESS[4:2]];      //extracting tag, valid bit, dirty bit, stored block from cache for the needed index
    assign #1   stored_tag = tag[ADDRESS[4:2]];
    assign #1   stored_dirty = dirty[ADDRESS[4:2]];
    assign #1   stored_valid = valid[ADDRESS[4:2]];

    tagcomparator tagmatch(tag_results, stored_tag, req_tag);   //check for tag match
    and hit_miss(hitstatus, tag_results, stored_valid);         //check for hit/miss

    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010, CACHE_UPDATE = 3'b011;  //to hold required states
    reg [2:0] state, next_state;        //to store current and next states

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:          //this block determines functionality, state transition in IDLE state according to inputs
                if ((read || write) && !stored_dirty && !hitstatus)  
                    next_state = MEM_READ;
                else if ((read || write) && stored_dirty && !hitstatus)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:       //this block determines functionality, state transition in MEM_READ state according to inputs. Reads blocks from memory
                if (!mem_busywait)  //if not busy go to next state
                    next_state = CACHE_UPDATE;
                else                //else stay in this state
                    next_state = MEM_READ;
            
            MEM_WRITE:      //this block determines functionality, state transition in MEM_WRITE state according to inputs. Writes blocks to memory
                if (!mem_busywait)      //if not busy go to next state
                    next_state = MEM_READ;
                else                    //else stay in this state
                    next_state = MEM_WRITE;

            CACHE_UPDATE:   //this state update the cache with block from memory
                next_state = IDLE;  //always next state is idle

        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:                   
            begin
                mem_read = 0;           //not read from memory
                mem_write = 0;          //not write to memory
                mem_address = 8'dx;     //memory address dont care
                mem_writedata = 8'dx;   //data to write to memory dont care
                //busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;           //read from memory
                mem_write = 0;          //not write to memory
                mem_address = {req_tag, req_index};  //target address is the inputed address
                mem_writedata = 32'dx;  //data to write to memory dont care
                //busywait = 1;
            end
            
            MEM_WRITE:
            begin    
                mem_read = 0;
                mem_write = 1;
                mem_address = {stored_tag, req_index};
                mem_writedata = stored_block;
               // busywait = 1;
            end

            CACHE_UPDATE:
            begin
                 mem_read = 0;          //not read from memory
                 mem_write = 0;         //not write to memory
                 mem_address = 8'dx;    //memory address dont care
                 mem_writedata = 8'dx;  //data to write to memory dont care
                 //busywait = 1;

                 #1                     //this part is for cache update. This happens with positive clock edge
                                        //we can implement this here because state transtits in positive edges
                data[req_index] = mem_readdata;     //write data block frommemory to correct index
                tag[req_index] = req_tag;           //update tag
                valid[req_index] = 1;               //data is valid
                dirty[req_index] = 0;               //now this data is consistent with memory therefore not dirty
            end

        endcase
    end

    always @(posedge clock)                         //at positive edges if there is a cache hit busywait is 0 and not stall cpu
    begin
        if(hitstatus)
            busywait = 1'b0;
    end

    always @(posedge clock)                         //at positive edge clocks when hit is happened and write is enable write the 
                                                    //correct word in correct offset
    begin
    if(hitstatus && write)
        begin
            #1 
            valid[req_index] = 1;
            dirty[req_index] = 1;
            
            case(req_offset)

            0 : data[req_index][7:0] = WRITEDATA;

            1 : data[req_index][15:8] = WRITEDATA;

            2 : data[req_index][23:16] = WRITEDATA;

            3 : data[req_index][31:24] = WRITEDATA;

            endcase
            
        end

    end

    assign #1 READDATA  = ((req_offset == 0) && read) ? stored_block[7:0]:      //assign read data to output.happens parallel with tag comparison
                          ((req_offset == 1) && read) ? stored_block[15:8]:     //this output is not taken until hit happens. If a miss happens
                          ((req_offset == 2) && read) ? stored_block[23:16]:    //busywait = 1 will make sure register file will not take this value
                            stored_block[31:24];


    // sequential logic for state transitioning 
    always @(posedge clock, reset)  
    begin
        if(reset)                   //at resets state go to idle
            state = IDLE;
        else
            state = next_state;     //at positive edges state transits to next state
    end

    /* Cache Controller FSM End */

endmodule