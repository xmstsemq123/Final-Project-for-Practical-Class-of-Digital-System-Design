module map_generator(
    input system_clk, rst,
    output reg [63:0] framebuffer,
    output reg map_generate_clk
);

    //----- falling stick type -----//
    reg [7:0] FST [7:0];
    initial begin
        FST[0] = 8'b11111110;
        FST[1] = 8'b11111101;
        FST[2] = 8'b11111011;
        FST[3] = 8'b11110111;
        FST[4] = 8'b11101111;
        FST[5] = 8'b11011111;
        FST[6] = 8'b10111111;
        FST[7] = 8'b01111111;
    end

    //----- divide frequency -----//
    // reg map_generate_clk;
    reg [6:0] mgc_counter; 
    parameter CNT_LIMIT = 7'd100; 

    always @(posedge system_clk) begin
        if (rst) begin
            map_generate_clk <= 1'b0; 
            mgc_counter <= 4'b0;
        end else begin
            if (mgc_counter == CNT_LIMIT - 1) begin
                mgc_counter <= 4'b0;
                map_generate_clk <= ~map_generate_clk; 
            end else begin
                mgc_counter <= mgc_counter + 1;
            end
        end
    end

    //----- randome number generator -----//
    wire [2:0] rdn;
    ran_gen_3bit rg3(
        .system_clk(system_clk),
        .rst(rst),
        .random(rdn)
    );

    //----- transfer state -----//
    parameter SPACE_LIMIT = 3'd2;
    reg [2:0] stick_space_counter;
    reg [17:0] falling_stick_sum;

    always @(posedge map_generate_clk) begin
        if(rst) begin
            stick_space_counter <= SPACE_LIMIT;
            falling_stick_sum <= 0;
            framebuffer <= 64'd0;
        end else begin
            if(stick_space_counter == SPACE_LIMIT) begin
                framebuffer <= {framebuffer[55:0], FST[rdn]};
                stick_space_counter <= 0;
                falling_stick_sum <= falling_stick_sum + 1;
            end else begin
                framebuffer <= {framebuffer[55:0], 8'b00000000};
                stick_space_counter = stick_space_counter + 1;
            end
        end
    end

endmodule