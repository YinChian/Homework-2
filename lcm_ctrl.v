module lcm_ctrl(
	input clk,
	input reset_n,
	
	input 			change,
	input  [3:0] 	sec_l,
	input  [3:0] 	sec_h,
	input  [3:0] 	min_l,
	input  [3:0] 	min_h,
	input  [3:0] 	hr_l,
	input	 [3:0] 	hr_h,
	
	output reg [7:0]	LCD_DATA,
	output reg			LCD_RS,
	output reg			LCD_EN,
	
	output 			LCD_RW,
	output 			LCD_ON,
	output 			LCD_BLON,
	
	output reg [2:0] state,next_state,
	output reg [3:0] ntust_state, next_ntust_state,
	output reg [3:0] digit_state, next_digit_state
	
);
	
	//Main function's variables
	parameter start = 0,entry_mode = 1 ,ntust_clock = 2,idle = 3,send_data = 4;
	//reg [2:0] state,next_state; //Debug
	
	//Presets//
	assign LCD_RW = 1'b0;
	assign LCD_ON = 1'b1;
	assign LCD_BLON = 1'b0;
	
	//30ms counter
	reg [20:0] cnt_30m;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) cnt_30m <= 21'd0;
		else if(cnt_30m == 21'd1_500_000) cnt_30m <= cnt_30m;
		else cnt_30m <= cnt_30m + 21'd1;
	end

	//Sender//
	reg en;	//controlled by main sfm
	reg [11:0] send_counter;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) send_counter <= 12'd0;
		else if (en)begin
			if(send_counter == 12'd4095) send_counter <= 12'd0;	//read if end
			else begin
				
				send_counter <= send_counter + 12'd1;
				if(send_counter > 12'd7 && send_counter < 12'd24) LCD_EN <= 1'b1;
				else LCD_EN <=1'b0;
			end
		end
		else send_counter <= 12'd0;
	end
	
	//assign LCD_EN = send_counter > 12'd7 && send_counter < 12'd24;
	
	//End//
	
	//NTUST State//
	parameter pre = 0, n = 1, t = 2, u = 3 , s = 4, t_ = 5, sp = 6, c = 7, l = 8, o = 9, c_ = 10, k = 11, fin = 12;
	
	//reg [3:0] ntust_state, next_ntust_state;	//state registers
	
	
	reg [7:0] ntust_data;	//send back to main state machine
	wire ntust_rs;
	
	always@(posedge clk, negedge reset_n)begin
		if(!reset_n) ntust_state <= 4'd0;
		else ntust_state <= next_ntust_state;
	end
	
	//Transfer
	always@(posedge clk, negedge reset_n)begin
		if(!reset_n) next_ntust_state <= 4'd0;
		else if(send_counter == 12'd4095 && state == ntust_clock) next_ntust_state <= next_ntust_state + 4'd1;
		else next_ntust_state <= next_ntust_state;
	end
	
	//Function
	always@(posedge clk,negedge reset_n)begin
		case(ntust_state)
			pre : ntust_data <= 8'h80;
			
			n   : ntust_data = 8'h4E;
			t   : ntust_data = 8'h54;
			u   : ntust_data = 8'h55;
			s   : ntust_data = 8'h53;
			t_  : ntust_data = 8'h54;
			
			sp  : ntust_data = 8'h20;
			
			c   : ntust_data = 8'h43;
			l   : ntust_data = 8'h4C;
			o   : ntust_data = 8'h4F;
			c_  : ntust_data = 8'h43;
			k   : ntust_data = 8'h4B;
			
			default: ntust_data = 8'h00;
		endcase
	end
	assign ntust_rs = ntust_state != pre;
	//End//
	
	
	//Digit Send//
	parameter set_address = 0, sec_L = 8, sec_H = 7, dotdot_L = 6, min_L = 5, min_H = 4, dotdot_H = 3, hr_L = 2, hr_H = 1, fin_send = 9;
	//reg [3:0] digit_state, next_digit_state; 
	reg [7:0] digit_send;
	wire digit_rs;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) digit_state <= 4'd0;
		else if(state == send_data) digit_state <= next_digit_state;
		else digit_state <= digit_state;
	end
	
	//Transfer
	always@(*)begin
		
		case(digit_state)
		
			set_address:	next_digit_state = (send_counter == 12'd4095)?hr_H:set_address;
			
			hr_H:		next_digit_state = (send_counter == 12'd4095)?hr_L:hr_H;
			hr_L:		next_digit_state = (send_counter == 12'd4095)?dotdot_H:hr_L;
			
			dotdot_H:next_digit_state = (send_counter == 12'd4095)?min_H:dotdot_H;
			
			min_H:	next_digit_state = (send_counter == 12'd4095)?min_L:min_H;
			min_L:	next_digit_state = (send_counter == 12'd4095)?dotdot_L:min_L;
			
			dotdot_L:next_digit_state = (send_counter == 12'd4095)?sec_H:dotdot_L;
			
			sec_H:	next_digit_state = (send_counter == 12'd4095)?sec_L:sec_H;
			sec_L:	next_digit_state = (send_counter == 12'd4095)?fin_send:sec_L;
			
			fin_send:next_digit_state = set_address;
			
			default:	next_digit_state = set_address;
		endcase
		
	end
	
	//Function
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n)  digit_send <= 8'h0;
		else begin
			case(digit_state)
				set_address:digit_send <= 8'h40;
				
				hr_H:		digit_send <= hr_h+8'h30;
				hr_L:		digit_send <= hr_l+8'h30;
				
				dotdot_H:digit_send <= 8'h3A;
				
				sec_H:	digit_send <= sec_h+8'h30;
				sec_L:	digit_send <= sec_l+8'h30;
				
				dotdot_L:digit_send <= 8'h3A;

				min_H:	digit_send <= min_h+8'h30;
				min_L:	digit_send <= min_l+8'h30;
				
				default:	digit_send <= digit_send;
			endcase
		end
	end
	assign digit_rs = digit_state != set_address;
	
	//End//
	
	
	
	//Main State//
	
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) state <= 2'b0;
		else state <= next_state;
	end
	
	//Transfer
	always@(*)begin
		case(state)
			start			: 	next_state = (cnt_30m == 21'd1_5)?	entry_mode : start;	//Modified
			entry_mode	:	next_state = (send_counter == 12'd4095)?	ntust_clock : entry_mode;
			ntust_clock	:	next_state = (ntust_state == fin)?	idle : ntust_clock;
			idle			:	next_state = (change)?	send_data : idle ;
			send_data	:	next_state = (digit_state == fin_send)? idle : send_data;	
			default		:	next_state = start;
		endcase
	end
	
	//Function
	always@(*)begin
		case(state)
		
			start			:
			begin
				en = 1'b0;
				LCD_DATA = 8'd0;
				LCD_RS = 1'b0;
			end
			
			entry_mode	:
			begin
				en = 1'b1;
				LCD_DATA = 8'h06;
				LCD_RS = 1'b0;
			end
			
			ntust_clock	:	
			begin
				en = 1'b1;
				LCD_DATA = ntust_data;
				LCD_RS = ntust_rs;
			end
			
			idle			:	//Wait for input
			begin
				en = 1'b0;
				LCD_DATA = 8'd0;
				LCD_RS = 1'b0;
			end
			
			send_data	:	
			begin
				en = 1'b1;
				LCD_DATA = digit_send;
				LCD_RS = digit_rs;
			end
			
			default:
			begin
				en = 1'b0;
				LCD_DATA = 8'd0;
				LCD_RS = 1'b0;
			end
		endcase
	end
	
	//End//
	
endmodule 