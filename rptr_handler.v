module Read_Pointer(rd_clk, rd_en, rd_rst, b_rdptr, g_rdptr, g_wrptr_sync, empty);
    
    input rd_clk, rd_en, rd_rst;
    output reg [4:0] b_rdptr;
    output reg [4:0] g_rdptr;
    input [4:0] g_wrptr_sync;
    output reg empty;
    
////    reg [5:0] b_rdptr, g_rdptr; 
////    reg empty;
//      assign g_rdptr = (b_rdptr >> 1) ^ b_rdptr;

    
//    assign rd_empty = (g_rdptr == g_wrptr_sync);
    
//    always@ (posedge rd_clk) begin

//        if(!rd_rst) begin
//            b_rdptr = 0;
//        end
//        else if(rd_en) begin
//            b_rdptr = b_rdptr + 1;
//        end
        
//        empty = rd_empty;
        
//    end


  wire [4:0] b_rdptr_next, g_rdptr_next;
  wire rempty;

  assign b_rdptr_next = b_rdptr+(rd_en & !empty);
  assign g_rdptr_next = (b_rdptr_next >>1)^b_rdptr_next;
  assign rempty = (g_wrptr_sync == g_rdptr_next);
  
  initial begin
    empty <= 0;
  end
  
  always@(posedge rd_clk or negedge rd_rst) begin
    if(!rd_rst) begin
      b_rdptr <= 0;
      g_rdptr <= 0;
    end
    else begin
      b_rdptr <= b_rdptr_next;
      g_rdptr <= g_rdptr_next;
    end
  end
  
  always@(posedge rd_clk or negedge rd_rst) begin
    if(!rd_rst) empty <= 1;
    else        empty <= rempty;
  end
 
endmodule
