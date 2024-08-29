module HEX_display (
    input  [7:0] rx_data,
    output reg [6:0] HEX0,
    output reg [6:0] HEX1
);

    always @(*) begin
        case (rx_data[3:0])
            4'h0: HEX0 = 7'b1000000;
            4'h1: HEX0 = 7'b1111001;
            4'h2: HEX0 = 7'b0100100;
            4'h3: HEX0 = 7'b0110000;
            4'h4: HEX0 = 7'b0011001;
            4'h5: HEX0 = 7'b0010010;
            4'h6: HEX0 = 7'b0000010;
            4'h7: HEX0 = 7'b1111000;
            4'h8: HEX0 = 7'b0000000;
            4'h9: HEX0 = 7'b0010000;
            4'hA: HEX0 = 7'b0001000;
            4'hB: HEX0 = 7'b0000011;
            4'hC: HEX0 = 7'b1000110;
            4'hD: HEX0 = 7'b0100001;
            4'hE: HEX0 = 7'b0000110;
            4'hF: HEX0 = 7'b0001110;
            default: HEX0 = 7'b1111111; 
        endcase
    end

    always @(*) begin
        case (rx_data[7:4])
            4'h0: HEX1 = 7'b1000000;
            4'h1: HEX1 = 7'b1111001;
            4'h2: HEX1 = 7'b0100100;
            4'h3: HEX1 = 7'b0110000;
            4'h4: HEX1 = 7'b0011001;
            4'h5: HEX1 = 7'b0010010;
            4'h6: HEX1 = 7'b0000010;
            4'h7: HEX1 = 7'b1111000;
            4'h8: HEX1 = 7'b0000000;
            4'h9: HEX1 = 7'b0010000;
            4'hA: HEX1 = 7'b0001000;
            4'hB: HEX1 = 7'b0000011;
            4'hC: HEX1 = 7'b1000110;
            4'hD: HEX1 = 7'b0100001;
            4'hE: HEX1 = 7'b0000110;
            4'hF: HEX1 = 7'b0001110;
            default: HEX1 = 7'b1111111; 
        endcase
    end

endmodule
