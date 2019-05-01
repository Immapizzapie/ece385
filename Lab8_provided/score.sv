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


module score ( input Clk,                // 50 MHz clock
                    Reset,              // Active-high reset signal
                    frame_clk,          // The clock indicating a new frame (~60Hz)
       input [9:0]  DrawX, DrawY,       // Current pixel coordinates
       input [3:0] place,
output logic is_score,          // Whether current pixel belongs to ball or background
output logic [9:0]  spriteAddrX,        // relative to the sprite, which pixel we are drawing
output logic [9:0]  spriteAddrY        // relative to the sprite, which pixel we are drawing
              );

  parameter [9:0] score_X_start = 10'd208;   // Center position on the X axis
  parameter [9:0] score_Y_start = 10'd116;   // Center position on the Y axis
  parameter [9:0] score_width = 10'd7;
  parameter [9:0] score_height = 10'd9;

  logic [9:0] score_X_pos, score_Y_pos;

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end

  always_ff @ (posedge Clk) begin
    if (Reset) begin
      score_Y_pos <= 107;
      unique case (place)
        4'd0:
          begin
            score_X_pos <= 348;
          end
        4'd1:
          begin
            score_X_pos <= 341;
          end
        4'd2:
          begin
            score_X_pos <= 334;
          end
        4'd3:
          begin
            score_X_pos <= 327;
          end
        4'd4:
          begin
            score_X_pos <= 320;
          end
        default:
          begin
            score_X_pos <= 40;
          end
      endcase
    end
  end

always_comb begin
  is_score = 0;
  spriteAddrX = 1'b0;
  spriteAddrY = 1'b0;
  if (DrawX >= score_X_pos && DrawX < score_X_pos + score_width)
    begin
    if (DrawY >= score_Y_pos && DrawY < score_Y_pos + score_height)
      begin
		  is_score = 1;
        spriteAddrX = DrawX - score_X_pos;
        spriteAddrY = DrawY - score_Y_pos;
      end
    end
end

endmodule
