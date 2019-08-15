`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/26 15:29:18
// Design Name: 
// Module Name: ctrl_uart
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


module ctrl_uart(
input clk_50, //50MHZ
input rst_n,   //�͵�ƽ��λ
input [95:0] data,  //���͵����ݣ������Ϊ8���������������ĵĻ��ڲ��ĺ���ҲҪ΢��һ��
input en,          //�ߵ�ƽ��Ч����ʾҪ�������ݣ�Ҫһֱ������busyΪ�ߣ������ط���ȥ
output tx,        //���Ӱ��ӷ���tx��IO����
output busy    //�ߵ�ƽ��ʾ���ڷ��ͣ��͵�ƽ��ʾ�ȴ���Ϣ
    );

reg busy_reg;

reg [103:0] send_data;

reg [3:0] ctrl_status; //[1,13] ,, 14->0
reg ctrl_int;
wire ctrl_busy;

reg last_en;
  
assign busy=(busy_reg|ctrl_busy);
   
always @(posedge clk_50 or negedge rst_n) begin
    if(!rst_n) begin
        last_en = 1'b0;
        busy_reg = 1'b0;
        send_data=104'd0;
        ctrl_int=1'b1;
        ctrl_status = 4'd0;
    end
    else begin
        if((!last_en)&en) begin  //������
            send_data[103:8] = data[95:0];
            send_data[7:0] = 8'b11110000;
            busy_reg = 1'b1; //send open 
        end
        
        last_en=en;
        
        ///////////////
        if(ctrl_busy) begin
            if (!ctrl_int) begin
                send_data = (send_data<<8); //�ɹ�����һ��
            end
            
            ctrl_int = 1'b1;  //��λ
        end
        else begin
           if(ctrl_int) begin
               //�����ж�
               if(busy_reg) begin
                   ctrl_status = ctrl_status + 1'b1;
                   if(ctrl_status >= 4'd14) begin
                        ctrl_status=4'd0;
                        busy_reg = 1'b0; //stop
                   end
                   else begin
                        ctrl_int = 1'b0;//�½��ط��� 
                   end
               end           
              
           end 
            
        end
    end
end
 
   utx t1(
   .clk(clk_50),
   .rst_n(rst_n),
   .data(send_data[103:96]),
   .tx_int(ctrl_int),
   .tx(tx),
   .busy(ctrl_busy)
);   
    
endmodule
