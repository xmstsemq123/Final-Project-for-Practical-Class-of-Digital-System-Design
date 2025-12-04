module game(
    input system_clk, start, 
    input [3:0] Pad_Row, Pad_Col,
    output [7:0] row, col
);

    reg rst;
    reg [3:0] rst_counter;

    reg [3:0] state;

    initial begin
        state = 4'd0;
    end

    always @(posedge system_clk) begin
        case(state) 
            4'd0: begin
                rst <= 1'b1;
                rst_counter <= 4'd0;
                state <= 4'd1;
            end
            4'd1: begin
                if(rst_counter < 4'd3) rst_counter <= rst_counter + 1;
                else begin
                    rst_counter <= 4'd0;
                    rst <= 1'b0;
                    state <= 4'd2;
                end
            end
            4'd2: begin
                if(start) begin
                    state <= 4'd3;
                end else state <= 4'd2;
            end
            4'd3: begin
                
            end
        endcase
    end

endmodule