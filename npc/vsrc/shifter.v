module Barrel_Shifter(din,shamt,lr,al,dout);
    input [7:0] din;
    input [2:0] shamt;
    input lr,al;
    output reg [7:0] dout;
    wire almax,o71,o72,o61,o62,o51,o52,o41,o42,o31,o32,o21,o22,o11,o12,o01,o02;

mux211 mux211(
  .a(0),
  .b(din[7]),
  .en(al),
  .y(almax)
);

mux411 i71(.a(din[7]),.b(almax),.c(din[7]),.d(din[6]),.en({lr,shamt[0]}),.y(o71));
mux411 i72(.a(o71),.b(almax),.c(o71),.d(o51),.en({lr,shamt[1]}),.y(o72));
mux411 i73(.a(o72),.b(almax),.c(o72),.d(o32),.en({lr,shamt[2]}),.y(dout[7]));

mux411 i61(.a(din[6]),.b(din[7]),.c(din[6]),.d(din[5]),.en({lr,shamt[0]}),.y(o61));
mux411 i62(.a(o61),.b(almax),.c(o61),.d(o41),.en({lr,shamt[1]}),.y(o72));
mux411 i63(.a(o62),.b(almax),.c(o62),.d(o22),.en({lr,shamt[2]}),.y(dout[6]));

mux411 i51(.a(din[5]),.b(din[6]),.c(din[5]),.d(din[4]),.en({lr,shamt[0]}),.y(o51));
mux411 i52(.a(o51),.b(o71),.c(o51),.d(o31),.en({lr,shamt[1]}),.y(o52));
mux411 i53(.a(o52),.b(almax),.c(o52),.d(o12),.en({lr,shamt[2]}),.y(dout[5]));

mux411 i41(.a(din[4]),.b(din[5]),.c(din[4]),.d(din[3]),.en({lr,shamt[0]}),.y(o41));
mux411 i42(.a(o41),.b(o61),.c(o41),.d(o21),.en({lr,shamt[1]}),.y(o42));
mux411 i43(.a(o42),.b(almax),.c(o42),.d(o02),.en({lr,shamt[2]}),.y(dout[4]));

mux411 i31(.a(din[3]),.b(din[4]),.c(din[3]),.d(din[2]),.en({lr,shamt[0]}),.y(o31));
mux411 i32(.a(o31),.b(o51),.c(o31),.d(o11),.en({lr,shamt[1]}),.y(o32));
mux411 i33(.a(o32),.b(o72),.c(o32),.d(0),.en({lr,shamt[2]}),.y(dout[3]));

mux411 i21(.a(din[2]),.b(din[3]),.c(din[2]),.d(din[1]),.en({lr,shamt[0]}),.y(o21));
mux411 i22(.a(o21),.b(o41),.c(o21),.d(o01),.en({lr,shamt[1]}),.y(o22));
mux411 i23(.a(o22),.b(o62),.c(o22),.d(0),.en({lr,shamt[2]}),.y(dout[2]));

mux411 i11(.a(din[1]),.b(din[2]),.c(din[1]),.d(din[0]),.en({lr,shamt[0]}),.y(o11));
mux411 i12(.a(o11),.b(o31),.c(o11),.d(0),.en({lr,shamt[1]}),.y(o12));
mux411 i13(.a(o12),.b(o52),.c(o12),.d(0),.en({lr,shamt[2]}),.y(dout[1]));

mux411 i01(.a(din[0]),.b(din[1]),.c(din[0]),.d(0),.en({lr,shamt[0]}),.y(o01));
mux411 i02(.a(o01),.b(o21),.c(o01),.d(0),.en({lr,shamt[1]}),.y(o02));
mux411 i03(.a(o02),.b(o42),.c(o02),.d(0),.en({lr,shamt[2]}),.y(dout[0]));

endmodule 

module random8 (load,clk,dout);
    input load,clk;
    output reg [7:0] dout;
    reg [7:0] dreg; 
reg8 reg8(
    .in(dout[4] ^ dout[3] ^ dout[2] ^ dout[0]),
    .clk(clk),
    .qout(dout)
);
    always @(posedge clk) begin
        if(load)
            dout <= 8'b00000001;
    end
endmodule  