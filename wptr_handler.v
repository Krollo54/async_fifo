module Write_Pointer(wr_clk, wr_en, wr_rst, b_wrptr, g_wrptr, g_rdptr_sync, full);

    input wr_clk, wr_en, wr_rst;
    output reg [4:0] b_wrptr;
    output reg [4:0] g_wrptr;
    input [4:0] g_rdptr_sync;
    output reg full;
       
//    reg [5:0] b_wrptr, g_wrptr;
//    reg full;
//    assign g_wrptr = (b_wrptr >> 1) ^ b_wrptr;

    
//    assign wr_full = (g_wrptr == {~g_rdptr_sync[5], g_rdptr_sync[4:0]});
    
//    always@ (posedge wr_clk) begin

//        if(!wr_rst) begin
//            b_wrptr = 0;
//        end
//        else if(wr_en) begin
//            b_wrptr = b_wrptr + 1;
//        end 
        
//        full = wr_full;

//    end
   
 wire [4:0] b_wrptr_next, g_wrptr_next;
   
  reg wrap_around;
  wire wfull;
  
  assign b_wrptr_next = b_wrptr+(wr_en & !full);
  assign g_wrptr_next = (b_wrptr_next >>1)^b_wrptr_next;
  
  initial begin
    full <= 0;
  end
  
  always@(posedge wr_clk or negedge wr_rst) begin
    if(!wr_rst) begin
      b_wrptr <= 0; // set default value
      g_wrptr <= 0;
    end
    else begin
      b_wrptr <= b_wrptr_next; // incr binary write pointer
      g_wrptr <= g_wrptr_next; // incr gray write pointer
    end
  end
  
  always@(posedge wr_clk or negedge wr_rst) begin
    if(!wr_rst) full <= 0;
    else        full <= wfull;
  end

  assign wfull = (g_wrptr_next == {~g_rdptr_sync[4:3], g_rdptr_sync[2:0]});
  
endmodule
