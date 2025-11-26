module input_trigger_dealer(
    input system_clk, rst, run,
    input [3:0] button,
    input [3:0][15:0] channel,
    output reg is_triggered, 
    output reg [1:0] triggered_state
); 
    // all possible triggered state
    parameter [1:0] BAD = 2'b00, NORMAL = 2'b01, NICE = 2'b10, GREAT = 2'b11;

    // debounce counter and debounce time(ms)
    reg [3:0] deb_counter;
    parameter [3:0] DEBOUNCE_CLOCK_TIME = 10;

    always @(posedge system_clk) begin
        // reset
        if(rst) begin
            deb_counter <= 0;
            is_triggered <= 0;
            triggered_state <= NORMAL;
        end 
        // button debounce proccess
        else if(run && deb_counter != 0) begin
            deb_counter <= deb_counter >= DEBOUNCE_CLOCK_TIME ? 0 : deb_counter + 1;
        end
    end

    always @(button) begin
        is_triggered = 0;
        triggered_state = NORMAL;
        if(run && deb_counter == 0) begin
            deb_counter = deb_counter + 1;
            integer i;
            for(i=0; i<4; i=i+1) begin
                if(button[i]) begin
                    is_triggered = 1;
                    case(channel[i][15:12])
                        4'b0001: 
                            triggered_state = BAD;
                        4'b0010:
                            triggered_state = NORMAL;
                        4'b0100: 
                            triggered_state = NICE;
                        4'b1000:
                            triggered_state = GREAT;
                        default: begin
                            is_triggered = 0;
                        end
                    endcase
                end
            end
        end
    end

endmodule