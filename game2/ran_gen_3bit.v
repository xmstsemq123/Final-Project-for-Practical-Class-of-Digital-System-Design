module ran_gen_3bit(
    input system_clk, rst,
    output reg [2:0] random
);

    wire feedback;
    assign feedback = randome[2]^random[0];

    always @(posedge system_clk) begin
        if(rst) random <= 3'b001;
        else random <= {random[1:0], feedback};
    end

endmodule