module game(
    input system_clk, lbt, rbt, start,
    output LCD_RW, LCD_EN, LCD_RS, LCD_RST,
    output [7:0] LCD_DATA,
    output [7:0] row, col
);

    wire [63:0] framebuffer, new_framebuffer;
    wire map_generate_clk;
    wire left, right;
    wire [31:0] score;
    reg rst, run;

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

    LCD_driver LCDD(
        .system_clk(system_clk),
        .rst(rst),
        .run(run),
        .score(score),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_RST(LCD_RST),
        .LCD_DATA(LCD_DATA)
    );

    reg [3:0] state;
    reg [2:0] rst_counter;

    initial begin
        state = 0;
    end

    always @(posedge system_clk) begin
        case(state)
            4'd0: begin
                rst <= 1'b1;
                state <= 4'd1;
                rst_counter <= 3'd0;
                run <= 1'b0;
            end
            4'd1: begin
                if(rst_counter < 3'd2) rst_counter <= rst_counter + 1;
                else state <= 4'd2;
            end
            4'd2: begin
                if(start) state <= 4'd3;
                else state <= 4'd2;
            end
            4'd3: begin
                rst <= 1'b0;
                run <= 1'b1;
            end
        endcase
    end

endmodule