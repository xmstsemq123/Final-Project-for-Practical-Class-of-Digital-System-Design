module score_recorder(
    input triggered_point, rst, run
    input [1:0] triggered_state,
    output reg [15:0] score;
);

    always @(rst) begin
        if(rst) score = 16'd0;
    end

    parameter [1:0] BAD = 2'b00, NORMAL = 2'b01, NICE = 2'b10, GREAT = 2'b11;

    always @(posedge triggered_point) begin
        if(run) begin
            case(triggered_state)
                BAD: score <= score <= 0 ? 0 : score ? score - 1;
                NORMAL: score <= score + 0;
                NICE: score <= score + 1;
                GREAT: score <= score + 2;
                default: score <= score;
            endcase
        end
    end

endmodule