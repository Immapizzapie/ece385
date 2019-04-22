module entitySelector (
  input logic is_maze,
  input logic [9:0] mazeX, mazeY,
  input logic is_pacman,
  input logic [1:0] pacmanDir,
  input logic [9:0] pacmanX, pacmanY,
  input logic is_blinky,
  input logic [1:0] blinkyDir,
  input logic [9:0] blinkyX, blinkyY,
  input logic is_pinky,
  input logic [1:0] pinkyDir,
  input logic [9:0] pinkyX, pinkyY,
  input logic is_inky,
  input logic [1:0] inkyDir,
  input logic [9:0] inkyX, inkyY,
  input logic is_clyde,
  input logic [1:0] clydeDir,
  input logic [9:0] clydeX, clydeY,
  output logic [6:0] out,
  output logic [1:0] entityDir,
  output logic [9:0] entityX, entityY
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
    end

endmodule
