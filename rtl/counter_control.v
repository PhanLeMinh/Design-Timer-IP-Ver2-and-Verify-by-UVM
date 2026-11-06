module counter_control(
	input       clk,
	input       rst_n,
	input       div_en,
	input [3:0] div_val,
	input       halt_req, // from register
	input       timer_en,
	input       div_mode, // from register
	input       pwm_en, // from register
	input[15:0] prescaler, // from register
	output      cnt_en,
	output      pwm_tick
);
// Khai bao
wire default_mode; 
wire control_mode;
wire cnt_rst;
wire [15:0] int_cnt_nxt;
reg  [15:0] int_cnt;
reg  [7:0] limit_pow2;
wire [15:0] active_limit;

assign active_limit = div_mode ? prescaler : {8'b0,limit_pow2};

assign default_mode = !div_en & timer_en;
assign control_mode = div_en & timer_en & (int_cnt == active_limit);
assign cnt_rst = !timer_en || !div_en || (int_cnt == active_limit); 

always @(*)
begin
	case(div_val)
		4'b0001: limit_pow2 = 8'd1;	
		4'b0010: limit_pow2 = 8'd3;
		4'b0011: limit_pow2 = 8'd7;
		4'b0100: limit_pow2 = 8'd15;
		4'b0101: limit_pow2 = 8'd31;
		4'b0110: limit_pow2 = 8'd63;
		4'b0111: limit_pow2 = 8'd127;
		4'b1000: limit_pow2 = 8'd255;
		default: limit_pow2 = 8'd0;
	endcase	
end

assign int_cnt_nxt = (halt_req & !pwm_en) ? int_cnt :
	                        cnt_rst   ? 16'b0 : int_cnt + 1'b1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		int_cnt <= 16'h0;
	end
	else begin
		int_cnt <= int_cnt_nxt;
	end
end
assign cnt_en = (default_mode || control_mode) & !halt_req & !pwm_en;
assign pwm_tick = (default_mode || control_mode) & pwm_en;
endmodule
