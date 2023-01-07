`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 06:00:36 PM
// Design Name: 
// Module Name: mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux(
   input [1:0] select,
    input [3:0] one,
    input [3:0] ten,
    input [3:0] hunnid,
    input [3:0] thousand,
    output reg [3:0] out
    );

always @(*)
begin
    case(select)
        2'b00: out <= one;
        2'b01: out <= ten;
        2'b10: out <= hunnid;
        2'b11: out <= thousand;
     endcase
end
endmodule
