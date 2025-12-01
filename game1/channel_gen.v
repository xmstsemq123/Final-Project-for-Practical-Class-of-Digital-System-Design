module channel_gen(
    input system_clk, rst, run,
    output reg [3:0][15:0] channel
);

    integer gen_clk_counter, stage_counter, stage_limit;
    wire gen_clk;

    assign gen_clk = gen_clk_counter == 0 ? ~gen_clk : gen_clk;
    // generator clock control
    always @(posedge system_clk) begin
        // reset
        if(rst) begin
            integer i;
            for(i=0; i<4; i=i+1) begin
                channel[i] <= 16'b0;
            end
            gen_clk_counter <= 0;
            gen_clk <= 0;
            stage_limit <= 500;
            stage_counter <= 0;
        end
        // running driver clock 
        else if(run) begin
            gen_clk_counter <= gen_clk_counter >= stage_limit ? 0 : gen_clk_counter + 1;
        end
    end

    // random number generator
    wire [3:0] random_num;
    ran_gen_4bit rg(
        .clk(system_clk),
        .rst(rst),
        .random(random_num)
    );

    reg [2:0] last_gen_step;
    always @(gen_clk) begin
        // speed control
        case(stage_counter)
            10: stage_limit = 250;
            25: stage_limit = 200;
            40: stage_limit = 150;
            55: stage_limit = 100;
            default: stage_limit = 100;
        endcase
        // block generator
        if(last_gen_step == 0) begin
            channel[random_num % 4][0] = 1;
        end
    end

    always @(posedge gen_clk) begin
        // stage control counter
        stage_counter <= stage_counter + 1;
        // block generate control counter
        last_gen_step <= last_gen_step == 4 ? 0 : last_gen_step + 1;
        // rolling down whole display
        integer i;
        for(i=0; i<4; i=i+1) begin
            channel[i] <= channel[i] << 1;
        end
    end

endmodule