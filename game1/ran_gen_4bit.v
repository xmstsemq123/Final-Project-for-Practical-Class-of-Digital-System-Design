module ran_gen_4bit(
    input clk, rst,
    output reg [3:0] random
);

    wire feedback;
    assign feedback = random[3]^random[1];

    always @(posedge clk) begin
        if(rst) random <= 4'b0001;
        else random <= {random[2:0], feedback};
    end

endmodule