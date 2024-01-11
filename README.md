# FPGA-project
# Breakout clone
### Authors: 111321063 111321067 111321074

#### Input/Output unit:<br>
* 8x8 LED 矩陣，用來顯示遊戲畫面。<br>
<img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO1.jpg" width="300"/><br>
* 七段顯示器，用來計分。LED 陣列，用來顯示生命。<br>
<img src="https://github.com/kai2777/Breakout/blob/master/image/Screenshot_20240111_223408_Gallery.jpg" width="300"/><br>
* 8 dipsw，紅色1234代表各關卡。
  
#### 功能說明:<br>
紅在選擇完不同的關卡之後，按下發射鍵即可開始遊玩。
透過4BITS SW按鍵左右移動板子去反彈發射的球來擊破磚塊。
用球擊破磚塊將會獲得1分，如果獲得8分即通關。
每次次遊戲會有八條命，若球從底部落下的話將會扣1生命，生命歸零即失敗。
當四關皆通關將會觸發隱藏關卡，在隱藏關卡中只會有兩條命<br>

#### 程式模組說明:<br>
module final_1(input CLK,
					 input sw_L,
					 input sw_R,
					 input shoot,
					 input pause,
					 input [3:0] back,    //背景變化
					 output [7:0] lightR,
					 output [7:0] lightG,
					 output [7:0] lightB,
					 output reg [2:0] whichCol,  //控制亮哪排
					 output EN,
					 output reg[7:0] win,  //亮燈血槽
                output reg beep,//音樂區
					 output reg a,b,c,d,e,f,g //得分
);

#### 請說明各 I/O 變數接到哪個 FPGA I/O 裝置，例如: button, button2 -> 接到 4-bit SW <br>
sw_L,shoot,sw_R,pause -> 接到 4-bit SW
控制板子移動、射擊與暫停遊戲

input [3:0] back -> 接到 8 dipsw (紅)
設定關卡

output [7:0] lightR,output [7:0] lightG,output [7:0] lightB -> 接到 8x8 LED 矩陣
遊戲畫面
output reg [2:0] whichCol, output EN-> 接到 8x8 LED 矩陣
控制燈亮

output reg[7:0] win -> 接到 LED 陣列
顯示生命

output reg a ,b,c,d,e,f,g -> 接到 七段顯示器
顯示得分

output reg beep -> 蜂鳴器
播放音樂(小蜜蜂)
#### Demo video:

<a href="https://drive.google.com/file/d/1dsUKFF945moWpXyD0L86eseNf1l3repO/view?usp=sharing" title="Demo Video"><img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO4.jpg" alt="Demo Video" width="500"/></a>
