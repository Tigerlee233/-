module my_and(a,b,c);
  input  a,b;
  output c;
  assign c = a & b;
endmodule

module my_or(a,b,c);
  input  a,b;
  output c;
  assign c = a | b;
endmodule

module my_xor(a,b,c);
  input  a,b;
  output c;
  assign c = a ^ b;
endmodule

module addr1(a,b,c,s,c1);
    input a,b,c;
    output s;
    output c1;
    wire j,k,l;
    my_and i1(.a(a),.b(b),.c(j));
    my_xor i2(.a(a),.b(b),.c(k));
    my_and i3(.a(c),.b(k),.c(l));
    my_xor i4(.a(c),.b(k),.c(s));
    my_or i5(.a(j),.b(l),.c(c1));
endmodule

module addr(a,b,cin,s,cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output cout;
    output [3:0] s;
    wire [2:0] c;
    addr1 i1(.a(a[0]),.b(b[0]),.c(cin),.s(s[0]),.c1(c[0]));
    addr1 i2(.a(a[1]),.b(b[1]),.c(c[0]),.s(s[1]),.c1(c[1]));
    addr1 i3(.a(a[2]),.b(b[2]),.c(c[1]),.s(s[2]),.c1(c[2]));
    addr1 i4(.a(a[3]),.b(b[3]),.c(c[2]),.s(s[3]),.c1(cout));
endmodule

module alu_pm(A,B,Cin,Carry,Zero,Overflow,Result);
    input [3:0] A,B;
    input Cin;
    output reg Carry,Zero,Overflow;
    output reg [3:0] Result;
    wire [3:0] t_add_Cin;
    assign t_add_Cin =( {4{Cin}}^B )+ {3'b000,Cin};  
    assign { Carry, Result } = A + t_add_Cin;
    assign Overflow = (A[3] == t_add_Cin[3]) && (Result [3] != A[3]);
    assign Zero = ~(| Result);
endmodule

module b_and(a,b,c);
    input [3:0] a,b;
    output reg [3:0] c;
    integer i;
    always @(a,b) begin
        for(i=0;i<=3;i=i+1)
            c[i] = a[i] & b[i];
    end
endmodule

module b_or(a,b,c);
    input [3:0] a,b;
    output reg [3:0] c;
    integer i;
    always @(a,b) begin
        for(i=0;i<=3;i=i+1)
            c[i] = a[i] | b[i];
    end
endmodule

module b_xor(a,b,c);
    input [3:0] a,b;
    output reg [3:0] c;
    integer i;
    always @(a,b) begin
        for(i=0;i<=3;i=i+1)
            c[i] = a[i] ^ b[i];
    end
endmodule

module alu_l(A,B,Cin,Zero,Result);
    input [3:0] A,B;
    input [2:0] Cin;
    output reg Zero;
    output reg [3:0] Result;
    reg [3:0] j,k,l,p;
    b_and i1(.a(A),.b(B),.c(j));
    b_or i2(.a(A),.b(B),.c(k));
    b_xor i3(.a(A),.b(B),.c(l));
    b_xor i4(.a(A),.b(4'b1111),.c(p));
    always @(A,B,Cin) begin
        if(Cin==3'b010) Result = p;
        if(Cin==3'b011) Result = j;
        if(Cin==3'b100) Result = k;
        if(Cin==3'b101) Result = l;
    end
    assign Zero = ~(| Result);
endmodule

module alu_max(A,B,Cin,Carry,Zero,Overflow,Result);
    input [3:0] A,B;
    input [2:0] Cin;
    output reg Carry,Zero,Overflow;
    output reg [3:0] Result;
    reg [3:0] j,k,l;
    reg z1,z2,z3;
    reg c1,c2;
    reg o1,o2;
    alu_pm i1(.A(A),.B(B),.Cin(Cin[0]),.Carry(c1),.Zero(z1),.Overflow(o1),.Result(j));
    alu_l i2(.A(A),.B(B),.Cin(Cin),.Zero(z2),.Result(k));
    alu_pm i3(.A(A),.B(B),.Cin(1),.Carry(c2),.Zero(z3),.Overflow(o2),.Result(l));
    always @(A,B,Cin) begin
        if(Cin==3'b000||Cin==3'b001) begin
            Carry = c1;Zero = z1;Overflow = o1;Result = j;
        end
        if(Cin==3'b011||Cin==3'b100||Cin==3'b101||Cin==3'b010) begin
            Carry = 0;Zero = z2;Overflow = 0;Result = k;
        end
        if(Cin==3'b110) begin
            Carry = 0;Zero = z3;Overflow = 0;Result = (l[3]==1)?4'b0001:4'b0000;
        end
        if(Cin==3'b111) begin
            Carry = 0;Zero = z3;Overflow = 0;Result = (l==0)?4'b0001:4'b0000;
        end
    end
endmodule