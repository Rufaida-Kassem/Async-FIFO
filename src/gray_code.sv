// This is a design for a binary to gray code converter

//  Module: gray_code
//
module gray_code
    /*  package imports  */
    #(
        N_BITS = 8  // number of bits
    )(
        input  [N_BITS:0] binary, // binary input
        output [N_BITS:0]  gray   // gray code output
    );

    assign gray = binary ^ (binary >> 1);
    
endmodule: gray_code
