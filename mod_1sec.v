module mod_1sec(
	input clk,
	input reset,
	output reg oneHz
);
	
	reg [25:0] counter;
	always@(posedge clk,negedge reset)begin
		if(!reset) 
			counter <= 26'd0;
		else begin
			if(counter == 26'd50_000_000) counter <= 26'd0; //Pratical
			//if(counter == 26'd50_000) counter <= 26'd0;	//Testing
			else counter <= counter + 26'd1;
		end
	end
	
	always@(*)begin
		if(counter == 26'd50_000_000) oneHz = 1'b1;	//Pratical
		//if(counter == 26'd50_000) oneHz = 1'b1;		//Testing
		else oneHz = 1'b0;
	end
	
endmodule