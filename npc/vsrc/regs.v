module reg1 (
    input in,
    input clk,
    output reg q
);
    always @(posedge clk) begin
        q <= in;
    end
endmodule

module reg4 (
    input in,
    input clk,
    output reg [3:0] qout
);
    wire q1,q2,q3,q4;
    reg1 i1(.in(in),.clk(clk),.q(q1));
    reg1 i2(.in(q1),.clk(clk),.q(q2));
    reg1 i3(.in(q2),.clk(clk),.q(q3));
    reg1 i4(.in(q3),.clk(clk),.q(q4));
    assign qout = {q1,q2,q3,q4};
endmodule

module reg8 (
    input in,
    input clk,
    output reg [7:0] qout
);
    wire q1,q2,q3,q4,q5,q6,q7,q8;
    reg1 i1(.in(in),.clk(clk),.q(q1));
    reg1 i2(.in(q1),.clk(clk),.q(q2));
    reg1 i3(.in(q2),.clk(clk),.q(q3));
    reg1 i4(.in(q3),.clk(clk),.q(q4));
    reg1 i5(.in(q4),.clk(clk),.q(q5));
    reg1 i6(.in(q5),.clk(clk),.q(q6));
    reg1 i7(.in(q6),.clk(clk),.q(q7));
    reg1 i8(.in(q7),.clk(clk),.q(q8));
    assign qout = {q1,q2,q3,q4,q5,q6,q7,q8};
endmodule

module lfsr (
    input load,clk,
    output reg [7:0] qout
);
    always @(clk) begin
        if(load)
            qout = 8'b00000001;
        else 
            qout = {q1,q2,q3,q4,q5,q6,q7,q8};
    end

    wire q1,q2,q3,q4,q5,q6,q7,q8;
    reg1 i1(.in(qout[4]^qout[3]^qout[2]^qout[0]),.clk(clk),.q(q1));
    reg1 i2(.in(q1),.clk(clk),.q(q2));
    reg1 i3(.in(q2),.clk(clk),.q(q3));
    reg1 i4(.in(q3),.clk(clk),.q(q4));
    reg1 i5(.in(q4),.clk(clk),.q(q5));
    reg1 i6(.in(q5),.clk(clk),.q(q6));
    reg1 i7(.in(q6),.clk(clk),.q(q7));
    reg1 i8(.in(q7),.clk(clk),.q(q8));

endmodule