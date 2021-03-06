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
      input lose_game,
      input win_game,
output logic  is_pacman,                // Whether current pixel belongs to ball or background
output logic [9:0]  spriteAddrX,        // relative to the sprite, which pixel we are drawing
output logic [9:0]  spriteAddrY,        // relative to the sprite, which pixel we are drawing
output logic [1:0]  dir,                 // what direction is pacman facing
output logic [9:0] pacman_x_position,
output logic [9:0] pacman_y_position
              );

  parameter [9:0] pacman_X_start = 10'd313;   // Center position on the X axis
  parameter [9:0] pacman_Y_start = 10'd297;   // Center position on the Y axis (98+208,133+116)
  // parameter [9:0] pacman_Y_start = 10'd249;   // Center position on the Y axis (98+208,133+116)

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
  logic [9:0] pacman_X_Motion_prev, pacman_Y_Motion_prev, prevDir;

  assign dir = prevDir;
 assign pacman_x_position = pacman_X_Pos;
 assign pacman_y_position = pacman_Y_Pos;

  // assign pacman_x_position = 0;
  // assign pacman_y_position = 0;

  logic [7:0] lastkey, lastkey_in, lastkey_buf;

  logic lol;

  logic allowed, prev_allowed;

  walls maze_walls(.entity(3'b001), .entityX(pacman_X_Pos + pacman_X_Motion - 208 + 7), .entityY(pacman_Y_Pos + pacman_Y_Motion - 116 + 7), .direction(curDir), .allowed(allowed));
  walls maze_walls2(.entity(3'b001), .entityX(pacman_X_Pos + pacman_X_Motion_prev - 208 + 7), .entityY(pacman_Y_Pos + pacman_Y_Motion_prev - 116 + 7), .direction(prevDir), .allowed(prev_allowed));

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end
  // Update registers
  always_ff @ (posedge Clk) begin
    if (Reset)
      begin
        pacman_X_Pos <= pacman_X_start;
        pacman_Y_Pos <= pacman_Y_start;
        // pacman_X_Motion <= 10'd1;
        pacman_X_Motion <= 10'd0;
        pacman_Y_Motion <= 10'd0;
  		  curDir <= 3;

        pacman_X_Motion_prev <= 10'd0;
        pacman_Y_Motion_prev <= 10'd0;
        prevDir <= 3;

        lastkey <= 8'h00;
        lastkey <= 8'h00;
      end
    else
      begin
        if (lose_game == 1 || win_game == 1)
          begin
            if (win_game)
              begin
                pacman_X_Pos <= pacman_X_Pos_in;
                pacman_Y_Pos <= pacman_Y_Pos_in;
              end
            pacman_X_Motion <= 0;
            pacman_Y_Motion <= 0;
          end
        else if (allowed)
          begin
            pacman_X_Pos <= pacman_X_Pos_in;
            pacman_Y_Pos <= pacman_Y_Pos_in;
            pacman_X_Motion <= pacman_X_Motion_in;
            pacman_Y_Motion <= pacman_Y_Motion_in;
      		  curDir <= nextDir;

            pacman_X_Motion_prev <= pacman_X_Motion;
            pacman_Y_Motion_prev <= pacman_Y_Motion;
            prevDir <= curDir;
          end
        else
          begin
            pacman_X_Pos <= pacman_X_Pos_in;
            pacman_Y_Pos <= pacman_Y_Pos_in;
            pacman_X_Motion <= pacman_X_Motion_in;
            pacman_Y_Motion <= pacman_Y_Motion_in;
            curDir <= nextDir;
          end

        lastkey <= lastkey_in;
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

    lastkey_in = lastkey;

    if (keycode == 8'h00 && lastkey != 8'h00) // simulate our last keypress
      begin
        unique case (lastkey) // For our NEXT step, we will utilize the changed direction
          8'h1a: // w
            begin
              nextDir = 0;
              pacman_Y_Motion_in = (~(pacman_Y_Step) + 1'b1);
              pacman_X_Motion_in = 0;
            end
          8'h04: // a
            begin
              nextDir = 1;
              pacman_X_Motion_in = (~(pacman_X_Step) + 1'b1);
              pacman_Y_Motion_in = 0;
            end
          8'h16: // s
            begin
              nextDir = 2;
              pacman_Y_Motion_in = pacman_Y_Step;
              pacman_X_Motion_in = 0;
            end
          8'h07: // d
            begin
              nextDir = 3;
              pacman_X_Motion_in = pacman_X_Step;
              pacman_Y_Motion_in = 0;
            end
          default:
            begin
              nextDir = prevDir;
              pacman_X_Motion_in = pacman_X_Motion_prev;
              pacman_Y_Motion_in = pacman_Y_Motion_prev;
            end
        endcase
      end

    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge)
      begin
        unique case (keycode) // For our NEXT step, we will utilize the changed direction
          8'h1a: // w
            begin
              nextDir = 0;
              pacman_Y_Motion_in = (~(pacman_Y_Step) + 1'b1);
              pacman_X_Motion_in = 0;
              lastkey_in = 8'h1a;
            end
          8'h04: // a
            begin
              nextDir = 1;
              pacman_X_Motion_in = (~(pacman_X_Step) + 1'b1);
              pacman_Y_Motion_in = 0;
              lastkey_in = 8'h04;
            end
          8'h16: // s
            begin
              nextDir = 2;
              pacman_Y_Motion_in = pacman_Y_Step;
              pacman_X_Motion_in = 0;
              lastkey_in = 8'h16;
            end
          8'h07: // d
            begin
              nextDir = 3;
              pacman_X_Motion_in = pacman_X_Step;
              pacman_Y_Motion_in = 0;
              lastkey_in = 8'h07;
            end
          default:
            begin
              nextDir = prevDir;
              pacman_X_Motion_in = pacman_X_Motion_prev;
              pacman_Y_Motion_in = pacman_Y_Motion_prev;
              lastkey_in = lastkey;
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

        if (curDir != prevDir) // clear the buffer since we successfully changed direction
          begin
            lastkey_in = 8'h00;
          end
      end

    else
      begin
        if (curDir == prevDir) // if we keep attempting to go in a direction we already know is not allowed (ie stopped at wall and trying to go through it)
          begin
            pacman_X_Motion_in = 0;
            pacman_Y_Motion_in = 0;
          end
        else // if we are trying to change to a not allowed direction, use our previous vals
          begin
            nextDir = prevDir;
            pacman_X_Motion_in = pacman_X_Motion_prev;
            pacman_Y_Motion_in = pacman_Y_Motion_prev;
            pacman_X_Pos_in = pacman_X_Pos + pacman_X_Motion_prev;
            pacman_Y_Pos_in = pacman_Y_Pos + pacman_Y_Motion_prev;

            if (~prev_allowed) // if it turns out our previous values are also not allowed, we should stop too
              begin
                nextDir = prevDir;
                pacman_X_Motion_in = 0;
                pacman_Y_Motion_in = 0;
                pacman_X_Pos_in = pacman_X_Pos;
                pacman_Y_Pos_in = pacman_Y_Pos;
              end
          end
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
  if (lose_game)
    begin
      if (DrawX >= pacman_X_Pos && DrawX <= pacman_X_Pos + pacman_Size)
        begin
          if (DrawY >= pacman_Y_Pos && DrawY <= pacman_Y_Pos + pacman_Size)
            begin
              is_pacman = 1;
              spriteAddrX = DrawX - pacman_X_Pos;
              spriteAddrY = DrawY - pacman_Y_Pos;
            end
        end
    end
  else
  if (win_game)
    begin
      if (DrawX >= pacman_X_Pos && DrawX < pacman_X_Pos + 32)
        begin
          if (DrawY >= pacman_Y_Pos && DrawY < pacman_Y_Pos + 32)
            begin
              is_pacman = 1;
              spriteAddrX = DrawX - pacman_X_Pos;
              spriteAddrY = DrawY - pacman_Y_Pos;
            end
        end
    end
    else
    begin
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
end

endmodule
