module cherry
(
    input Clk, Reset,
		input is_pacman,
    input [7:0] pellet_count,
    input [9:0] DrawX, DrawY,
    output logic is_cherry,
    output logic [9:0] spriteAddrX,   // relative to the sprite, which pixel we are drawing
    output logic [9:0] spriteAddrY,
    output logic cherry_gone
);

assign cherry_gone = seen_cherry;
assign is_cherry = is_cherry_in;

logic show_cherry, show_cherry_in;  //keep track if cherry is being shown
logic seen_cherry, seen_cherry_in; //keep track if cherry is on screen
logic is_cherry_in;
always_ff @ (posedge Clk) begin
  if (Reset) begin
    show_cherry <= 0;
    seen_cherry <= 0;
  end else begin
    show_cherry <= show_cherry_in;
    seen_cherry <= seen_cherry_in;
  end
end

always_comb begin
  spriteAddrX = DrawX - 10'd106;
  spriteAddrY = DrawY - 10'd134;

  if(show_cherry || (pellet_count==7'd200 && !seen_cherry))    // if cherry is on the screen or (200 pellets and never seen cherry)
    show_cherry_in = 1;                                        // then cherry is on the screen
  else
    show_cherry_in = 0;

  if(show_cherry && 208+105<DrawX && DrawX < 208+106+12 && 116+132<DrawY && DrawY<116+132+12)
    is_cherry_in = 1;
  else
    is_cherry_in = 0;

  seen_cherry_in = seen_cherry;
  if(is_cherry_in && is_pacman) begin
    seen_cherry_in = 1;
    show_cherry_in = 0;
  end

end

endmodule
