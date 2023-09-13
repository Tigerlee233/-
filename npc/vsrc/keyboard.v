module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,
                    ready,nextdata_n,overflow);
    input clk,clrn,ps2_clk,ps2_data;
    input nextdata_n;
    output [7:0] data;
    output reg ready;
    output reg overflow;     // fifo overflow
    // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0] fifo[7:0];     // data fifo
    reg [2:0] w_ptr,r_ptr;   // fifo write and read pointers
    reg [3:0] count;  // count ps2_data bits
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (clrn == 0) begin // reset
            count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0;
        end
        else begin
            if ( ready ) begin // read to output next data
                if(nextdata_n == 1'b0)
                begin
                    r_ptr <= r_ptr + 3'b1;
                    if(w_ptr==(r_ptr+1'b1)) //empty
                        ready <= 1'b0;
                end
            end
            if (sampling) begin
              if (count == 4'b1010) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    fifo[w_ptr] <= buffer[8:1];  // kbd scan code
                    w_ptr <= w_ptr+3'b1;
                    ready <= 1'b1;
                    overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end
    assign data = fifo[r_ptr]; //always set output data

endmodule

module keyboard_i(ps2_clk,data,ready,next,s);
    input ps2_clk;
    input [7:0] data;
    input ready;
    output reg [39:0] s;
    reg stop;
    output reg next;
    always @(ps2_clk) begin
        if(ready) begin
            s <= {s[29:0],1'b0,data[7:4],1'b0,data[3:0]};
            next <= 0;
        end 
    end
endmodule 

module keyboard_u(s,h,m,l,b);
    input [39:0] s;
    reg [7:0] hs;
    reg [5:0] count,cnt;
    reg [15:0] l1,m1;
    output reg [15:0] h,m,l,b;
    integer i;
    always @(s) begin
        if({s[28:25],s[23:20]}==8'hf0 && {s[38:35],s[33:30]}==8'hf0) begin
            l = 16'b1111111111111111;
            m = 16'b1111111111111111;
            count = count + 6'd1;
            cnt = count;
            hs[7:4] = 0; 
            hs[3:0] = 0; 
            for (i = 0; i < 10; i = i + 1) begin
                if (cnt >= 10) begin
                    cnt = cnt - 10;
                    hs[7:4] = hs[7:4] + 1;
                end else begin
                    hs[3:0] = cnt[3:0]; 
                    break;
                end
            end
        end else begin
            l = l1;
            m = m1;
        end
    end
    wire [4:0] as1,as2;
    seg16 i0(.b(s[9:5]),.h(l1[15:8]));
    seg16 i1(.b(s[4:0]),.h(l1[7:0]));
    asc2 i2(.din({s[18:15],s[13:10]}),.dout({as1[3:0],as2[3:0]}));
    seg16 i3(.b({1'b0,as1[3:0]}),.h(m1[15:8]));
    seg16 i4(.b({1'b0,as2[3:0]}),.h(m1[7:0]));
    seg16 i5(.b({1'b0,hs[7:4]}),.h(h[15:8]));
    seg16 i6(.b({1'b0,hs[3:0]}),.h(h[7:0]));
    seg16 i7(.b(s[39:35]),.h(b[15:8]));
    seg16 i8(.b(s[34:30]),.h(b[7:0]));
    initial begin
        count = 6'd0;
    end
endmodule

module keyboard_identify(data,ready,h,m,l);
    input [7:0] data;
    input ready;
    output [15:0] h;
    output [15:0] m;
    output [15:0] l;
    reg [7:0] s;
    reg [7:0] hs;
    reg [5:0] count;
    reg [5:0] cnt;
    integer i;
    assign s = {data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]};
    bcd7seg i0(.b(s[7:4]),.h(l[15:8]));
    bcd7seg i1(.b(s[3:0]),.h(l[7:0]));
    asc2 i2(.din(l[15:8]),.dout(m[15:8]));
    asc2 i3(.din(l[7:0]),.dout(m[7:0]));
    always @(s) begin
        if(s == 8'hf0)
            count = count + 6'b1;
            cnt = count;
            for(i=0;i<10;i=i+1) begin
                if(cnt - 6'd10 > 0)
                    cnt = cnt - 6'd10;
                else 
                    hs[3:0] = cnt[3:0];
                    hs[7:4] = i[3:0];
            end
    end
    bcd7seg i4(.b(hs[7:4]),.h(h[15:8]));
    bcd7seg i5(.b(hs[3:0]),.h(h[7:0]));
    initial begin
        count = 0;
    end
endmodule 

module asc2(din,dout);
    input [7:0] din;
    output reg [7:0] dout;
    always @(din) begin
        case (din)
            8'h16 : dout <= 8'h31;8'h1e : dout <= 8'h32;8'h26 : dout <= 8'h33;8'h25 : dout <= 8'h34;8'h2e : dout <= 8'h35;8'h36 : dout <= 8'h36;
            8'h3d : dout <= 8'h37;8'h3e : dout <= 8'h38;8'h46 : dout <= 8'h39;8'h45 : dout <= 8'h30;8'h15 : dout <= 8'h51;8'h1d : dout <= 8'h57;
            8'h24 : dout <= 8'h45;8'h2d : dout <= 8'h52;8'h2c : dout <= 8'h54;8'h35 : dout <= 8'h59;8'h3c : dout <= 8'h55;8'h43 : dout <= 8'h49;
            8'h44 : dout <= 8'h4f;8'h4d : dout <= 8'h50;8'h1c : dout <= 8'h41;8'h1b : dout <= 8'h53;8'h23 : dout <= 8'h44;8'h2b : dout <= 8'h46;
            8'h34 : dout <= 8'h47;8'h33 : dout <= 8'h48;8'h3b : dout <= 8'h4a;8'h42 : dout <= 8'h4b;8'h4b : dout <= 8'h4c;8'h1a : dout <= 8'h5a;
            8'h22 : dout <= 8'h58;8'h21 : dout <= 8'h43;8'h2a : dout <= 8'h56;8'h32 : dout <= 8'h42;8'h31 : dout <= 8'h4e;8'h3a : dout <= 8'h4d;
            default: dout <= 8'h00;
        endcase
    end
endmodule
