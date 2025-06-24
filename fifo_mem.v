module Memory(
    input [7:0] data_in,
    output reg [7:0] data_out,
    input wr_en, wr_clk, rd_en, rd_clk,
    input [3:0] b_wrptr, b_rdptr,
    input full, empty
    );
    
    reg [7:0] memory [15:0];
    
    always@ (posedge wr_clk) begin
        if( wr_en & !full) begin
            memory[b_wrptr] <= data_in;
        end
     end

    always@ (posedge rd_clk) begin
        if( rd_en & !empty) begin
            data_out <= memory[b_rdptr];
        end
    end 
          
endmodule
