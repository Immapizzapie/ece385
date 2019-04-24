//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module color_mapper(input Clk,
							input frame_clk,
							input Reset,
							input [6:0]	entity,							// what are we currently drawing
							input [9:0] DrawX, DrawY,       // Current pixel coordinates
							input	[9:0] spriteAddrX,				// relative addresses for sprites
							input	[9:0] spriteAddrY,
							input	[9:0] mazeAddrX,				// relative addresses for sprites
							input	[9:0] mazeAddrY,
							input [1:0] direction,
			output logic [7:0]	VGA_R, VGA_G, VGA_B // VGA RGB output
);

	logic [7:0] Red, Green, Blue;

	// Output colors to VGA
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;

	logic [17:0] spriteAddr; // the location of the top left for the sprite in memory
	logic [17:0] mazeAddr;
	logic [23:0] color; // color returned by palette
	logic [23:0] color2; // color returned by palette

	frameRAM ram(.read_address(spriteAddr), .read_address2(mazeAddr), .Clk(Clk), .data_Out(color), .data_Out2(color2));

	logic [3:0] framecounter;
	logic [3:0] framecounter_in;

	logic [8:0] dumbcounter1;
	logic [8:0] dumbcounter1_in;
	logic [8:0] dumbcounter2;
	logic [8:0] dumbcounter2_in;
	logic [8:0] dumbcounter3;
	logic [8:0] dumbcounter3_in;

always_ff @ (posedge frame_clk) begin
	if (Reset) begin
		framecounter <= 0;
		dumbcounter1 <= 79;
		dumbcounter2 <= 444;
		dumbcounter3 <= 0;
	end
	else begin
		framecounter <= framecounter_in;
		dumbcounter1 <= dumbcounter1_in;
		dumbcounter2 <= dumbcounter2_in;
		dumbcounter3 <= dumbcounter3_in;
	end
end

always_comb begin
	framecounter_in = framecounter + 1;
	dumbcounter1_in = dumbcounter1 + 1;
	dumbcounter2_in = dumbcounter2 + 2;
	dumbcounter3_in = dumbcounter3 + 3;

	unique case (entity)
		7'b0000001: //1 = pacman mouth open
			begin
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				if (framecounter >= 0 && framecounter <= 3)
						spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 0) << 9); // 34, 2 for top left
				else if (framecounter >= 8 && framecounter <= 12)
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 31) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 228) + ((spriteAddrY + 16) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 49) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 0) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 0) << 9); // 34, 2 for top left
							endcase
					end
				else
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 32) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 16) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 47) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 0) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 0) << 9); // 34, 2 for top left
						endcase
					end

				if (color == 24'h000000)
					begin
						Red = dumbcounter1;
						Green = dumbcounter2;
						Blue = dumbcounter3;
						// Red = color2[23:16];
						// Green = color2[15:8];
						// Blue = color2[7:0];
//						if (color2 == 24'h000000)
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
//							begin
//								Red = dumbcounter1;
//								Green = dumbcounter2;
//								Blue = dumbcounter3;
//							end
//						else
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
					end
				else
					begin
						Red = color[23:16];
						Green = color[15:8];
						Blue = color[7:0];
					end
			end
		7'b0000010: //2 = Background
			begin
				spriteAddr = 0;
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				Red = color2[23:16];
				Green = color2[15:8];
				Blue = color2[7:0];

//				if (color2 == 24'h000000)
//					begin
//						Red = dumbcounter1;
//						Green = dumbcounter2;
//						Blue = dumbcounter3;
//					end
//				else
//					begin
//						Red = color2[23:16];
//						Green = color2[15:8];
//						Blue = color2[7:0];
//					end
			end
		7'b0000011: //3 = blinky
			begin
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				if ((framecounter >= 0 && framecounter <= 3) || (framecounter >= 8 && framecounter <= 11))
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 65) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 277) + ((spriteAddrY + 65) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 341) + ((spriteAddrY + 65) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 65) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 65) << 9); // 34, 2 for top left
							endcase
					end
				else
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 65) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 65) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 325) + ((spriteAddrY + 65) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 65) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 65) << 9); // 34, 2 for top left
						endcase
					end

				if (color == 24'h000000)
					begin
						Red = color2[23:16];
						Green = color2[15:8];
						Blue = color2[7:0];
//						if (color2 == 24'h000000)
//							begin
//								Red = dumbcounter1;
//								Green = dumbcounter2;
//								Blue = dumbcounter3;
//							end
//						else
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
					end
				else
					begin
						Red = color[23:16];
						Green = color[15:8];
						Blue = color[7:0];
					end
			end
		7'b0000100: //3 = pinky
			begin
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				if ((framecounter >= 0 && framecounter <= 3) || (framecounter >= 8 && framecounter <= 11))
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 81) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 277) + ((spriteAddrY + 81) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 341) + ((spriteAddrY + 81) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 81) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 81) << 9); // 34, 2 for top left
							endcase
					end
				else
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 81) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 81) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 325) + ((spriteAddrY + 81) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 81) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 81) << 9); // 34, 2 for top left
						endcase
					end

				if (color == 24'h000000)
					begin
						Red = color2[23:16];
						Green = color2[15:8];
						Blue = color2[7:0];
//						if (color2 == 24'h000000)
//							begin
//								Red = dumbcounter1;
//								Green = dumbcounter2;
//								Blue = dumbcounter3;
//							end
//						else
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
					end
				else
					begin
						Red = color[23:16];
						Green = color[15:8];
						Blue = color[7:0];
					end
			end
		7'b0000101: //3 = inky
			begin
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				if ((framecounter >= 0 && framecounter <= 3) || (framecounter >= 8 && framecounter <= 11))
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 97) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 277) + ((spriteAddrY + 97) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 341) + ((spriteAddrY + 97) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 97) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 97) << 9); // 34, 2 for top left
							endcase
					end
				else
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 97) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 97) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 325) + ((spriteAddrY + 97) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 97) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 97) << 9); // 34, 2 for top left
						endcase
					end

				if (color == 24'h000000)
					begin
						Red = color2[23:16];
						Green = color2[15:8];
						Blue = color2[7:0];
//						if (color2 == 24'h000000)
//							begin
//								Red = dumbcounter1;
//								Green = dumbcounter2;
//								Blue = dumbcounter3;
//							end
//						else
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
					end
				else
					begin
						Red = color[23:16];
						Green = color[15:8];
						Blue = color[7:0];
					end
			end
		7'b0000110: //3 = clyde
			begin
				mazeAddr = mazeAddrX + (mazeAddrY << 9);
				if ((framecounter >= 0 && framecounter <= 3) || (framecounter >= 8 && framecounter <= 11))
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 113) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 277) + ((spriteAddrY + 113) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 341) + ((spriteAddrY + 113) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 245) + ((spriteAddrY + 113) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 309) + ((spriteAddrY + 113) << 9); // 34, 2 for top left
							endcase
					end
				else
					begin
						unique case (direction)
							2'd0: // going up
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 113) << 9); // 70, 190 for top left
							2'd1: // going left
								spriteAddr = (spriteAddrX + 261) + ((spriteAddrY + 113) << 9); // 72, 77 for top left
							2'd2: // going down
								spriteAddr = (spriteAddrX + 325) + ((spriteAddrY + 113) << 9); // 34, 2 for top left
							2'd3: // going right
								spriteAddr = (spriteAddrX + 229) + ((spriteAddrY + 113) << 9); // 107, 40 for top left
							default:
								spriteAddr = (spriteAddrX + 293) + ((spriteAddrY + 113) << 9); // 34, 2 for top left
						endcase
					end

				if (color == 24'h000000)
					begin
						Red = color2[23:16];
						Green = color2[15:8];
						Blue = color2[7:0];
//						if (color2 == 24'h000000)
//							begin
//								Red = dumbcounter1;
//								Green = dumbcounter2;
//								Blue = dumbcounter3;
//							end
//						else
//							begin
//								Red = color2[23:16];
//								Green = color2[15:8];
//								Blue = color2[7:0];
//							end
					end
				else
					begin
						Red = color[23:16];
						Green = color[15:8];
						Blue = color[7:0];
					end
			end
		default:
			begin
				spriteAddr = 0;
				mazeAddr = 0;
				// Background with nice color gradient
				Red = dumbcounter1;
				Green = dumbcounter2;
				Blue = dumbcounter3;
			end
		endcase
end

endmodule
