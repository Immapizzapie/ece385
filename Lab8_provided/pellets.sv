module pellets
(
    input Clk, Reset,
		input [9:0] pacman_X, pacman_Y,
    input [9:0] DrawX, DrawY,
    output logic is_pellet,
    output logic win_game,
    output logic [3:0] ones,
    output logic [3:0] tens,
    output logic [3:0] hunds,
    output logic [3:0] thous,
    output logic [3:0] tenthous
);

logic bitmap [35:0][27:0];
logic bitmap_in [35:0][27:0];
logic [4:0] tileX, tileY;
logic [2:0] tilePixelX, tilePixelY;
logic [7:0] counter, counter_in;

logic [3:0] onecounter, tencounter, hundcounter, thoucounter, tenthoucounter;
logic [3:0] onecounter_in, tencounter_in, hundcounter_in, thoucounter_in, tenthoucounter_in;

assign ones = onecounter;
assign tens = tencounter;
assign hunds = hundcounter;
assign thous = thoucounter;
assign tenthous = tenthoucounter;

  always_ff @ (posedge Clk) begin
  	if (Reset) begin
      onecounter <= 0;
      tencounter <= 0;
      hundcounter <= 0;
      thoucounter <= 0;
      tenthoucounter <= 0;

  		counter <= 8'd244;
      bitmap[0]  <= '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
      bitmap[1]  <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0};
      bitmap[2]  <= '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
      bitmap[3]  <= '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
      bitmap[4]  <= '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
      bitmap[5]  <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};
      bitmap[6]  <= '{0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0};
      bitmap[7]  <= '{0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0};
      bitmap[8]  <= '{0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0};
      bitmap[9]  <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[10] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[11] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[12] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[13] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[14] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[15] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[16] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[17] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[18] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[19] <= '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
      bitmap[20] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0};
      bitmap[21] <= '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
      bitmap[22] <= '{0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0};
      bitmap[23] <= '{0,1,1,1,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,0,0,1,1,1,0};
      bitmap[24] <= '{0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0};
      bitmap[25] <= '{0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0};
      bitmap[26] <= '{0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0};
      bitmap[27] <= '{0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0};
      bitmap[28] <= '{0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0};
      bitmap[29] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};
      bitmap[30] <= '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  	end
  	else begin
  		counter <= counter_in;
      bitmap <= bitmap_in;
  	end
  end

	always_comb begin
    onecounter_in = onecounter;
    tencounter_in = tencounter;
    hundcounter_in = hundcounter;
    thoucounter_in = thoucounter;
    tenthoucounter_in = tenthoucounter;

    bitmap_in = bitmap;

    counter_in = counter;
    win_game = 1'b0;

    if(bitmap[pacman_Y >> 3][pacman_X >> 3]==1'b1)
      begin
        counter_in = counter - 1;
        onecounter_in = onecounter + 1;
        if (onecounter == 9)
          begin
            onecounter_in = 0;
            tencounter_in = tencounter + 1;
            if (tencounter == 9)
            begin
              tencounter_in = 0;
              hundcounter_in = hundcounter + 1;
              if (hundcounter == 9)
              begin
                hundcounter_in = -;
                thoucounter_in = thoucounter + 1;
                if (thoucounter == 9)
                begin
                  thoucounter_in = 0;
                  tenthoucounter_in = tenthoucounter + 1;
                end
              end
            end
          end
      end

    bitmap_in[pacman_Y >> 3][pacman_X >> 3]  = 1'b0;

    if(counter==8'd0)
      win_game = 1'b1;

    is_pellet = 1'b0;
    tileX = (DrawX-10'd208) >> 3;
    tileY = (DrawY-10'd116) >> 3;
    tilePixelX = (DrawX-10'd208) % 8;
    tilePixelY = (DrawY-10'd116) % 8;

    if(10'd208<DrawX && DrawX<10'd431 && 10'd116<DrawY && DrawY<10'd363 && (bitmap[tileY][tileX]==1'b1) && (tilePixelX==3'd3 || tilePixelX==3'd4) && (tilePixelY==3'd3 || tilePixelY==3'd4) )
      is_pellet = 1'b1;
	end
endmodule
