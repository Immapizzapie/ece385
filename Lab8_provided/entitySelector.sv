module entitySelector (
  input is_maze,
  input [9:0] mazeX, mazeY,
  input is_pacman,
  input [1:0] pacmanDir,
  input [9:0] pacmanX, pacmanY,
  input is_blinky,
  input [1:0] blinkyDir,
  input [9:0] blinkyX, blinkyY,
  input is_pinky,
  input [1:0] pinkyDir,
  input [9:0] pinkyX, pinkyY,
  input is_inky,
  input [1:0] inkyDir,
  input [9:0] inkyX, inkyY,
  input is_clyde,
  input [1:0] clydeDir,
  input [9:0] clydeX, clydeY,
  input is_pellet,
  input [9:0] DrawX, DrawY,
  input is_ones,
  input [9:0] onesX, onesY,
  input is_tens,
  input [9:0] tensX, tensY,
  input is_hunds,
  input [9:0] hundsX, hundsY,
  input is_thous,
  input [9:0] thousX, thousY,
  input is_tenthous,
  input [9:0] tenthousX, tenthousY,
  output logic [6:0] out,
  output logic [1:0] entityDir,
  output logic [9:0] entityX,
  output logic [9:0] entityY,
  output logic lose_game
);

  always_comb
    begin
      if (is_pacman)
  			begin
          out = 7'b0000001;
          entityX = pacmanX;
          entityY = pacmanY;
          entityDir = pacmanDir;
  			end
      else if (is_blinky)
        begin
          out = 7'b0000011;
          entityX = blinkyX;
          entityY = blinkyY;
          entityDir = blinkyDir;
        end
      else if (is_pinky)
        begin
          out = 7'b0000100;
          entityX = pinkyX;
          entityY = pinkyY;
          entityDir = pinkyDir;
        end
      else if (is_inky)
        begin
          out = 7'b0000101;
          entityX = inkyX;
          entityY = inkyY;
          entityDir = inkyDir;
        end
      else if (is_clyde)
        begin
          out = 7'b0000110;
          entityX = clydeX;
          entityY = clydeY;
          entityDir = clydeDir;
        end
      else if (is_pellet)
        begin
          out = 7'b0000111;
          entityX = 0;
          entityY = 0;
          entityDir = 0;
        end
      else if (is_maze)
        begin
          out = 7'b0000010;
          entityX = mazeX;
          entityY = mazeY;
          entityDir = 0;
        end
      else if (is_ones)
        begin
          out = 7'b0001000;
          entityX = onesX;
          entityY = onesY;
          entityDir = 0;
        end
      else if (is_tens)
        begin
          out = 7'b0001001;
          entityX = tensX;
          entityY = tensY;
          entityDir = 0;
        end
      else if (is_hunds)
        begin
          out = 7'b0001010;
          entityX = hundsX;
          entityY = hundsY;
          entityDir = 0;
        end
      else if (is_thous)
        begin
          out = 7'b0001011;
          entityX = thousX;
          entityY = thousY;
          entityDir = 0;
        end
      else if (is_tenthous)
        begin
          out = 7'b0001100;
          entityX = tenthousX;
          entityY = tenthousY;
          entityDir = 0;
        end
      else
        begin
          out = 7'b0000000;
          entityX = 0;
          entityY = 0;
          entityDir = 0;
        end

      if(is_pacman && (is_blinky||is_pinky||is_inky||is_clyde))
        lose_game = 1'b1;
      else
        lose_game = 1'b0;

    end

endmodule
