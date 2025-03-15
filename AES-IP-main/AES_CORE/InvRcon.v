module InvRcon(
  input wire [3:0] round_num,
  output reg [31:0] after_inv_rcon 
);
   always @(*) begin
    case (round_num)
      4'd0: after_inv_rcon = 32'h36000000;
      4'd1: after_inv_rcon = 32'h1b000000;
      4'd2: after_inv_rcon = 32'h80000000;
      4'd3: after_inv_rcon = 32'h40000000;
      4'd4: after_inv_rcon = 32'h20000000;
      4'h5: after_inv_rcon = 32'h10000000;
      4'h6: after_inv_rcon = 32'h08000000;
      4'd7: after_inv_rcon = 32'h04000000;
      4'd8: after_inv_rcon = 32'h02000000;
      4'd9: after_inv_rcon = 32'h01000000;
      default: after_inv_rcon = 32'h00000000; // No after_inv_rcon for invalid rounds
    endcase
  end
endmodule