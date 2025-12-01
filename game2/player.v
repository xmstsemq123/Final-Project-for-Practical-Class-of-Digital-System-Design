module player(
    input system_clk, rst, left, right,
    input [63:0] framebuffer,
    output reg [63:0] new_framebuffer
);

    reg [2:0] player_pos;

    integer i;
    always @(posedge system_clk) begin
        if(rst) begin
            player_pos <= 3'd0;
        end else if (left) begin
            player_pos <= player_pos != 0 ? player_pos - 3'd1 : 0;
        end else if (right) begin
            player_pos <= player_pos != 3'd7 ? player_pos + 3'd1 : 3'd7;
        end
        // new_framebuffer[55:0] <= framebuffer[55:0];
        // for(i=0; i<8; i=i+1) begin
        //     new_framebuffer[i+56] <= i==player_pos ? 1'b1 : framebuffer[i+56];
        // end
    end

    always @(player_pos or framebuffer) begin
        new_framebuffer[55:0] = framebuffer[55:0];
        for(i=0; i<8; i=i+1) begin
            new_framebuffer[i+56] = i==player_pos ? 1'b1 : framebuffer[i+56];
        end
    end

endmodule