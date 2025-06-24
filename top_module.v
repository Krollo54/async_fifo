module Top(
    input [7:0] data_in,
    output [7:0] data_out,
    input rd_clk, wr_clk, rd_rst, wr_rst, rd_en, wr_en,
    output wire empty, full
    );
    
    wire [4:0] b_wrptr, g_wrptr, g_wrptr_sync;
//    wire full, empty;
    wire [4:0] b_rdptr, g_rdptr, g_rdptr_sync;
    
    Memory M1 (data_in, data_out, wr_en, wr_clk, rd_en, rd_clk, b_wrptr[3:0], b_rdptr[3:0], full, empty);
    Read_Pointer A1 (rd_clk, rd_en, rd_rst, b_rdptr, g_rdptr, g_wrptr_sync, empty);
    Write_Pointer A2 (wr_clk, wr_en, wr_rst, b_wrptr, g_wrptr, g_rdptr_sync, full);
    Synchroniser S1 (rd_clk, rd_rst, g_wrptr, g_wrptr_sync);
    Synchroniser S2 (wr_clk, wr_rst, g_rdptr, g_rdptr_sync);
    
endmodule
