module button_dealer(
    input system_clk, rst,
    input lbt, rbt,
    output reg left, right
);

    // 只需要計數到 2，[1:0] 可計數 0, 1, 2, 3，足夠
    reg [1:0] l_pulse_counter, r_pulse_counter; 
    
    // 防彈跳計數器，保持 [3:0] (0 到 15)
    reg [3:0] l_debounce_timer, r_debounce_timer; 

    // 參數名稱更精確地描述其功能
    parameter [3:0] DEBOUNCE_CYCLES = 10; 

    always @(posedge system_clk) begin
        if(rst) begin
            l_pulse_counter <= 2'b0;
            r_pulse_counter <= 2'b0;
            l_debounce_timer <= 4'b0;
            r_debounce_timer <= 4'b0;
            left <= 1'b0;
            right <= 1'b0;
        end 
        else begin
            // 處理 LEFT 按鈕邏輯
            
            // 1. **產生單次脈衝 (Pulse Generation)**
            if (~lbt) begin
                // 按鈕放開時，清除輸出訊號和計數器
                left <= 1'b0;
                l_pulse_counter <= 2'b0;
            end else if (lbt && l_debounce_timer == 4'b0) begin
                // 按下按鈕且不在防彈跳期間：啟動輸出和計時器
                left <= 1'b1;
                l_debounce_timer <= 4'd1; // 啟動防彈跳計時器
            end

            // 2. **控制輸出脈衝長度 (2-Cycle Logic)**
            if (left) begin
                if (l_pulse_counter == 2'd1) begin // 當計數到 1 (即第二個 cycle) 時
                    left <= 1'b0;                 // 輸出設為 0
                    l_pulse_counter <= 2'd0;
                end else begin
                    l_pulse_counter <= l_pulse_counter + 1;
                end
            end
            
            // 3. **防彈跳計時器 (Debounce Timer)**
            if (l_debounce_timer != 4'b0) begin
                if (l_debounce_timer == DEBOUNCE_CYCLES) begin
                    l_debounce_timer <= 4'b0;
                end else begin
                    l_debounce_timer <= l_debounce_timer + 1; // ❗ 使用非阻塞賦值
                end
            end


            // --- 處理 RIGHT 按鈕邏輯 (結構相同) ---

            if (~rbt) begin
                right <= 1'b0;
                r_pulse_counter <= 2'b0;
            end else if (rbt && r_debounce_timer == 4'b0) begin
                right <= 1'b1;
                r_debounce_timer <= 4'd1;
            end

            if (right) begin
                if (r_pulse_counter == 2'd1) begin
                    right <= 1'b0;
                    r_pulse_counter <= 2'd0;
                end else begin
                    r_pulse_counter <= r_pulse_counter + 1;
                end
            end

            if (r_debounce_timer != 4'b0) begin
                if (r_debounce_timer == DEBOUNCE_CYCLES) begin
                    r_debounce_timer <= 4'b0;
                end else begin
                    r_debounce_timer <= r_debounce_timer + 1;
                end
            end
        end // end else (run logic)
    end

endmodule