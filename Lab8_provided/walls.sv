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

initial
begin
	 $readmemh("pacman_maze_colored.txt", mem);
end

logic [4:0] index;
logic [4:0] index2;
logic [16:0] read_address;
logic [16:0] read_address2;

//"0x000000", "0xffff00", "0x2121ff", "0x00ffff", "0xff0000", "0x00ff00", "0x47b9ae"
// [black, blue, pink]
always_comb
	begin
		
		
		allowed = 1'b1;
		oneBitDepth[0] = index;
		oneBitDepth[1] = index2;

		unique case(entity)
			7'd1: //pacman
				begin
					if(oneBitDepth[0]!=2'b00 || oneBitDepth[1]!=2'b00)
							allowed = 1'b0;
				end

			7'd3: //ghost
				begin
					if (oneBitDepth[0]==2'b01 || oneBitDepth[1]==2'b01)
							allowed = 1'b0;
				end

			default:
				begin
					allowed = 1'b0;
				end
		endcase

end

always_ff @ (posedge Clk) begin
unique case(direction)
			2'b00: //up
			begin
				read_address = entityX + ((entityY-1) << 8);
				read_address2 = (entityX + 13) + ((entityY-1) << 8);
			end

			2'b01: //left
			begin
				read_address = (entityX - 1) + (entityY << 8);
				read_address2 = (entityX - 1) + ((entityY+13) << 8);
			end

			2'b10: //down
			begin
				read_address = entityX + ((entityY+14) << 8);
				read_address2 = (entityX + 13) + ((entityY+14) << 8);
			end

			2'b11: //right
			begin
				read_address = (entityX + 14) + (entityY << 8);
				read_address2 = (entityX + 14) + ((entityY+13) << 8);
			end
		endcase
		
	index <= mem[read_address];
	index2 <= mem[read_address2];
end

endmodule
