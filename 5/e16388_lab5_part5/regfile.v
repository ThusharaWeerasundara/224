
/*
E/16/388
Lab 05 part 2
Regfile
*/
module regfile(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);        //register file module
/*
    Can write a value t0 the registry file from a given 8bit value from a 3 bit address and can read 2 stored 
    8bit values from a given 3bit 2 addresses.Time delays are present to make it realistic.
    Writing is synchronus.Reset,Read asynchronus. 
*/

    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;        //to provide addresses
    input [7:0] IN;                                         //to provide value to be written in resiter file

    input CLK, WRITE, RESET;                                //Clock, Write enable, Reset signals

    output reg [7:0] OUT1, OUT2;                            //to provide 2 values to be read from register file

    reg [7:0] register_file[7:0];                           //8x8 register file to store bbit values
    
    integer i = 0;                                          //to use as a counter in Resetting

    always @ (posedge CLK or posedge RESET)                 //always block to Reset and synchronus write operation
    begin
        
        if(WRITE && !RESET)                                 //of WRITE enable and RESET disable write to register_file
        begin
            #2                                              //delay of 2 time units for Write operation
            register_file[INADDRESS] = IN;                  //After positive edge of RESET, this wont happen until RESET = 0
        end

        if(RESET)                                           //If RESET is ENABLE after positive edge of RESET , Reset register_file
        begin
            #2                                              //delay of 2 time units for Reset operation
            for (i=0; i<8; i++)
              begin
                register_file[i] = 8'b00000000;             //store 0 in all positions
              end
        end

    end


    always @(register_file[OUT1ADDRESS] or register_file[OUT2ADDRESS])     //sensitive to changees in reading values of register_file
    #2                                                                     //delay of 2 time units to read operation
    begin
            OUT1 =  register_file[OUT1ADDRESS];                             //read the value stored at given address
            OUT2 =  register_file[OUT2ADDRESS];
     end

endmodule










