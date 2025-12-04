module led_matrix_driver(
    input system_clk, rst,
    input [15:0] framebuffer,
    output reg [7:0] row, col
);

    always @(posedge system_clk) begin
        if(rst) begin
            row <= 8'b00000001;
            col <= 8'd0;
        end else begin
            row <= row == 8'b10000000 ? 8'b00000001 : row << 1;
            case(row)
                8'b00000001: begin
                    col <= {framebuffer[15], 1'b1, framebuffer[14], 1'b1, framebuffer[13], 1'b1, framebuffer[12], 1'b0};
                end 
                8'b00000010: begin
                    col <= {7'b1111111, 1'b0};
                end 
                8'b00000100: begin
                    col <= {framebuffer[11], 1'b1, framebuffer[10], 1'b1, framebuffer[9], 1'b1, framebuffer[8], 1'b0};
                end 
                8'b00001000: begin
                    col <= {7'b1111111, 1'b0};
                end 
                8'b00010000: begin
                    col <= {framebuffer[7], 1'b1, framebuffer[6], 1'b1, framebuffer[5], 1'b1, framebuffer[4], 1'b0};
                end 
                8'b00100000: begin
                    col <= {7'b1111111, 1'b0};
                end 
                8'b01000000: begin
                    col <= {framebuffer[3], 1'b1, framebuffer[2], 1'b1, framebuffer[1], 1'b1, framebuffer[0], 1'b0};
                end 
                8'b10000000: begin
                    col <= 8'd0;
                end 
            endcase
        end
    end

endmodule