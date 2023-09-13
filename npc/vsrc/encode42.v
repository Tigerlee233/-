module encode42(x,en,y);
  input  [3:0] x;
  input  en;
  output reg [1:0]y;
  integer i;
  always @(x or en) begin
    if (en) begin
      y = 0;
      for( i = 0; i <= 3; i = i+1)
          if(x[i] == 1)  y = i[1:0];
    end
    else  y = 0;
  end
endmodule

module encode83(x,y,o);
    input [7:0] x;
    output reg [2:0] y;
    output reg o;
    integer i;
    always @(x) begin
        for( i = 7; i >= 0; i = i-1)
          if(x[i] == 1)  y = i[2:0];
    end
endmodule