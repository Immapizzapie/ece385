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


module pacman ( input Clk,                // 50 MHz clock
                    Reset,              // Active-high reset signal
                    frame_clk,          // The clock indicating a new frame (~60Hz)
      input [9:0]   DrawX, DrawY,       // Current pixel coordinates
      input [7:0]   keycode,            // scancode of key pressed
output logic  is_pacman,                // Whether current pixel belongs to ball or background
output logic [9:0]  spriteAddrX,        // relative to the sprite, which pixel we are drawing
output logic [9:0]  spriteAddrY,        // relative to the sprite, which pixel we are drawing
output logic [1:0]  dir                 // what direction is pacman facing
              );

  parameter [9:0] pacman_X_start = 10'd313;   // Center position on the X axis
  parameter [9:0] pacman_Y_start = 10'd249;   // Center position on the Y axis (98+208,133+116)

//  parameter [9:0] pacman_X_Min = 10'd0;       // Leftmost point on the X axis
//  parameter [9:0] pacman_X_Max = 10'd639;     // Rightmost point on the X axis
//  parameter [9:0] pacman_Y_Min = 10'd0;       // Topmost point on the Y axis
//  parameter [9:0] pacman_Y_Max = 10'd479;     // Bottommost point on the Y axis

  parameter [9:0] pacman_X_Min = 10'd208;       // Leftmost point on the X axis
  parameter [9:0] pacman_X_Max = 10'd432;     // Rightmost point on the X axis
  parameter [9:0] pacman_Y_Min = 10'd116;       // Topmost point on the Y axis
  parameter [9:0] pacman_Y_Max = 10'd364;     // Bottommost point on the Y axis

  parameter [9:0] pacman_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] pacman_Y_Step = 10'd1;      // Step size on the Y axis
  parameter [9:0] pacman_Size = 10'd14;       // Ball size

  logic [9:0] pacman_X_Pos, pacman_X_Motion, pacman_Y_Pos, pacman_Y_Motion, pacman_X_Pos_prev, pacman_Y_Pos_prev;
  logic [9:0] pacman_X_Pos_in, pacman_X_Motion_in, pacman_Y_Pos_in, pacman_Y_Motion_in;

  logic [1:0] curDir, nextDir, future_dir;

  assign dir = curDir;

  logic allowed;
  logic future_allowed;
  walls pacman_maze_walls(.entity(3'b001), .entityX(pacman_X_Pos - 208 + 7), .entityY(pacman_Y_Pos - 116 + 7), .direction(nextDir), .future_direction(future_dir), .Clk(Clk), .allowed(allowed), .future_allowed());
  // walls maze_walls(.entity(3'b001), .entityX(pacman_X_Pos + pacman_X_Motion - 208 + 7), .entityY(pacman_Y_Pos + pacman_Y_Motion - 116 + 7), .direction(nextDir), .Clk(Clk), .allowed(allowed));

  // logic future_allowed;
  // logic future_dir;
  // walls future_maze_walls(.entity(3'b001), .entityX(pacman_X_Pos + pacman_X_Motion - 208 + 7), .entityY(pacman_Y_Pos + pacman_Y_Motion - 116 + 7), .direction(future_dir), .Clk(Clk), .allowed(future_allowed));
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
      pacman_X_Pos <= pacman_X_start;
      pacman_Y_Pos <= pacman_Y_start;
      // pacman_X_Pos_prev <= 0;
      // pacman_Y_Pos_prev <= 0;
      pacman_X_Motion <= 10'd0;
      pacman_Y_Motion <= 10'd0;
		  curDir <= 3;
    end
    else begin
      // pacman_X_Pos_prev <= pacman_X_Pos;
      // pacman_Y_Pos_prev <= pacman_Y_Pos;
      pacman_X_Pos <= pacman_X_Pos_in;
      pacman_Y_Pos <= pacman_Y_Pos_in;
      pacman_X_Motion <= pacman_X_Motion_in;
      pacman_Y_Motion <= pacman_Y_Motion_in;
		  curDir <= nextDir;
    end
  end
//////// Do not modify the always_ff blocks. ////////

// You need to modify always_comb block.
  always_comb begin
    // By default, keep motion and position unchanged
    pacman_X_Pos_in = pacman_X_Pos;
    pacman_Y_Pos_in = pacman_Y_Pos;
    pacman_X_Motion_in = pacman_X_Motion;
    pacman_Y_Motion_in = pacman_Y_Motion;
    nextDir = curDir;
    // unique case(keycode)
    //   8'h1a: future_dir = 0;
    //   8'h04: future_dir = 1;
    //   8'h17: future_dir = 2;
    //   8'h07: future_dir = 3;
    //   default: future_dir = curDir;
    // endcase
    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge) begin
      unique case(keycode)
        8'h1a: future_dir = 0;
        8'h04: future_dir = 1;
        8'h17: future_dir = 2;
        8'h07: future_dir = 3;
        default: future_dir = curDir;
      endcase
      
      unique case (keycode)
        8'h1a: // w
          begin
            if(future_allowed)begin
              nextDir = 0;
              pacman_Y_Motion_in = (~(pacman_Y_Step) + 1'b1);
              pacman_X_Motion_in = 0;
            end
          end
        8'h04: // a
          begin
            if(future_allowed)begin
              nextDir = 1;
              pacman_X_Motion_in = (~(pacman_X_Step) + 1'b1);
              pacman_Y_Motion_in = 0;
            end
          end
        8'h16: // s
          begin
            if(future_allowed)begin
              nextDir = 2;
              pacman_Y_Motion_in = pacman_Y_Step;
              pacman_X_Motion_in = 0;
            end
          end
        8'h07: // d
          begin
            if(future_allowed)begin
              nextDir = 3;
              pacman_X_Motion_in = pacman_X_Step;
              pacman_Y_Motion_in = 0;
            end
          end
        default:
          begin
            pacman_X_Motion_in = pacman_X_Motion;
            pacman_Y_Motion_in = pacman_Y_Motion;
				    nextDir = curDir;
          end
      endcase

    // Be careful when using comparators with "logic" datatype because compiler treats
    //   both sides of the operator as UNSIGNED numbers.
    // e.g. pacman_Y_Pos - pacman_Size <= pacman_Y_Min
    // If pacman_Y_Pos is 0, then pacman_Y_Pos - pacman_Size will not be -4, but rather a large positive number.

    if( pacman_Y_Pos + pacman_Size >= pacman_Y_Max && pacman_Y_Motion_in == pacman_Y_Step)  // pacman is at the bottom edge
      begin
        pacman_Y_Motion_in = 0;
        pacman_Y_Pos_in = pacman_Y_Max - pacman_Size;
        pacman_X_Pos_in = pacman_X_Pos + pacman_X_Motion;
      end

    else if ( pacman_Y_Pos <= pacman_Y_Min && pacman_Y_Motion_in > pacman_Y_Step)  // pacman is at the top edge
      begin
        pacman_Y_Motion_in = 0;
        pacman_Y_Pos_in = pacman_Y_Min;
        pacman_X_Pos_in = pacman_X_Pos + pacman_X_Motion;
      end

    // TODO: Add other boundary detections and handle keypress here.
    else if( pacman_X_Pos + pacman_Size >= pacman_X_Max && pacman_X_Motion_in == pacman_X_Step)  // pacman is at the right edge
      begin
        pacman_X_Motion_in = 0;
        pacman_X_Pos_in = pacman_X_Max - pacman_Size;
        pacman_Y_Pos_in = pacman_Y_Pos + pacman_Y_Motion;
      end

    else if ( pacman_X_Pos <= pacman_X_Min && pacman_X_Motion_in > pacman_X_Step)  // pacman is at the left edge
      begin
        pacman_X_Motion_in = 0;
        pacman_X_Pos_in = pacman_X_Min;
        pacman_Y_Pos_in = pacman_Y_Pos + pacman_Y_Motion;
      end
    else if (allowed)
      begin
        // Update the pacman's position with its motion
        pacman_X_Pos_in = pacman_X_Pos + pacman_X_Motion;
        pacman_Y_Pos_in = pacman_Y_Pos + pacman_Y_Motion;
      end
    end
  end

// Compute whether the pixel corresponds to pacman or background
/* Since the multiplicants are required to be signed, we have to first cast them
from logic to int (signed by default) before they are multiplied. */
always_comb begin
  is_pacman = 0;
  spriteAddrX = 1'b0;
  spriteAddrY = 1'b0;
  if (DrawX >= pacman_X_Pos && DrawX < pacman_X_Pos + pacman_Size)
    begin
    if (DrawY >= pacman_Y_Pos && DrawY < pacman_Y_Pos + pacman_Size)
      begin
        is_pacman = 1;
        spriteAddrX = DrawX - pacman_X_Pos;
        spriteAddrY = DrawY - pacman_Y_Pos;
      end
    end
end

endmodule
