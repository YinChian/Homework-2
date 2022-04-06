module lcm_ctrl(
	input clk,
	input reset_n,
	
	input  [3:0] 	sec_l,
	input  [3:0] 	sec_h,
	input  [3:0] 	min_l,
	input  [3:0] 	min_h,
	input  [3:0] 	hr_l,
	input	 [3:0] 	hr_h,
	
	output [7:0]	LCD_DATA,
	output			LCD_EN,
	output			LCD_RW,
	output			LCD_RS,
	output 			LCD_ON,
	output 			LCD_BLON
);
	
	parameter start = 0,init = 1,idle = 2,send = 3;
	reg [1:0] state,next_state;
	
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) state <= 2'b0;
		else state <= next_state;
	end
	
	always@(*)begin
		case(state)
			start: (cnt_30m == 21'd1_500_000)? init : start;
			init : 
		endcase
	end
	
	//30ms counter
	reg [20:0] cnt_30m;
	always@(posedge clk,negedge reset)begin
		if(reset) cnt_30m <= 21'd0;
		else if(cnt_30m == 21'd1_500_000) cnt_30m <= cnt_30m;
		else cnt_30m <= cnt_30m + 21'd1;
	end
	
endmodule 