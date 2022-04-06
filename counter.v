module counter(
	input CLOCK_50,
	input reset_n,
	input oneSec,
	
	input froce_sec,
	input force_min,
	input force_hr,
	
	output reg [3:0] sec_l,
	output reg [3:0] sec_h,
	output reg [3:0] min_l,
	output reg [3:0] min_h,
	output reg [3:0] hr_l,
	output reg [3:0] hr_h,
	
);
	
	always@(posedge CLOCK_50M,negedge reset_n)begin
		if(!reset_n)begin
			sec_l <= 4'd0;
			sec_h <= 4'd0;
		end
		else if(oneSec||force_sec) begin
		
			if(sec_l < 4'd9) sec_l <= sec_l + 4'd1;
			else if(sec_l == 4'd9 && sec_h < 4'd5)begin
				sec_l <= 4'd0;
				sec_h <= sec_h + 4'd1;
			end
			else if(sec_l == 4'd9 && sec_h == 4'd5)begin
				sec_h <= 4'd0;
				sec_l <= 4'd0;
			end
		end
	end
	
	always@(posedge CLOCK_50M,negedge reset_n)begin
		if(!reset_n)begin
			min_l <= 4'd0;
			min_h <= 4'd0;
		end
		else if((min_l == 4'd9 && min_h == 4'd5)||force_min) begin
		
			if(min_l < 4'd9) min_l <= min_l + 4'd1;
			else if(min_l == 4'd9 && min_h < 4'd5)begin
				min_l <= 4'd0;
				min_h <= min_h + 4'd1;
			end
			else if(min_l == 4'd9 && min_h == 4'd5)begin
				min_h <= 4'd0;
				min_l <= 4'd0;
			end
		end
	end
	
	always@(posedge CLOCK_50M,negedge reset_n)begin
		if(!reset_n)begin
			hr_l <= 4'd0;
			hr_h <= 4'd0;
		end
		else if((hr_l == 4'd9 && hr_h == 4'd5)||force_hr) begin
		
			if(hr_l < 4'd9) hr_l <= hr_l + 4'd1;
			else if(hr_l == 4'd9 && hr_h < 4'd2)begin
				hr_l <= 4'd0;
				hr_h <= hr_h + 4'd1;
			end
			else if(hr_l == 4'd3 && hr_h == 4'd2)begin
				hr_h <= 4'd0;
				hr_l <= 4'd0;
			end
		end
	end
	
endmodule 