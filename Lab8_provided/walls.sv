module walls
(
		input [2:0] entity,
		input [9:0] entityX,
		input [9:0] entityY,
		input direction,
		input Clk,
		output allowed
);

// mem has width of 2 bits and a total of 63488 addresses
logic [1:0] mem[0:63487];
logic [1:0] oneBitDepth[0:1];
// logic [1:0] twoBitDepth[0:13];
// logic [1:0] threeBitDepth[0:13];

// initial
// begin
// 	 $readmemh("pacman_dummy_maze_long.txt", mem);
// end
//
// logic [4:0] index;
// logic [4:0] index2;
// logic [16:0] read_address;
// logic [16:0] read_address2;
//
// //"0x000000", "0xffff00", "0x2121ff", "0x00ffff", "0xff0000", "0x00ff00", "0x47b9ae"
// // [black, blue, pink]
// always_comb
// 	begin
// 		unique case(direction)
// 					2'b00: //up
// 					begin
// 						read_address = entityX + ((entityY-1) << 8);
// 						read_address2 = (entityX + 13) + ((entityY-1) << 8);
// 					end
//
// 					2'b01: //left
// 					begin
// 						read_address = (entityX - 1) + (entityY << 8);
// 						read_address2 = (entityX - 1) + ((entityY+13) << 8);
// 					end
//
// 					2'b10: //down
// 					begin
// 						read_address = entityX + ((entityY+14) << 8);
// 						read_address2 = (entityX + 13) + ((entityY+14) << 8);
// 					end
//
// 					2'b11: //right
// 					begin
// 						read_address = (entityX + 14) + (entityY << 8);
// 						read_address2 = (entityX + 14) + ((entityY+13) << 8);
// 					end
// 				endcase
//
// 			index = mem[read_address];
// 			index2 = mem[read_address2];
//
// 		allowed = 1'b1;
// 		oneBitDepth[0] = index;
// 		oneBitDepth[1] = index2;
//
// 		unique case(entity)
// 			7'd1: //pacman
// 				begin
// 					if(oneBitDepth[0]!=2'b00 || oneBitDepth[1]!=2'b00)
// 							allowed = 1'b0;
// 				end
//
// 			7'd3: //ghost
// 				begin
// 					if (oneBitDepth[0]==2'b01 || oneBitDepth[1]==2'b01)
// 							allowed = 1'b0;
// 				end
//
// 			default:
// 				begin
// 					allowed = 1'b0;
// 				end
// 		endcase
//
// end
//
// always_ff @ (posedge Clk) begin
//
// end
//
// endmodule
logic [2:0] bitmap [35:0][27:0];

	always_comb begin
		bitmap[0]  = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		bitmap[1]  = '{0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0};
		bitmap[2]  = '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
		bitmap[3]  = '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
		bitmap[4]  = '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
		bitmap[5]  = '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};
		bitmap[6]  = '{0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0};
		bitmap[7] = '{0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0};
		bitmap[8] = '{0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0};
		bitmap[9] = '{0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0};
		bitmap[10] = '{0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0};
		bitmap[11] = '{0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0};
		bitmap[12] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[13] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[14] = '{1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1};
		bitmap[15] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[16] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[17] = '{0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0};
		bitmap[18] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[19] = '{0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0};
		bitmap[20] = '{0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0};
		bitmap[21] = '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
		bitmap[22] = '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
		bitmap[23] = '{0,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0};
		bitmap[24] = '{0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0};
		bitmap[25] = '{0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0};
		bitmap[26] = '{0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0};
		bitmap[27] = '{0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0};
		bitmap[28] = '{0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0};
		bitmap[29] = '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};
		bitmap[30] = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	end

assign allows = bitmap[entityY >> 3][entityX >> 3];

endmodule
