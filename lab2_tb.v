`timescale 1ns/1ns

module lab2_tb;

reg clk_50M;
reg reset_n;  //low active
reg key0;     //low active
reg clk_sma;  // test clock
reg [3:0] key;
wire [7:0] lcd_data;
wire lcd_en;
wire lcd_rw;
wire lcd_rs;
wire lcd_on;
wire lcd_blon;

wire [2:0] state,state_next;
wire [3:0] ntust_state, next_ntust_state;
wire [3:0] digit_state, next_digit_state;
wire force_sec, force_min, force_hr;

lab2 u1(
                //////// CLOCK //////////
                .CLOCK_50(clk_50M),
                .KEY(key),
                //////// LCD //////////
                .LCD_DATA(lcd_data),
                .LCD_EN(lcd_en),
                .LCD_RW(lcd_rw),
                .LCD_RS(lcd_rs),
                .LCD_ON(lcd_on),
                .LCD_BLON(lcd_blon),
                //////////////////////       
					 .state(state),
					 .state_next(state_next),
					 .ntust_state(ntust_state),
					 .next_ntust_state(next_ntust_state),
					 .digit_state(digit_state),
					 .next_digit_state(next_digit_state),
					 
					 .force_sec(force_sec),
					 .force_min(force_min),
					 .force_hr(force_hr)
        );  

always
  #10 clk_50M = ~clk_50M;
  

initial
  begin
   
  clk_50M = 0 ;  
  key[0] = 1;
  key[1] = 1;
  key[2] = 1;
  key[3] = 0;  // reset_n

  
  #30 key[3] = 1;  // reset_n  
  
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  #2_000_00
  key[2] = 0;     // key0 press
  #12_000_00
  key[2] = 1;     // key0 release
  
  //#400_000_000; // simualtion 400ms
  //$stop;
  end
  /*
initial
  begin
  $monitor("time = %3d,key[0]= %d,key[1]= %d,key[2]= %d,key[3]= %d",$time,key[0],key[1],key[2],key[3]);
  end
  
//////// LCD monitor   /////////////////
always@(negedge lcd_en)
  begin
  if(lcd_rw)  //LCD read
    begin
	if(lcd_rs) // Data
                        $display("time = %3d,read_data lcd_data = %X,lcd_on = %d",$time, lcd_data , lcd_on);
	else       // Instruction
	  $display("time = %3d,read_instruction lcd_data = %X,lcd_on = %d",$time, lcd_data , lcd_on);
	end
  else        // LCD Write
    begin
	if(lcd_rs) // Data
                       $display("time = %3d,write_data lcd_data = %X,lcd_on = %d",$time, lcd_data , lcd_on);
	else       // Instruction
	  $display("time = %3d,write_instruction lcd_data = %X,lcd_on = %d",$time, lcd_data, lcd_on);
	end
  end
  */
  
endmodule
