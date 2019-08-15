`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/01 15:46:47
// Design Name: 
// Module Name: recv_uart
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


module recv_uart(
input clk_50,   //50MHz
input rst_n,     //�͵�ƽ��λ
input rx,         //���Ӱ��ӽ���rx��IO����
///////////////
output [7:0] rx_data,   //���յ������ݣ���һֱ����ֱ���´�ˢ��
output valid   //��������Ч������ʱ��һ��50MHz��ʱ�ӣ���ʾ�������ݡ� //�ο����÷�ʽ:top.v,����reg������ʽ��ֵ�����д�����always clk�ڼ��������
    );
    
    wire temp_valid;
    assign valid = ~temp_valid;
    urx urx1(
    .clk(clk_50),
    .rst_n(rst_n),
    .rx(rx),
    .rx_data(rx_data),
    .rx_int(temp_valid)
    );
endmodule
