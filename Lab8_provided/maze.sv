//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module maze ( input Clk,                // 50 MHz clock
                    Reset,              // Active-high reset signal
                    frame_clk,          // The clock indicating a new frame (~60Hz)
       input [9:0]  DrawX, DrawY,       // Current pixel coordinates
output logic is_maze,          // Whether current pixel belongs to ball or background
output logic [9:0]  spriteAddrX,        // relative to the sprite, which pixel we are drawing
output logic [9:0]  spriteAddrY        // relative to the sprite, which pixel we are drawing
              );

  parameter [9:0] maze_X_start = 10'd208;   // Center position on the X axis
  parameter [9:0] maze_Y_start = 10'd116;   // Center position on the Y axis
  parameter [9:0] maze_width = 10'd223;       // Ball size
  parameter [9:0] maze_height = 10'd247;       // Ball size

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end

always_comb begin
  is_maze = 0;
  spriteAddrX = 1'b0;
  spriteAddrY = 1'b0;
  if (DrawX >= maze_X_start && DrawX <= maze_X_start + maze_width)
    begin
    if (DrawY >= maze_Y_start && DrawY <= maze_Y_start + maze_height)
      begin
		  is_maze = 1;
        spriteAddrX = DrawX - maze_X_start;
        spriteAddrY = DrawY - maze_Y_start;
      end
    end
end

endmodule
