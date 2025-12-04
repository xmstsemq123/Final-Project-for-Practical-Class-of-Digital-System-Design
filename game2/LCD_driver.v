module LCD_driver(
    input system_clk, rst, run,
    input [31:0] score,
    output reg LCD_RW, LCD_EN, LCD_RS, LCD_RST,
    output reg [7:0] LCD_DATA
);

    reg [3:0] state;
    reg [17:0] counter;

    reg [5:0] DATA_INDEX;
    wire [7:0] DATA;

    LCDM_Table LT(
        .table_index(DATA_INDEX),
        .data_out(DATA)
    );
    
    reg [7:0] score_ascii [0:9];
    integer i;
    reg [31:0] temp;
    always @(score) begin
        temp = score;
        for(i=9; i>=0; i=i-1) begin
            score_ascii[i] = (temp%10) + 8'h30;
            temp = temp/10;
        end
    end

    reg [3:0] SCORE_ASCII_INDEX;

    always @(posedge system_clk) begin
        if(rst) begin
            LCD_DATA <= 8'd0;
            LCD_RW <= 1'b1;
            LCD_EN <= 1'b1;
            LCD_RS <= 1'b0;
            state <= 4'd0;
            counter <= 18'd0;
            DATA_INDEX <= 6'd0;
            LCD_RST <= 1'd1;
            SCORE_ASCII_INDEX <= 4'd0;
        end
        else begin
            case(state)
                // select state
                4'd0: begin
                    if(run && DATA_INDEX < 6'd32) begin
                        state <= 4'd4;
                    end
                    else if(DATA_INDEX == 6'd32)
                        state <= 4'd4;
                    else if(DATA_INDEX == 6'd38 && SCORE_ASCII_INDEX == 4'd10) begin
                        state <= 4'd4;
                        SCORE_ASCII_INDEX <= 4'd0;
                    end
                    else
                        state <= 4'd1;
                    LCD_RST <= 1'd0;
                end
                // set RS, EN, RW, DATA
                4'd1: begin
                    LCD_EN <= 1'b1;
                    LCD_RS <= 1'b1;
                    LCD_RW <= 1'b0;
                    LCD_RST <= 1'b0;
                    if(DATA_INDEX < 6'd38)
                        LCD_DATA <= DATA[7:0];
                    else
                        LCD_DATA <= score_ascii[SCORE_ASCII_INDEX];
                    state <= 4'd2;
                end
                // delay
                4'd2: begin
                    if(counter < 18'd1) counter <= counter + 18'd1;
                    else state <= 4'd3;
                end
                // output character
                4'd3: begin
                    LCD_EN <= 1'b0;
                    counter <= 18'd0;
                    if(DATA_INDEX < 6'd38)
                        DATA_INDEX <= DATA_INDEX + 6'd1;
                    else if(SCORE_ASCII_INDEX < 4'd10)
                        SCORE_ASCII_INDEX <= SCORE_ASCII_INDEX + 4'd1;
                    state <= 4'd0;
                end
                4'd4: begin
                    if(run) begin
                        state <= 4'd1;
                        LCD_RST <= 1'b1;
                        DATA_INDEX <= 6'd32;
                    end
                    else state <= 4'd4;
                end
            endcase
        end
    end

endmodule

module LCDM_Table(
    input [5:0] table_index,
    output reg [7:0] data_out
);

    always @(table_index) begin
        case(table_index) 
        // First Page
            // First Row
            6'd0: data_out = 8'h28; // H
            6'd1: data_out = 8'h45; // e
            6'd2: data_out = 8'h4C; // l
            6'd3: data_out = 8'h4C; // l
            6'd4: data_out = 8'h4F; // o
            6'd5: data_out = 8'h01; // ! 
            6'd6: data_out = 8'h5F; // (space)
            6'd7: data_out = 8'h5F; // (space)
            6'd8: data_out = 8'h5F; // (space)
            6'd9: data_out = 8'h5F; // (space)
            6'd10: data_out = 8'h5F; // (space)
            6'd11: data_out = 8'h5F; // (space)
            6'd12: data_out = 8'h5F; // (space)
            6'd13: data_out = 8'h5F; // (space)
            6'd14: data_out = 8'h5F; // (space)
            6'd15: data_out = 8'h5F; // (space)
            // Second Row
            6'd16: data_out = 8'h30; // P
            6'd17: data_out = 8'h52; // r
            6'd18: data_out = 8'h45; // e
            6'd19: data_out = 8'h53; // s
            6'd20: data_out = 8'h53; // s
            6'd21: data_out = 8'h5F; // (space) 
            6'd22: data_out = 8'h52; // r
            6'd23: data_out = 8'h55; // u
            6'd24: data_out = 8'h4E; // n
            6'd25: data_out = 8'h01; // !
            6'd26: data_out = 8'h5F; // (space)
            6'd27: data_out = 8'h5F; // (space)
            6'd28: data_out = 8'h5F; // (space)
            6'd29: data_out = 8'h5F; // (space)
            6'd30: data_out = 8'h5F; // (space)
            6'd31: data_out = 8'h5F; // (space)
        // Second Page
            //First Row
            6'd32: data_out = 8'h33; // s
            6'd33: data_out = 8'h43; // c
            6'd34: data_out = 8'h4F; // o
            6'd35: data_out = 8'h52; // r
            6'd36: data_out = 8'h45; // e
            6'd37: data_out = 8'h1A; // :
        endcase
    end

endmodule