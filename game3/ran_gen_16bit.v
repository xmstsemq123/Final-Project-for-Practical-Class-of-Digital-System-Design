module ran_gen_16bit(
    input system_clk, rst,
    output [15:0] random
);

    reg [47:0] random_generator;

    assign random[15:0] = random_generator[31:16];

    wire feedback;
    integer i;
    
    always @(random_generator) begin
        feedback = random_generator[1];
        for(i=3; i<48; i=i+2) begin
            feedback = feedback ^ random_generator[i];
        end
    end

    always @(posedge system_clk) begin
        if(rst) random_generator <= 48'h0F0FF0F00F0F;
        else random_generator <= {random_generator[46:0], feedback};
    end

endmodule