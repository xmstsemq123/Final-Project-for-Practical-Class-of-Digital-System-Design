module game(
    input system_clk,
    output [7:0] row, col
);

    wire [63:0] framebuffer;
    reg rst;

    map_generator map(
        .system_clk(system_clk),
        .rst(rst),
        .framebuffer(framebuffer)
    );

    led_matrix_driver led(
        .system_clk(system_clk),
        .rst(rst),
        .framebuffer(framebuffer),
        .col(col),
        .row(row)
    );

    reg [2:0] counter;

    initial begin
        counter = 0;
        rst = 1;
    end

    always @(posedge system_clk) begin
        if(counter <= 3'd3) begin
            counter <= counter + 1;
        end else begin 
            rst <= 0;
        end
    end

endmodule