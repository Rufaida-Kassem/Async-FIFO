// Module: async_fifo
// Description: Asynchronous FIFO
// Inputs: read_clk, write_clk, read_en, write_en, data_in, reset
// Outputs: data_out, full, empty
// Parameters: DEPTH, WIDTH
// Author: Rufaida Kassem
// Date: 16/03/2023
// Version: 1.0
// Notes:
// 1. The FIFO is contains 2^DEPTH elements
// 2. The FIFO is of WIDTH bits
// 3. The FIFO is implemented using a dual clock domain
// 4. The FIFO is contains synchronizers to synchronize the read and write clocks
//    to avoid metastability

module async_fifo
  /*  package imports  */
  #(
     parameter DEPTH = 8, // depth of the FIFO
     parameter WIDTH = 32 // width of the FIFO
   )
   (
     input read_clk,
     input write_clk,
     input read_en,
     input write_en,
     input [WIDTH-1:0] data_in,
     output reg [WIDTH-1:0] data_out,
     output reg full,
     output reg empty,
     input reset,
     output reg [DEPTH-1:0] count
   );

  // local variables
  logic [DEPTH:0] read_addr;
  logic [DEPTH:0] write_addr;
  logic [WIDTH-1:0] mem [0:2**DEPTH-1];
  logic empty_signal;
  logic full_signal;
  logic [DEPTH:0] read_addr_out_sync;
  logic [DEPTH:0] write_addr_out_sync;
  logic [DEPTH:0] read_addr_gray;
  logic [DEPTH:0] write_addr_gray;

  // modules instantiation
  // instance to convert the binary counter to gray code
  gray_code #(.N_BITS(DEPTH)) gray_code_inst_read
            (
              .binary(read_addr),
              .gray(read_addr_gray)
            );
  // instance to convert the gray code to binary
  gray_code #(.N_BITS(DEPTH)) gray_code_inst_write
            (
              .binary(write_addr),
              .gray(write_addr_gray)
            );

  // instance of the synchronizer for the read to write clock domain
  synchronizer #(.N_BITS(DEPTH)) sync_inst_read
               (
                 .clk(write_clk),
                 .d(read_addr_gray),
                 .q(read_addr_out_sync),
                 .rst(reset)
               );
  // instance of the synchronizer for the write to read clock domain
  synchronizer #(.N_BITS(DEPTH)) sync_inst_write
               (
                 .clk(read_clk),
                 .d(write_addr_gray),
                 .q(write_addr_out_sync),
                 .rst(reset)
               );

  assign empty_signal = (write_addr_out_sync == read_addr_gray);
  assign full_signal = (write_addr_gray == {!read_addr_out_sync[DEPTH:DEPTH-1], read_addr_out_sync[DEPTH-2:0]});
  

  // empty logic block
  always_ff @(posedge read_clk or negedge reset)
  begin
    if (!reset)
    begin
      empty <= 1'b1;
    end
    else
    begin
      empty <= empty_signal;
        end
  end


  // full logic block
  always_ff @(posedge write_clk or negedge reset)
  begin
    if (!reset)
    begin
      full <= 1'b0;
    end
    else
    begin
      full <= full_signal;
    end
  end

  always_ff @(posedge write_clk or negedge reset)
  begin
    if (!reset)
    begin

      write_addr <= 0;
    end
    else if (write_en && !full_signal)
    begin
      mem[write_addr[DEPTH-1:0]] <= data_in;
      write_addr <= write_addr + 1;
    end
  end

  always_ff @(posedge read_clk, negedge reset)
  begin
    if (!reset)
    begin
      read_addr <= 0;

    end
    else if (read_en && !empty_signal)
    begin
      data_out <= mem[read_addr[DEPTH-1:0]];
      read_addr <= read_addr + 1;
    end
  end
  // // block to count the number of elements in the FIFO
  //   always_ff @(posedge write_clk or negedge reset)
  //   begin
  //     if (!reset)
  //     begin
  //       count <= 0;
  //     end
  //     else if (write_en && !full_signal)
  //     begin
  //       count <= count + 1;
  //     end
  //     else if (read_en && !empty_signal)
  //     begin
  //       count <= count - 1;
  //     end
  //   end
endmodule:
async_fifo
