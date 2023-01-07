`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 06:01:39 PM
// Design Name: 
// Module Name: wrapper
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


module wrapper(
input clk, [7:0] sw, [2:0] btn,
    output [6:0] seg_cat, [3:0] seg_an
    );
    
reg [7:0] num1, num2;
reg signed [7:0] neg;
wire [15:0] result;

always @ (posedge(clk)) begin
    if (btn[0]) num1 <= sw;
    if (btn[1]) num2 <= sw;
end

always @(btn[2]) begin
    if(btn[2]) neg = -num1;
    else neg = num1;
end

assign result = neg + num2;

wire [15:0] bcd;

BCD BCD(.bin(result), .bcd(bcd));


ssegController sseg(.one(bcd[3:0]), .ten(bcd[7:4]), .hunnid(bcd[11:8]), .thousand(bcd[15:12]), .clk(clk), .seg_an(seg_an), .seg_cat(seg_cat));

endmodule
