module game(
    input system_clk, // clock must be 1k hz
    output [15:0] col, row
);
    reg [255:0] map;
    initial begin
        map = 256'd1;
    end

    led_matrix_driver led (
        .system_clk(system_clk),
        .rst()
        .framebuffer(map),
        .col(col),
        .row(row)
    );

endmodule