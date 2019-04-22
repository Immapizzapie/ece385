/*
	https://electronics.stackexchange.com/questions/202876/how-can-i-generate-a-1-hz-clock-from-50-mhz-clock-coming-from-an-altera-board
*/

module slowClock (
	input Clk,
	input Reset,
	output Clk_slow
);

	logic [24:0] counter;

	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			counter <= 25'b0;
			Clk_slow <= 1'b0;
		end
		else if (counter == 25'd12999999) begin
			counter <= 25'b0;
			Clk_slow <= ~Clk_slow;
		end else begin
			counter <= counter + 1;
		end

	end
endmodule
