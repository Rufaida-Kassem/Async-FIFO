// This is the design of the 2-flipflop synchronizer
// The 2-flipflop synchronizer is used to synchronize the clock

// module declaration
//  Module: synchronizer
//
module synchronizer
  /*  package imports  */
  #(
     N_BITS = 8  // number of bits
   )
   (
     input logic clk,
     input logic rst,
     input  logic [N_BITS:0] d,
     output logic [N_BITS:0]  q
   );

  // local variables
  logic [N_BITS:0] q1;

  // always block
  always_ff @(posedge clk or negedge rst)
  begin
    if (!rst)
    begin
      q1 <= 'b0;
      q <= 'b0;
    end
    else
    begin
      q1 <= d;
      q <= q1;
    end
  end
endmodule:
synchronizer
