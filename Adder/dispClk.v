`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 06:00:23 PM
// Design Name: 
// Module Name: dispClk
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


module dispClk(
    input clk,
    output reg [1:0] out
);

reg [16:0] counterout;
always @(posedge(clk))
begin
     if (clk) counterout <= counterout + 1;
end

always @ (posedge(counterout[16]))
begin
     out <= out + 1;
end

endmodule
