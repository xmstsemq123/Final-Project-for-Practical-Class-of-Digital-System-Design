module led_matrix_driver(
    input system_clk, rst,
    input [255:0] framebuffer,
    output [15:0] col,
    output reg [15:0] row
);
    reg [3:0] index;
    assign col = framebuffer[index*16 +: 16];
    always @(posedge led_clk) begin
        // reset the led display
        if(rst) begin
            index <= 0;
            row <= 16'h0001;
        end
        // displaying the map
        else if(index == 4'd15) begin
            row <= 16'd1;
            index <= 4'd0;
        end 
        else begin
            row <= row << 1;
            index <= index + 1;
        end
    end
endmodule