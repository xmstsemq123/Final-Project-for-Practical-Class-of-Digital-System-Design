module channel_to_framebuffer(
    input [3:0][15:0] channel,
    output reg [255:0] framebuffer
);

    always @(channel) begin
        framebuffer = 256'd0;
        integer i, j;
        for(i=0; i<4; i=i+1) begin
            for(j=0; j<16; j=j+1) begin
                if(channel[i][j]) begin
                    integer k;
                    for(k=j; k>=0 && k>j-4; k=k-1) begin
                        framebuffer[k*16+i*4 += 4] = 4'b1111;
                    end
                end
            end
        end
    end

endmodule