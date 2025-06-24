module Synchroniser(clk, rst, ptr, sync_ptr);

    input clk, rst;
    input [4:0] ptr;
    output reg [4:0] sync_ptr;
    reg [4:0] d;
//    reg [5:0] d, sync_ptr; 
   
    always@ (posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            d <= 0;
            sync_ptr <= 0;
        end 
        else
        begin
            d <= ptr;
            sync_ptr <= d;
        end
    end
    
endmodule
