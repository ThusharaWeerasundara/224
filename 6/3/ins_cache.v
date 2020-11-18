`timescale 1ns/100ps
//`include "tagcomparator.v"  //to use tag comparator module

module ins_cache (clock, reset, busywait, READDATA, ADDRESS, ins_busywait, ins_read, ins_readdata, ins_address);


	integer i;											//for reset operations
    input clock, reset, ins_busywait;      		//control signals
    input [9:0] ADDRESS ;                     			//input adress from cpu
    input [127:0] ins_readdata;                         //input data blocks from memory
    output reg  [31:0] READDATA;
    wire [31:0] instruction;                          	//output data words to cpu
    output reg busywait, ins_read;           			//output control signals from cache
    output reg [5:0]  ins_address;

    reg [7:0] valid;                             //to hold valid 
    reg [2:0] tag[7:0];                                 //to hold address tag
    reg [127:0] data[7:0];                               //to hold data blocks

    wire [128:0] stored_block;                            //extracted block
    wire [2:0] req_tag, req_index, stored_tag;           //to hold address tag, index of current address
    wire [1:0] req_offset;                               //to hold offset of current address
    wire stored_valid, stored_dirty;                     //to hold valid and dirty bits of current block
										

    wire tag_results, hitstatus;                         //results from tag comparator and hit checker
    wire [7:0] required_word;                            //to read required word from cpu

    always @(posedge clock)                             //at reset set all fields to 0
    begin
        if(hitstatus == 1)
        begin
            busywait = 0;     
        end
    end



    always @(posedge reset)                             //at reset, reset all fields 
    begin
       for (i=0;i<8; i=i+1)
       begin
          valid[i] = 0;
          //dirty[i] = 0;
          data[i] = 128'bx; 
          tag[i] = 3'bx;
          busywait = 0;  
       end  
    end
   
    always @(ADDRESS)
    begin
        if(ADDRESS != 1020)
        begin
            busywait = 1;
        end       
    end

    assign req_tag = ADDRESS[9:7]; 					 //seperating fields in address
    assign req_index = ADDRESS[6:4];
    assign req_offset = ADDRESS[3:2]; 
    assign #1   stored_block = data[req_index];      //extracting tag, valid bit, dirty bit, stored block from cache for the needed index
    assign #1   stored_tag = tag[req_index];
    //assign #1   stored_dirty = dirty[req_index];
    assign #1   stored_valid = valid[req_index];
    

    tagcomparator tagmatch(tag_results, stored_tag, req_tag);   //check for tag match
    and hit_miss(hitstatus, tag_results, stored_valid);            //check for hit/miss

    assign #1 instruction = ((req_offset == 0)  ) ? stored_block[31:0]:      //assign read data to output.happens parallel with tag comparison
                          ((req_offset == 1)  ) ? stored_block[63:32]:     //this output is not taken until hit happens. If a miss happens
                          ((req_offset == 2)  ) ? stored_block[95:64]:    //busywait = 1 will make sure register file will not take this value
                            stored_block[127:96];
    
    always @(instruction)
    begin
    	if (hitstatus == 1) 	//at hit send instruction to cpu
    	begin
    		READDATA = instruction;
    	end
    	else 
    	begin 					//else send garbage value
    		READDATA = 32'bx;		
    	end
    end
   
    parameter IDLE = 2'b00, MEM_READ = 2'b01, CACHE_UPDATE = 2'b10;  //to hold required states
    reg [1:0] state, next_state;        //to store current and next states


    always @(*)
    begin
        case (state)
            IDLE:          //this block determines functionality, state transition in IDLE state according to inputs
                if (!hitstatus)  
                    next_state = MEM_READ;                
                else
                    next_state = IDLE;
            
            MEM_READ:       //this block determines functionality, state transition in MEM_READ state according to inputs. Reads blocks from memory
                if (!ins_busywait)  //if not busy go to next state
                    next_state = CACHE_UPDATE;
                else                //else stay in this state
                    next_state = MEM_READ;                     

            CACHE_UPDATE:   //this state update the cache with block from memory
                next_state = IDLE;  //always next state is idle

        endcase
    end


    always @(*)
    begin
        case(state)
            IDLE:                   
            begin
                ins_read = 0;           //not read from memory
                ins_address = 6'dx;     //memory address dont care
                //busywait = 0;
            end
         
            MEM_READ: 
            begin
                ins_read = 1;           //read from memory
                ins_address = {req_tag, req_index};  //target address is the inputed address
                //busywait = 1;
            end
                        
            CACHE_UPDATE:
            begin
                 ins_read = 0;          //not read from memory
                 ins_address = 6'dx;    //memory address dont care
                 //busywait = 1;

                 #1                     //this part is for cache update. This happens with positive clock edge
                                        //we can implement this here because state transtits in positive edges
                data[req_index] = ins_readdata;     //write data block frommemory to correct index
                tag[req_index] = req_tag;           //update tag
                valid[req_index] = 1;               //data is valid
            end
        endcase
    end

always @(posedge clock, reset)  
    begin
        if(reset)                   //at resets state go to idle
            state = IDLE;
        else
            state = next_state;     //at positive edges state transits to next state
    end


endmodule