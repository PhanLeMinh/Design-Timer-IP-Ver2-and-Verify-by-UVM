module apb_slave(
	input clk,	
	input rst_n,
	input psel,
	input pwrite,
	input penable,
	output wr_en,	
	output rd_en,
	output pready
);

assign wr_en = psel & pwrite & penable & pready;
assign rd_en = psel & !pwrite & penable & pready;

//pready
//after 1 cycle psel and penable (1,1) 
//DFF
reg pready_r;
assign pready =  pready_r;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		pready_r <= 0;
	end
	else begin
		pready_r <= psel & penable & !pready_r;
	end
end


endmodule
