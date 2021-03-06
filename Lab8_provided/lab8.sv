//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );

    logic Reset_h, Clk;
    logic [7:0] keycode;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
        if (~KEY[0])
        begin
          lose_game <= 0;
          win_game <= 0;
        end
        if (lose_game_in)
          lose_game <= lose_game_in;
        if (win_game_in)
          win_game <= win_game_in;
    end

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),
                            .OTG_ADDR(OTG_ADDR),
                            .OTG_RD_N(OTG_RD_N),
                            .OTG_WR_N(OTG_WR_N),
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );

     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR),
                             .sdram_wire_ba(DRAM_BA),
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),
                             .sdram_wire_cs_n(DRAM_CS_N),
                             .sdram_wire_dq(DRAM_DQ),
                             .sdram_wire_dqm(DRAM_DQM),
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N),
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );

  logic [9:0] DrawX, DrawY;

  // Use PLL to generate the 25MHZ VGA_CLK.
  // You will have to generate it on your own in simulation.
  vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

  VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .DrawX(DrawX), .DrawY(DrawY));

  logic slClk;
  slowClock slowclock(.Clk(Clk), .Reset(Reset_h), .Clk_slow(slClk));

  logic is_maze;
  logic [9:0] mazeX;
  logic [9:0] mazeY;

  maze pacman_maze (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .is_maze(is_maze), .spriteAddrX(mazeX), .spriteAddrY(mazeY));


  logic is_pacman, is_blinky, is_pinky, is_inky, is_clyde;
  logic [9:0] pacmanX, blinkyX, pinkyX, inkyX, clydeX;
  logic [9:0] pacmanY, blinkyY, pinkyY, inkyY, clydeY;
  logic [9:0] pacman_x_position, pacman_y_position;
  logic [1:0] pacmanDir, blinkyDir, pinkyDir, inkyDir, clydeDir;

  pacman PacMan(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .keycode(keycode), .is_pacman(is_pacman), .spriteAddrX(pacmanX), .spriteAddrY(pacmanY), .dir(pacmanDir), .pacman_x_position(pacman_x_position), .pacman_y_position(pacman_y_position), .lose_game(lose_game), .win_game(win_game));
  ghost blinky (.Clk(Clk), .Reset(Reset_h), .frame_clk(slClk), .DrawX(DrawX), .DrawY(DrawY), .ghosttype(2'b00), .is_ghost(is_blinky), .spriteAddrX(blinkyX), .spriteAddrY(blinkyY), .dir(blinkyDir), .game_over(lose_game|win_game), .pacmanX(pacman_x_position), .pacmanY(pacman_y_position));
  ghost pinky  (.Clk(Clk), .Reset(Reset_h), .frame_clk(slClk), .DrawX(DrawX), .DrawY(DrawY), .ghosttype(2'b01), .is_ghost(is_pinky), .spriteAddrX(pinkyX), .spriteAddrY(pinkyY), .dir(pinkyDir), .game_over(lose_game|win_game));
  ghost inky   (.Clk(Clk), .Reset(Reset_h), .frame_clk(slClk), .DrawX(DrawX), .DrawY(DrawY), .ghosttype(2'b10), .is_ghost(is_inky), .spriteAddrX(inkyX), .spriteAddrY(inkyY), .dir(inkyDir), .game_over(lose_game|win_game));
  ghost clyde  (.Clk(Clk), .Reset(Reset_h), .frame_clk(slClk), .DrawX(DrawX), .DrawY(DrawY), .ghosttype(2'b11), .is_ghost(is_clyde), .spriteAddrX(clydeX), .spriteAddrY(clydeY), .dir(clydeDir), .game_over(lose_game|win_game));


  logic is_cherry, cherry_gone;
  logic [9:0] cherryX, cherryY;

  cherry p_cherry(.Clk(Clk), .Reset(Reset_h), .is_pacman, .pellet_count, .DrawX, .DrawY, .is_cherry, .spriteAddrX(cherryX), .spriteAddrY(cherryY), .cherry_gone);

  logic is_pellet, win_game, win_game_in;
  logic [3:0] ones, tens, hunds, thous, tenthous;
  logic is_ones, is_tens, is_hunds, is_thous, is_tenthous;
  logic [9:0] onesX, tensX, hundsX, thousX, tenthousX;
  logic [9:0] onesY, tensY, hundsY, thousY, tenthousY;

  score onescount    (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_CLK), .DrawX(DrawX), .DrawY(DrawY), .place(4'd0), .is_score(is_ones), .spriteAddrX(onesX), .spriteAddrY(onesY));
  score tenscount    (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_CLK), .DrawX(DrawX), .DrawY(DrawY), .place(4'd1), .is_score(is_tens), .spriteAddrX(tensX), .spriteAddrY(tensY));
  score hundscount   (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_CLK), .DrawX(DrawX), .DrawY(DrawY), .place(4'd2), .is_score(is_hunds), .spriteAddrX(hundsX), .spriteAddrY(hundsY));
  score thouscount   (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_CLK), .DrawX(DrawX), .DrawY(DrawY), .place(4'd3), .is_score(is_thous), .spriteAddrX(thousX), .spriteAddrY(thousY));
  score tenthouscount(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_CLK), .DrawX(DrawX), .DrawY(DrawY), .place(4'd4), .is_score(is_tenthous), .spriteAddrX(tenthousX), .spriteAddrY(tenthousY));

  logic [7:0] pellet_count;
  pellets pellet(.Clk(Clk), .Reset(Reset_h), .pacman_X(pacman_x_position - 208 + 7), .pacman_Y(pacman_y_position - 116 + 7), .DrawX(DrawX), .DrawY(DrawY), .is_pellet(is_pellet), .pellet_count, .win_game(win_game_in), .ones(ones), .tens(tens), .hunds(hunds), .thous(thous), .tenthous(tenthous));

  logic [6:0] entity;
  logic [9:0] entityX;
  logic [9:0] entityY;
  logic [1:0] entityDir;
  logic lose_game;
  logic lose_game_in;
  entitySelector selectEntity(.*);

  color_mapper color_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .entity(entity), .spriteAddrX(entityX), .spriteAddrY(entityY), .mazeAddrX(mazeX), .mazeAddrY(mazeY), .direction(entityDir), .DrawX(DrawX), .lose_game(lose_game), .win_game(win_game), .DrawY(DrawY), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .ones(ones), .tens(tens), .hunds(hunds), .thous(thous), .tenthous(tenthous));

  // Display keycode on hex display
  HexDriver hex_inst_0 (keycode[3:0], HEX0);
  HexDriver hex_inst_1 (keycode[7:4], HEX1);
endmodule
