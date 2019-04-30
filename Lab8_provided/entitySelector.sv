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
  input [3:0] ones,
  input [3:0] tens,
  input [3:0] hunds,
  input [3:0] thous,
  input [3:0] tenthous,
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
