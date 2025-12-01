module led_matrix_driver(
    input system_clk, rst,
    input [63:0] framebuffer,
    output [7:0] col,
    output reg [7:0] row
);
    reg [2:0] index;
    assign col = framebuffer[index*8 +: 8];
    always @(posedge system_clk) begin
        // reset the led display
        if(rst) begin
            index <= 0;
            row <= 8'h01;
        end
        // displaying the map
        else if(index == 4'd7) begin
            row <= 8'd1;
            index <= 2'd0;
        end 
        else begin
            row <= row << 1;
            index <= index + 1;
        end
    end
endmodule