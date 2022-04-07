module data_sender(
	//System
	input				clk,
	input				reset_n,	
	//Data_input
	input  [7:0]	data,		//data_in
	input 			rs,		//instruction?
	
	input				send,
	
	output [7:0]	LCD_DATA,//data_out
	output			LCD_EN, 	//pulse
	output			LCD_RS,	//instruction?
	
	output			done		//=count_40u == 40us?
);
	
	assign done = count_40u == 11'd2_000;
	
	parameter start = 0, init = 1,hi_en = 2, low_en = 3, delay = 4;
	reg [2:0] state, next_state;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) state <= 0;
		else state <= next_state;
	end
	
	always@(*)begin
		case(state)
			start: next_state = (send) 						? 	init		:	start;
			init:	 next_state = (count_500ns == 5'd8) 	? 	hi_en 	: 	init;
			hi_en: next_state = (count_500ns == 5'd23)	? 	low_en	: 	hi_en;
			low_en:next_state = (count_500ns == 5'd30)	? 	delay		: 	low_en;
			delay: next_state = (count_40u == 11'd2_000)	?	start		:	delay;
			
		endcase
	end
	
	//state machine time counter
	reg [4:0] count_500ns;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) count_500ns <= 5'd0;
		else if(state != start || state != delay)begin
			if(count_500ns == 5'd30) count <= 5'd0;
			else count_500ns <= 5'd0;
		end
		else count_500ns <= 5'd0;
	end
	
	//delay counter
	reg [10:0] count_40u;
	always@(posedge clk,negedge reset_n)begin
		if(!reset_n) count_40u <= 11'd0;
		else if(state == delay)begin //if state is delay
			if(count_40u == 11'd2_000) count_40u <= 11'd0;
			else count_40u <= count_40u + 11'd1; 
		end			//if state is not delay
		else count_40u <= 11'd0;
	end
	
	always@(*)begin
		case(state)
			start: begin
				LCD_RS = rs;
				LCD_DATA = data;
				LCD_EN = 1'b0;
			end
			init : begin
				LCD_RS = rs;
				LCD_DATA = data;
				LCD_EN = 1'b0;
			end
			hi_en: begin
				LCD_RS = rs;
				LCD_DATA = data;
				LCD_EN = 1'b1;
			end
			low_en: begin
				LCD_RS = rs;
				LCD_DATA = data;
				LCD_EN = 1'b0;
			end
			delay: begin	
				LCD_RS = rs;
				LCD_DATA = data;
				LCD_EN = 1'b0;
			end
			
		endcase
	end
	
endmodule 