module lsfr (
  input  logic        clk_i,
  input  logic        rst_i,
  input [1:0]   ghosttype,
  output logic [31:0] rand_o
);

  logic[31:0] lfsr_value;

  assign rand_o = lfsr_value;

  always_ff @(posedge clk_i) begin
    if(rst_i) begin
      if (ghosttype == 2'b00)
        begin
          lfsr_value <= 23;
        end
      else if (ghosttype == 2'b01)
        begin
          lfsr_value <= 100;
        end
      else if (ghosttype == 2'b10)
        begin
          lfsr_value <= 0;
        end
      else if (ghosttype == 2'b11)
        begin
          lfsr_value <= 513;
        end
      else
        begin
          lfsr_value <= 0;
        end
    end else begin
      lfsr_value[31:1] <= lfsr_value[30:0];
      lfsr_value[0]    <= ~(lfsr_value[31] ^ lfsr_value[21] ^ lfsr_value[1] ^ lfsr_value[0]);
    end
  end
endmodule
