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


module ghost ( input Clk,                // 50 MHz clock
                    Reset,              // Active-high reset signal
                    frame_clk,          // The clock indicating a new frame (~60Hz)
      input [9:0]   DrawX, DrawY,       // Current pixel coordinates
      input [1:0]   ghosttype,
      input lose_game,
output logic  is_ghost,          // Whether current pixel belongs to ball or background
output logic [9:0]  spriteAddrX,        // relative to the sprite, which pixel we are drawing
output logic [9:0]  spriteAddrY,        // relative to the sprite, which pixel we are drawing
output logic [1:0]  dir                 // what direction is pacman facing
              );

  // parameter [9:0] ghost_X_start = 10'd298;   // top left of ghost box 208+90
  // parameter [9:0] ghost_Y_start = 10'd222;   // 116+106

  parameter [9:0] ghost_X_start = 10'd277;   // top left of ghost box 208+90
  parameter [9:0] ghost_Y_start = 10'd201;   // 116+106

  parameter [9:0] ghost_X_Min = 10'd208;       // Leftmost point on the X axis
  parameter [9:0] ghost_X_Max = 10'd432;     // Rightmost point on the X axis
  parameter [9:0] ghost_Y_Min = 10'd116;       // Topmost point on the Y axis
  parameter [9:0] ghost_Y_Max = 10'd364;     // Bottommost point on the Y axis

  parameter [9:0] ghost_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] ghost_Y_Step = 10'd1;      // Step size on the Y axis
  parameter [9:0] ghost_Size = 10'd13;       // Ball size

  logic [9:0] ghost_X_Pos, ghost_X_Motion, ghost_Y_Pos, ghost_Y_Motion;
  logic [9:0] ghost_X_Pos_in, ghost_X_Motion_in, ghost_Y_Pos_in, ghost_Y_Motion_in;
  logic [1:0] direction;

  logic [1:0] curDir, nextDir, future_dir;

  assign dir = curDir;

  logic allowed;
  walls ghost_maze_walls(.entity(3'b001), .entityX(ghost_X_Pos + ghost_X_Motion - 208 + 7), .entityY(ghost_Y_Pos + ghost_Y_Motion - 116 + 7), .direction(curDir), .allowed(allowed));

  logic [31:0] randout;
  lsfr pseudorand(.clk_i(Clk), .rst_i(Reset), .ghosttype(ghosttype), .rand_o(randout));

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end
  // Update registers
  always_ff @ (posedge Clk) begin
    if (Reset) begin
      if (ghosttype == 2'b00)
        begin
          ghost_X_Pos <= ghost_X_start;
          ghost_Y_Pos <= ghost_Y_start;
        end
      else if (ghosttype == 2'b01)
        begin
          ghost_X_Pos <= ghost_X_start + 24;
          ghost_Y_Pos <= ghost_Y_start;
        end
      else if (ghosttype == 2'b10)
        begin
          ghost_X_Pos <= ghost_X_start + 48;
          ghost_Y_Pos <= ghost_Y_start;
        end
      else if (ghosttype == 2'b11)
        begin
          ghost_X_Pos <= ghost_X_start + 72;
          ghost_Y_Pos <= ghost_Y_start;
        end
      else
        begin
          ghost_X_Pos <= ghost_X_start;
          ghost_Y_Pos <= ghost_Y_start;
        end
      ghost_X_Motion <= 10'd0;
      ghost_Y_Motion <= 10'd0;
		  curDir <= 3;
    end
    else begin
      ghost_X_Pos <= ghost_X_Pos_in;
      ghost_Y_Pos <= ghost_Y_Pos_in;
      ghost_X_Motion <= ghost_X_Motion_in;
      ghost_Y_Motion <= ghost_Y_Motion_in;
		  curDir <= nextDir;
      if(lose_game)
        begin
          ghost_X_Pos <= 0;
          ghost_Y_Pos <= 0;
        end
    end
  end
//////// Do not modify the always_ff blocks. ////////

// You need to modify always_comb block.
  always_comb begin
    // By default, keep motion and position unchanged
    ghost_X_Pos_in = ghost_X_Pos;
    ghost_Y_Pos_in = ghost_Y_Pos;
    ghost_X_Motion_in = ghost_X_Motion;
    ghost_Y_Motion_in = ghost_Y_Motion;
    nextDir = curDir;


	 direction = randout%4;

    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge) begin
      if (ghost_X_Motion_in==0 && ghost_Y_Motion_in==0)
        begin
          unique case (direction)
            2'b00: // w
              begin
                ghost_Y_Motion_in = (~(ghost_Y_Step) + 1'b1);
                ghost_X_Motion_in = 0;
                nextDir = 0;
              end
            2'b01: // a
              begin
                ghost_X_Motion_in = (~(ghost_X_Step) + 1'b1);
                ghost_Y_Motion_in = 0;
                nextDir = 1;
              end
            2'b10: // s
              begin
                ghost_Y_Motion_in = ghost_Y_Step;
                ghost_X_Motion_in = 0;
                nextDir = 2;
              end
            2'b11: // d
              begin
                ghost_X_Motion_in = ghost_X_Step;
                ghost_Y_Motion_in = 0;
                nextDir = 3;
              end
            default:
              begin
                ghost_X_Motion_in = ghost_X_Motion;
                ghost_Y_Motion_in = ghost_Y_Motion;
    				    nextDir = curDir;
              end
          endcase
        end
    // Be careful when using comparators with "logic" datatype because compiler treats
    //   both sides of the operator as UNSIGNED numbers.
    // e.g. ghost_Y_Pos - ghost_Size <= ghost_Y_Min
    // If ghost_Y_Pos is 0, then ghost_Y_Pos - ghost_Size will not be -4, but rather a large positive number.
    if( ghost_Y_Pos + ghost_Size >= ghost_Y_Max && ghost_Y_Motion_in == ghost_Y_Step)  // pacman is at the bottom edge
      begin
        ghost_Y_Motion_in = 0;
        ghost_Y_Pos_in = ghost_Y_Max - ghost_Size;
        ghost_X_Pos_in = ghost_X_Pos + ghost_X_Motion;
      end

    else if ( ghost_Y_Pos <= ghost_Y_Min && ghost_Y_Motion_in > ghost_Y_Step)  // pacman is at the top edge
      begin
        ghost_Y_Motion_in = 0;
        ghost_Y_Pos_in = ghost_Y_Min;
        ghost_X_Pos_in = ghost_X_Pos + ghost_X_Motion;
      end

    // TODO: Add other boundary detections and handle keypress here.
    else if( ghost_X_Pos + ghost_Size >= ghost_X_Max && ghost_X_Motion_in == ghost_X_Step)  // pacman is at the right edge
      begin
        ghost_X_Motion_in = 0;
        ghost_X_Pos_in = ghost_X_Max - ghost_Size;
        ghost_Y_Pos_in = ghost_Y_Pos + ghost_Y_Motion;
      end

    else if ( ghost_X_Pos <= ghost_X_Min && ghost_X_Motion_in > ghost_X_Step)  // pacman is at the left edge
      begin
        ghost_X_Motion_in = 0;
        ghost_X_Pos_in = ghost_X_Min;
        ghost_Y_Pos_in = ghost_Y_Pos + ghost_Y_Motion;
      end
    else if (allowed)
      begin
        // Update the pacman's position with its motion
        ghost_X_Pos_in = ghost_X_Pos + ghost_X_Motion;
        ghost_Y_Pos_in = ghost_Y_Pos + ghost_Y_Motion;
      end
    else
      begin
        ghost_X_Pos_in = ghost_X_Pos;
        ghost_Y_Pos_in = ghost_Y_Pos;
        ghost_Y_Motion_in = 0;
        ghost_X_Motion_in = 0;
      end
    end
  end

// Compute whether the pixel corresponds to pacman or background
/* Since the multiplicants are required to be signed, we have to first cast them
from logic to int (signed by default) before they are multiplied. */
always_comb begin
  is_ghost = 1'b0;
  spriteAddrX = 1'b0;
  spriteAddrY = 1'b0;
  if (DrawX >= ghost_X_Pos && DrawX <= ghost_X_Pos + ghost_Size)
    begin
    if (DrawY >= ghost_Y_Pos && DrawY <= ghost_Y_Pos + ghost_Size)
      begin
//		  is_pacman = 1'b0000111;
        is_ghost = 1;
        spriteAddrX = DrawX - ghost_X_Pos;
        spriteAddrY = DrawY - ghost_Y_Pos;
      end
    end
end

endmodule
