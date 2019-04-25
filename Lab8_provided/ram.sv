/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameRAM
(
		input [16:0] read_address,
		input [16:0] read_address2,
		input Clk,
		output logic [23:0] data_Out,
		output logic [23:0] data_Out2
);

// mem has width of 3 bits and a total of 153600 addresses
logic [3:0] mem [0:126975];


initial
begin
	 $readmemh("pacman_dummy_sprites.txt", mem);
end

logic [4:0] index;
logic [4:0] index2;

//"0x000000", "0xffff00", "0x2121ff", "0x00ffff", "0xff0000", "0x00ff00", "0x47b9ae"
//"0xf8bb55", "0xfab9b0", "0xfcb5ff", "0xde9751", "0xe0ddff", "0x000000", "0xffffff"
always_comb
	begin
		unique case(index)
			5'd0:
				data_Out = 24'h000000;
			5'd1:
				data_Out = 24'hffff00;
			5'd2:
				data_Out = 24'h2121ff;
			5'd3:
				data_Out = 24'h00ffff;
			5'd4:
				data_Out = 24'hff0000;
			5'd5:
				data_Out = 24'h00ff00;
			5'd6:
				data_Out = 24'h47b9ae;
			5'd7:
				data_Out = 24'hf8bb55;
			5'd8:
				data_Out = 24'hfab9b0;
			5'd9:
				data_Out = 24'hfcb5ff;
			5'd10:
				data_Out = 24'hde9751;
			5'd11:
				data_Out = 24'he0ddff;
			5'd12:
				data_Out = 24'h000000;
			5'd13:
				data_Out = 24'hffffff;
			default:
				data_Out = 24'h000000;
		endcase

		unique case(index2)
			5'd0:
				data_Out2 = 24'h000000;
			5'd1:
				data_Out2 = 24'hffff00;
			5'd2:
				data_Out2 = 24'h2121ff;
			5'd3:
				data_Out2 = 24'h00ffff;
			5'd4:
				data_Out2 = 24'hff0000;
			5'd5:
				data_Out2 = 24'h00ff00;
			5'd6:
				data_Out2 = 24'h47b9ae;
			5'd7:
				data_Out2 = 24'hf8bb55;
			5'd8:
				data_Out2 = 24'hfab9b0;
			5'd9:
				data_Out2 = 24'hfcb5ff;
			5'd10:
				data_Out2 = 24'hde9751;
			5'd11:
				data_Out2 = 24'he0ddff;
			5'd12:
				data_Out2 = 24'h000000;
			5'd13:
				data_Out2 = 24'hffffff;
			default:
				data_Out2 = 24'h000000;
		endcase
end

always_ff @ (posedge Clk) begin
	index <= mem[read_address];
	index2 <= mem[read_address2];
end

endmodule
