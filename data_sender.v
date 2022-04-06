module data_sender(
	input				clk,
	input				reset_n,
	input  [7:0]	data,
	input 			rs,
	
	output [7:0]	LCD_DATA,
	output			LCD_EN,
	output			LCD_RW,
	output			LCD_RS,
	output 			LCD_ON,
	output 			LCD_BLON
);

	reg [10:0] count_40u;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) count_40u <= 11'd0;
		else if(count_40u == 11'd2_000) count_40u <= count_40u;
		else count_40u <= count_40u + 11'd1;
	end
	
	
endmodule 