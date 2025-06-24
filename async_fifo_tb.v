module FIFO_tb;

wire [7:0] data_out;
wire full, empty;
reg [7:0] data_in;
reg rd_clk, rd_en, wr_clk, wr_en, wr_rst, rd_rst;

integer i, j;

Top DUT(data_in, data_out, rd_clk, wr_clk ,rd_rst, wr_rst, rd_en, wr_en, empty, full);

always #8 wr_clk = ~wr_clk;
always #25 rd_clk = ~rd_clk;


initial begin 
   
    rd_clk = 1'b0; rd_rst = 1'b0; rd_en = 1'b0;
    data_in = 0;
    
    repeat(1) @(posedge wr_clk);
    wr_rst = 1'b1;
    
    repeat(2)begin
    for(i=0;i<30;i=i+1) 
    begin
        @(posedge rd_clk)
        begin
            if(!empty && (i%2 !== 0))
            begin
                rd_en = 1'b1;
                $display("Data out = %h", data_out);
            end
            else
                rd_en = 1'b0;
        end
    end
    #100;
    end
end

initial begin

    wr_clk = 1'b0; wr_rst = 1'b0; wr_en = 1'b0;
    
    repeat(1) @(posedge rd_clk);
    rd_rst = 1'b1;
    
    repeat(2)begin
    for(j=0;j<60;j=j+1) 
    begin
        @(posedge wr_clk)
        begin
            if(!full && (j%2 !== 0))
            begin
                wr_en = 1'b1;
                $display("Data in = %h", data_in);
                data_in = data_in + 3;
            end
            else
            begin
                wr_en = 1'b0;
            end
        end
    end
    end
    
    #100000;
    $finish;
    
end 

endmodule
