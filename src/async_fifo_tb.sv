//  Module: async_fifo_tb
//
module async_fifo_tb
    /*  package imports  */
    (
    );

    /*  module parameters  */
    parameter WIDTH = 32;
    parameter DEPTH = 8;

    /*  module wires  */
    logic read_clk, write_clk;
    logic read_en, write_en;
    logic [WIDTH-1:0] data_in, data_out;
    logic full, empty;
    logic [DEPTH-1:0] count;
    logic reset;

    /*  module instances  */
    async_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) fifo (
        .read_clk(read_clk),
        .write_clk(write_clk),
        .read_en(read_en),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .count(count),
        .reset(reset)
    );
    // initial conditions
    initial begin
        read_clk = 0;
        write_clk = 0;
        read_en = 0;
        write_en = 0;
        data_in = 0;
        reset = 0;
    end

    /*  module tasks  */
    task read_task;
        begin
            read_en = 1;
            @(posedge read_clk);
            read_en = 0;
        end
    endtask: read_task

    task write_task;
        begin
            write_en = 1;
            @(posedge write_clk);
            write_en = 0;
        end
    endtask: write_task

    // read clock generator
    always #5 read_clk = ~read_clk;

    // write clock generator
    always #10 write_clk = ~write_clk;

    // reset generator
    always #100 reset = 1;
    always #200 reset = 0;

    // data generator
    always #10 data_in = $random;

    // read task generator
    always @(posedge read_clk) begin
        if ($random % 2) begin
            @(posedge read_clk);
            read_en = 1;
        end
        else begin
            @(posedge read_clk);
            read_en = 0;
        end
    end

    // write task generator
    always @(posedge write_clk) begin
        if ($random % 2) begin
            @(posedge write_clk);
            write_en = 1;
        end
        else begin
            @(posedge write_clk);
            write_en = 0;
        end
    end

    // data monitor
    always @(posedge read_clk) begin
        if (read_en) begin
            $display("data_out = %h", data_out);
        end
    end

    // full monitor
    always @(posedge read_clk) begin
        if (read_en) begin
            $display("full = %b", full);
        end
    end

    // empty monitor

    always @(posedge read_clk) begin
        if (read_en) begin
            $display("empty = %b", empty);
        end
    end

    // count monitor

    always @(posedge read_clk) begin
        if (read_en) begin
            $display("count = %b", count);
        end
    end




endmodule: async_fifo_tb
