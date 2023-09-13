module top(
  input clk,
  input rst,
  input ps2_clk,
  input ps2_data,
  input [12:0] sw,
  output [15:0] ledr,
  output [7:0] seg0,
  output [7:0] seg1,
  output [7:0] seg2,
  output [7:0] seg3,
  output [7:0] seg4,
  output [7:0] seg5,
  output [7:0] seg6,
  output [7:0] seg7
);
wire [7:0] data;
wire [15:0] h,m,l;
wire next,ready;
wire [39:0] s;
ps2_keyboard ps2_keyboard(
  .clk(clk),.clrn(~rst),.ps2_clk(ps2_clk),.ps2_data(ps2_data),.data(data),
  .ready(ready),.nextdata_n(next),.overflow(ledr[1])
);
keyboard_i keyboard_i(
  .ps2_clk(clk),
  .data(data),
  .ready(ready),
  .next(next),
  .s(s)
);
keyboard_u keyboard_u1(
  .s(s),
  .h({seg5,seg4}),
  .m({seg3,seg2}),
  .l({seg1,seg0}),
  .b({seg7,seg6})
);

endmodule