/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  vik_ram
(
		input [16:0] read_address,
		input Clk,
		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 153600 addresses
logic [3:0] mem [0:46335];


initial
begin
	 $readmemh("vikramHD.txt", mem);
end

logic [4:0] index;

//["0x3f3539", "0xb07672", "0xe6caab", "0x586643", "0x452a0a", "0xaa4336", "0xaaaeb1", "0x3d3430", "0x566140", "0xd6b6b0", "0xae512f"]
always_comb
	begin
		unique case(index)
			5'd0:
				data_Out = 24'h000000;//
			5'd1:
				data_Out = 24'he1deff;//
			5'd2:
				data_Out = 24'hd0ae99;//
			5'd3:
				data_Out = 24'hc5a67f;//
			5'd4:
				data_Out = 24'h2e1e1d;//
			5'd5:
				data_Out = 24'h3f3539;
			5'd6:
				data_Out = 24'hb07672;
			5'd7:
				data_Out = 24'he6caab;
			5'd8:
				data_Out = 24'h586643;
			5'd9:
				data_Out = 24'h452a0a;
			5'd10:
				data_Out = 24'haa4336;
			5'd11:
				data_Out = 24'haaaeb1;
			5'd12:
				data_Out = 24'h3d3430;
			5'd13:
				data_Out = 24'h566140;
			5'd14:
				data_Out = 24'hd6b6b0;
			5'd15:
				data_Out = 24'hae512f;
			default:
				data_Out = 24'h000000;
		endcase
end

always_ff @ (posedge Clk) begin
	index <= mem[read_address];
end

endmodule
