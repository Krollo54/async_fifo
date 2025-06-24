module top_module #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8
)(
    input wire wr_clk,
    input wire rd_clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire full,
    output wire empty
);

    // Internal pointers and signals
    wire [ADDR_WIDTH:0] wptr_bin, rptr_bin;
    wire [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    wire [ADDR_WIDTH:0] wptr_gray_sync, rptr_gray_sync;

    // Convert binary to Gray code
    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // Convert Gray code back to binary for full/empty detection
    function [ADDR_WIDTH:0] gray_to_bin;
        input [ADDR_WIDTH:0] gray;
        integer i;
        begin
            gray_to_bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray[i] ^ gray_to_bin[i+1];
            end
        end
    endfunction

    wire [ADDR_WIDTH:0] rptr_bin_sync = gray_to_bin(rptr_gray_sync);
    wire [ADDR_WIDTH:0] wptr_bin_sync = gray_to_bin(wptr_gray_sync);

    // Full and empty flags
    assign full = (wptr_gray[ADDR_WIDTH]     != rptr_gray_sync[ADDR_WIDTH]) &&
                  (wptr_gray[ADDR_WIDTH-1:0] == rptr_gray_sync[ADDR_WIDTH-1:0]);

    assign empty = (rptr_gray == wptr_gray_sync);

    // ------------------------
    // Module Instantiations
    // ------------------------

    // Write Pointer Generator
    write_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) u_write_pointer (
        .clk  (wr_clk),
        .rst  (rst),
        .wr_en(wr_en & ~full),
        .wptr (wptr_bin)
    );

    // Read Pointer Generator
    read_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) u_read_pointer (
        .clk  (rd_clk),
        .rst  (rst),
        .rd_en(rd_en & ~empty),
        .rptr (rptr_bin)
    );

    // Synchronize read pointer into write clock domain
    synchronizer #(.ADDR_WIDTH(ADDR_WIDTH)) u_sync_rptr_to_wrclk (
        .clk       (wr_clk),
        .rst       (rst),
        .async_ptr (rptr_gray),
        .sync_ptr  (rptr_gray_sync)
    );

    // Synchronize write pointer into read clock domain
    synchronizer #(.ADDR_WIDTH(ADDR_WIDTH)) u_sync_wptr_to_rdclk (
        .clk       (rd_clk),
        .rst       (rst),
        .async_ptr (wptr_gray),
        .sync_ptr  (wptr_gray_sync)
    );

    // Dual-Port Memory
    fifo_memory #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) u_fifo_memory (
        .clk    (wr_clk), // Single-port RAM driven by write clock domain
        .wr_en  (wr_en & ~full),
        .rd_en  (rd_en & ~empty),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .waddr  (wptr_bin[ADDR_WIDTH-1:0]),
        .raddr  (rptr_bin[ADDR_WIDTH-1:0])
    );

endmodule
