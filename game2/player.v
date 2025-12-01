module player(
    input system_clk, rst,
    input [63:0] framebuffer,
    output reg [63:0] new_framebuffer
);

    reg [7:0] player_pos;

    always @(posedge system_clk) begin
        if(rst) begin
            player_pos = 8'b00000000;
        end
    end

endmodule