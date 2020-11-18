//module for tag comparison
`timescale 1ns/100ps
module tagcomparator(results, stored_tag, current_tag);


input  [2:0] current_tag, stored_tag; 	//inputed address tag and tag in cahce
output reg results;	//results
wire t, r1, r2, r3;	//intermediate wires

		xnor t1(r1, stored_tag[0], current_tag[0] );	//using xnor gates to each bits to check their equality
		xnor t1(r2, stored_tag[1], current_tag[1] );
		xnor t1(r3, stored_tag[2], current_tag[2] );

		and tagcomparison(t, r1, r2, r3);				//use and gate to check whether all are rsults from above 1 or not

		always @(t)					
		begin
		#0.9												//tag comparison delay
			results = t;		
		end


endmodule		