`timescale 1ns/1ps
module pipeline_register #(
    parameter WIDTH = 4
)(
    input  clk,
    input  rst,

    // Input side
    input  in_valid,
    input  out_ready,
    input  [WIDTH-1:0] in,

    // Output side
    output out_valid,
    output in_ready,
    output reg  [WIDTH-1:0] out
);

    reg full;

    assign in_ready  = ~full || out_ready;
    assign out_valid = full;

    always @(posedge clk) begin
        if (rst) begin
            full <= 1'b0;
            out  <= '0;
        end
        else begin
            // Load new data
            if (in_valid && in_ready) begin
                out  <= in;
                full <= 1'b1;
            end
            // Consume data without replacement
            else if (full && out_ready) begin
                full <= 1'b0;
                out  <= '0; 
            end
        end
    end

endmodule
