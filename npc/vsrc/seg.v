module bcd7seg(
    input [3:0] b,
    output reg [7:0] h
);
wire [7:0] segs [15:0];
assign segs[0] = 8'b00000010;
assign segs[1] = 8'b10011110;
assign segs[2] = 8'b00100100;
assign segs[3] = 8'b00001100;
assign segs[4] = 8'b10011000;
assign segs[5] = 8'b01001000;
assign segs[6] = 8'b11000000;
assign segs[7] = 8'b00011110;
assign segs[8] = 8'b00000000;
assign segs[9] = 8'b00001000;
assign segs[10] = 8'b00010000;
assign segs[11] = 8'b11000000;
assign segs[12] = 8'b01100010;
assign segs[13] = 8'b10000100;
assign segs[14] = 8'b01100000;
assign segs[15] = 8'b01110000;
assign h = segs[b[3:0]];

endmodule

module seg16(
    input [4:0] b,
    output reg [7:0] h
);
wire [7:0] segs [16:0];
assign segs[0] = 8'b00000010;
assign segs[1] = 8'b10011110;
assign segs[2] = 8'b00100100;
assign segs[3] = 8'b00001100;
assign segs[4] = 8'b10011000;
assign segs[5] = 8'b01001000;
assign segs[6] = 8'b01000000;
assign segs[7] = 8'b00011110;
assign segs[8] = 8'b00000000;
assign segs[9] = 8'b00001000;
assign segs[10] = 8'b00010000;
assign segs[11] = 8'b11000000;
assign segs[12] = 8'b01100010;
assign segs[13] = 8'b10000100;
assign segs[14] = 8'b01100000;
assign segs[15] = 8'b01110000;
assign segs[16] = 8'b11111111;
assign h = segs[b[4:0]];

endmodule