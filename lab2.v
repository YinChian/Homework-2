module lab2(
	
	//SYS//
	input 			CLOCK_50,
	input	 [3:0]	KEY,
	 
	//LCD//
	output [7:0]	LCD_DATA,
	output			LCD_EN,
	output			LCD_RW,
	output			LCD_RS,
	output 			LCD_ON,
	output 			LCD_BLON,
	
	output [2:0] state,state_next,
	output [3:0] ntust_state, next_ntust_state,
	output [3:0] digit_state, next_digit_state
	
);
	
	wire oneSec;
	wire reset_n = KEY[3];
	mod_1sec u1(
		.clk(CLOCK_50),
		.reset(reset_n),
		.oneHz(oneSec)
	);
	
	//Debounce for Sec
	wire force_sec_long,force_sec;
	debounce d1(
		.CLOCK_50(CLOCK_50),
		.reset_n(reset_n),
		.btn_i(KEY[0]),
		.btn_o(force_sec_long)
	);
	edge_detect e1(
		.clk(CLOCK_50),
		.rst_n(reset_n),
		.data_in(force_sec_long),
		.pos_edge(force_sec)
	);
	
	//Debounce for Min
	wire force_min_long,force_min;
	debounce d2(
		.CLOCK_50(CLOCK_50),
		.reset_n(reset_n),
		.btn_i(KEY[1]),
		.btn_o(force_min_long)
	);
	edge_detect e2(
		.clk(CLOCK_50),
		.rst_n(reset_n),
		.data_in(force_min_long),
		.pos_edge(force_min)
	);
	
	//Debounce for Hour
	wire force_hr_long,force_hr;
	debounce d3(
		.CLOCK_50(CLOCK_50),
		.reset_n(reset_n),
		.btn_i(KEY[2]),
		.btn_o(force_hr_long)
	);
	edge_detect e3(
		.clk(CLOCK_50),
		.rst_n(reset_n),
		.data_in(force_hr_long),
		.pos_edge(force_hr)
	);
	
	//the counter
	wire [3:0] sec_l,sec_h,min_l,min_h,hr_l,hr_h;
	wire change;
	counter c(
		.CLOCK_50(CLOCK_50),
		.reset_n(reset_n),
		.oneSec(oneSec),
		
		.force_sec(force_sec),
		.force_min(force_min),
		.force_hr(force_hr),
		
		//time
		.sec_l(sec_l),
		.sec_h(sec_h),
		.min_l(min_l),
		.min_h(min_h),
		.hr_l(hr_l),
		.hr_h(hr_h),
		
		.change(change)
	);
	
	
	lcm_ctrl ctrl(
		
		//sys
		.clk(CLOCK_50),
		.reset_n(reset_n),
		
		//change signal
		.change(change),
		
		//time
		.sec_l(sec_l),
		.sec_h(sec_h),
		.min_l(min_l),
		.min_h(min_h),
		.hr_l(hr_l),
		.hr_h(hr_h),
		
		//dynamic
		.LCD_DATA(LCD_DATA),
		.LCD_RS(LCD_RS),
		.LCD_EN(LCD_EN),
		
		//static
		.LCD_RW(LCD_RW),
		.LCD_ON(LCD_ON),
		.LCD_BLON(LCD_BLON),
		
		//Debug
		
		.state(state),
		.next_state(state_next),
		.ntust_state(ntust_state),
		.next_ntust_state(next_ntust_state),
		.digit_state(digit_state),
		.next_digit_state(next_digit_state)
			
	);
	

endmodule