module game(
    input system_clk, lbt, rbt,
    output [7:0] row, col
);

    wire [63:0] framebuffer, new_framebuffer;
    wire map_generate_clk;
    wire left, right;
    wire [31:0] score;
    reg rst;

    map_generator map(
        .system_clk(system_clk),
        .rst(rst),
        .framebuffer(framebuffer),
        .map_generate_clk(map_generate_clk)
    );

    button_dealer bd(
        .system_clk(system_clk),
        .rst(rst),
        .lbt(lbt),
        .rbt(rbt),
        .left(left),
        .right(right)
    );

    player p(
        .system_clk(system_clk),
        .rst(rst),
        .left(left),
        .right(right),
        .framebuffer(framebuffer),
        .new_framebuffer(new_framebuffer)
    );

    score_recorder sr(
        .map_generate_clk(map_generate_clk),
        .rst(rst),
        .framebuffer(new_framebuffer),
        .score(score)
    );

    led_matrix_driver led(
        .system_clk(system_clk),
        .rst(rst),
        .framebuffer(new_framebuffer),
        .col(col),
        .row(row)
    );

    reg [2:0] rst_counter;

    initial begin
        rst_counter = 0;
        rst = 1;
    end

    always @(posedge system_clk) begin
        if(rst_counter <= 3'd3) begin
            rst_counter <= rst_counter + 1;
        end else begin 
            rst <= 0;
        end
    end

endmodule