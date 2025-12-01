module score_recorder(
    input map_generate_clk, rst,
    input [63:0] framebuffer,
    output reg [31:0] score
);

    always @(posedge map_generate_clk or posedge rst) begin
        if(rst) score <= 32'd0;
        else begin
            if(framebuffer[63:56] == 8'b11111111) score <= score + 1;
        end
    end

endmodule