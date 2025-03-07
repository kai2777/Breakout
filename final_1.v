module divfreq(input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
	begin
		if(Count > 50000)
		begin
			Count <= 24'b0;
			CLK_div <= ~CLK_div;
		end
		else
			Count <= Count + 1'b1;
	end
endmodule

module divmove(input pause, input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
	begin
		if(Count > 4000000)
		begin
			Count <= 24'b0;
			CLK_div <= ~CLK_div;
		end
		else
		begin
		   if(pause)
				Count <= Count;
			else
				Count <= Count + 1'b1;
	   end
	end
endmodule

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

reg [7:0] state [7:0];//表哪些燈有亮
reg [7:0] stateR [7:0];
reg [7:0] stateG [7:0];
reg [7:0] stateB [7:0];
integer i, panel_center, alreadyShoot, ball_x, ball_y, direction, forward, go_mode, background, con, hp, counter;
reg [22:0] j;
reg clk_4hz;
reg [16:0] count,div_num;//
reg [7:0] music;





always @(posedge CLK)//4hz
begin
if(j==23'h47868c)
begin
j<=0;
clk_4hz=~clk_4hz;
end
else
j=j+1'b1;
end

	
always @(posedge clk_4hz)
begin
if(music==8'd208)//只有207個音
music<=0;
else
music<=music+1'b1;
end
	
always @(posedge CLK)
begin
if(count==div_num)
begin
count<=0;
beep=~beep;
end
else
count<=count+1'b1;
end
	
parameter 
L1=17'h1754e,
L2=17'h14c81,
L3=17'h1284a,
L4=17'h117A8,
L5=17'h14e70,
L6=17'h0ddf2,
L7=17'h0c5ba,
M1=17'h0ba9e,//DO
M2=17'h0a648,//RE
M3=17'h0941f,//ME
M4=17'h08bcf,//FA
M5=17'h07c90,//SO
M6=17'h06ef9,//LA
M7=17'h062dd,//SI
H1=17'h05d68,
H2=17'h05322,
H3=17'h04a11,
H4=17'h045e9,
H5=17'h3e48,
H6=17'h377d,
H7=17'h316f;

always @(posedge clk_4hz)
begin
case(music)
//嗡嗡嗡
8'd0 : div_num=M5;//嗡
8'd1 : div_num=M5;
8'd2 : div_num=M3;//嗡
8'd3 : div_num=M3;
8'd4 : div_num=M3;//嗡
8'd5 : div_num=M3;
//8'd6 : div_num=L0;
//8'd7 : div_num=L0;
//嗡嗡嗡
8'd8 : div_num=M4;
8'd9 : div_num=M4;
8'd10 : div_num=M2;
8'd11 : div_num=M2;
8'd12 : div_num=M2;
8'd13 : div_num=M2;
//8'd14 : div_num=L0;
//8'd15 : div_num=L0;
//大家一起
8'd16 : div_num=M1;
8'd17 : div_num=M1;
8'd18 : div_num=M2;
8'd19 : div_num=M2;
8'd20 : div_num=M3;
8'd21 : div_num=M3;
8'd22 : div_num=M4;
8'd23 : div_num=M4;
//勤做工
8'd24 : div_num=M5;
8'd25 : div_num=M5;
8'd26 : div_num=M5;
8'd27 : div_num=M5;
8'd28 : div_num=M5;
8'd29 : div_num=M5;
//8'd30 : div_num=L0;
//8'd31 : div_num=L0;
//來匆匆
8'd32 : div_num=M5;
8'd33 : div_num=M5;
8'd34 : div_num=M3;
8'd35 : div_num=M3;
8'd36 : div_num=M3;
8'd37 : div_num=M3;
//8'd38 : div_num=L0;
//8'd39 : div_num=L0;
//去匆匆
8'd40 : div_num=M4;
8'd41 : div_num=M4;
8'd42 : div_num=M2;
8'd43 : div_num=M2;
8'd44 : div_num=M2;
8'd45 : div_num=M2;
//8'd46 : div_num=L0;
//8'd47 : div_num=L0;
//做工趣味
8'd48 : div_num=M1;
8'd49 : div_num=M1;
8'd50 : div_num=M3;
8'd51 : div_num=M3;
8'd52 : div_num=M5;
8'd53 : div_num=M5;
8'd54 : div_num=M5;
8'd55 : div_num=M5;
//濃
8'd56 : div_num=M3;
8'd57 : div_num=M3;
//8'd58 : div_num=L0;
//8'd59 : div_num=L0;
//8'd60 : div_num=L0;
//8'd61 : div_num=L0;
//8'd62 : div_num=L0;
//8'd63 : div_num=L0;
//天暖花好
8'd64 : div_num=M2;
8'd65 : div_num=M2;
8'd66 : div_num=M2;
8'd67 : div_num=M2;
8'd68 : div_num=M2;
8'd69 : div_num=M2;
8'd70 : div_num=M2;
8'd71 : div_num=M2;
//不做工
8'd72 : div_num=M2;
8'd73 : div_num=M2;
8'd74 : div_num=M3;
8'd75 : div_num=M3;
8'd76 : div_num=M4;
8'd77 : div_num=M4;
//8'd78 : div_num=L0;
//8'd79 : div_num=L0;
//將來哪裡
8'd80 : div_num=M3;
8'd81 : div_num=M3;
8'd82 : div_num=M3;
8'd83 : div_num=M3;
8'd84 : div_num=M3;
8'd85 : div_num=M3;
8'd86 : div_num=M3;
8'd87 : div_num=M3;
//好過冬
8'd88 : div_num=M3;
8'd89 : div_num=M3;
8'd90 : div_num=M4;
8'd91 : div_num=M4;
8'd92 : div_num=M5;
8'd93 : div_num=M5;
//8'd94 : div_num=L0;
//8'd95 : div_num=L0;
//嗡嗡嗡
8'd96 : div_num=M5;
8'd97 : div_num=M5;
8'd98 : div_num=M3;
8'd99 : div_num=M3;
8'd100: div_num=M3;
8'd101: div_num=M3;
//8'd102: div_num=M0;
//8'd103: div_num=M0;
//嗡嗡嗡
8'd104: div_num=M4;
8'd105: div_num=M4;
8'd106: div_num=M2;
8'd107: div_num=M2;
8'd108: div_num=M2;
8'd109: div_num=M2;
//8'd110: div_num=M0;
//8'd111: div_num=M0;
//別學懶惰
8'd112: div_num=M1;
8'd113: div_num=M1;
8'd114: div_num=M3;
8'd115: div_num=M3;
8'd116: div_num=M5;
8'd117: div_num=M5;
8'd118: div_num=M5;
8'd119: div_num=M5;
//蟲
8'd120: div_num=M1;
8'd121: div_num=M1;
//8'd122: div_num=M0;
//8'd123: div_num=M0;
//8'd124: div_num=M0;
//8'd125: div_num=M0;
//8'd126: div_num=M0;
//8'd127: div_num=M0;
endcase
end






initial
begin
   background = 0;
	panel_center = 4;
	whichCol=0;
	alreadyShoot = 0;
	ball_x = 4;
	ball_y = 6;
	go_mode = 11;
	con = 0;
	hp = 8;
	counter = 0;
end

divfreq f0(CLK, CLK_div);
divmove f1(pause, CLK, CLK_move);

always @(posedge CLK_move)
begin

	case (back)//選關
	    4'b0000: background=0;
		 4'b0001: background=1;
       4'b0010: background=2;
       4'b0100: background=3;
       4'b1000: background=4;
		 4'b1111: background=5;
   endcase
	
	if(background==1)//關卡一
	begin   
	  {a,b,c,d,e,f,g}<= 7'b0000001;
	  win<=8'b11111111;
	  con=0;
	  hp=8;
	  counter=1;
	  for (i=0;i<8;i=i+1)
	  begin//背景形狀+顏色
       state[i] = 8'b00001100;//有多加一個1
		 stateR[i] = 8'b00001100;
		 stateG[i] = 8'b00001100;
		 stateB[i] = 8'b00000000;
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==2)//關卡二
	begin
	  {a,b,c,d,e,f,g}<= 7'b0000001;
	  win<=8'b11111111;
	  con=0;
	  hp=8;
	  
	  if(counter==1)
	  begin
		counter=2;
	  end
	  
	  for (i=0;i<8;i=i+1)
	  begin
       state[i] = 8'b00001001;
		 stateR[i] = 8'b00000000;
		 stateG[i] = 8'b00001001;
		 stateB[i] = 8'b00001001;
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==3)//關卡三
	begin
	  {a,b,c,d,e,f,g}<= 7'b0000001;
	  win<=8'b11111111;
	  con=0;
	  hp=8;
	  
	  if(counter==2)
	  begin
		counter=3;
	  end
	  
	  for (i=0;i<8;i=i+1)
	  begin
       state[i] = 8'b00001111;
	    stateR[i] = 8'b00001111;
		 stateG[i] = 8'b00000000;
		 stateB[i] = 8'b00001111;
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==4)//關卡四
	begin
	  {a,b,c,d,e,f,g}<= 7'b0000001;
	  win<=8'b11111111;
	  con=0;
	  hp=8;
	  
	  if(counter==3)
	  begin
		counter=4;
	  end
	  
	  state[0] = 8'b00000010;
	  state[1] = 8'b00000010;
	  state[2] = 8'b00000100;
	  state[3] = 8'b00001110;
  	  state[4] = 8'b00001110;
	  state[5] = 8'b00000100;
	  state[6] = 8'b00000010;
	  state[7] = 8'b00000010;
	  
	  stateR[0] = 8'b00000000;
	  stateR[1] = 8'b00000000;
	  stateR[2] = 8'b00000000;
	  stateR[3] = 8'b00000000;
  	  stateR[4] = 8'b00000000;
	  stateR[5] = 8'b00000000;
	  stateR[6] = 8'b00000000;
	  stateR[7] = 8'b00000000;
	  
	  stateG[0] = 8'b00000010;
	  stateG[1] = 8'b00000010;
	  stateG[2] = 8'b00000100;
	  stateG[3] = 8'b00001110;
  	  stateG[4] = 8'b00001110;
	  stateG[5] = 8'b00000100;
	  stateG[6] = 8'b00000010;
	  stateG[7] = 8'b00000010;
	  
	  stateB[0] = 8'b00000010;
	  stateB[1] = 8'b00000010;
	  stateB[2] = 8'b00000100;
	  stateB[3] = 8'b00001110;
  	  stateB[4] = 8'b00001110;
	  stateB[5] = 8'b00000100;
	  stateB[6] = 8'b00000010;
	  stateB[7] = 8'b00000010;
	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(background==5&counter==4)//關卡五(隱藏關卡)
	begin   
	  {a,b,c,d,e,f,g}<= 7'b0000001;
	  win<=8'b11000000;
	  con=0;
	  hp=2;
	  
	  if(counter==4)
	  begin
		counter=0;
	  end
	  
		  state[0] = 8'b00101001;
		  state[1] = 8'b00000000;
		  state[2] = 8'b00001000;
		  state[3] = 8'b00000000;
		  state[4] = 8'b00000000;
		  state[5] = 8'b00001000;
		  state[6] = 8'b00000000;
		  state[7] = 8'b00101001;
		  
		  stateR[0] = 8'b00101001;
		  stateR[1] = 8'b00000000;
		  stateR[2] = 8'b00001000;
		  stateR[3] = 8'b00000000;
		  stateR[4] = 8'b00000000;
		  stateR[5] = 8'b00001000;
		  stateR[6] = 8'b00000000;
		  stateR[7] = 8'b00101001;
		  
		  stateG[0] = 8'b00000000;
		  stateG[1] = 8'b00000000;
		  stateG[2] = 8'b00000000;
		  stateG[3] = 8'b00000000;
		  stateG[4] = 8'b00000000;
		  stateG[5] = 8'b00000000;
		  stateG[6] = 8'b00000000;
		  stateG[7] = 8'b00000000;
		  
		  stateB[0] = 8'b00000000;
		  stateB[1] = 8'b00000000;
		  stateB[2] = 8'b00000000;
		  stateB[3] = 8'b00000000;
		  stateB[4] = 8'b00000000;
		  stateB[5] = 8'b00000000;
		  stateB[6] = 8'b00000000;
		  stateB[7] = 8'b00000000;
		  
	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=3 & i<=5)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==4)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	
	if(background==0)//開始玩
	begin
	if(con>=0)
	begin
	   if(con==0)   {a,b,c,d,e,f,g}<= 7'b0000001; //分數
		else if(con==1)   {a,b,c,d,e,f,g}<= 7'b1001111;
		else if(con==2)   {a,b,c,d,e,f,g}<= 7'b0010010;
		else if(con==3)   {a,b,c,d,e,f,g}<= 7'b0000110;
		else if(con==4)   {a,b,c,d,e,f,g}<= 7'b1001100;
	   else if(con==5)   {a,b,c,d,e,f,g}<= 7'b0100100;
	   else if(con==6)   {a,b,c,d,e,f,g}<= 7'b0100000;
	   else if(con==7)   {a,b,c,d,e,f,g}<= 7'b0001111;
	   else if(con==8)   
		begin //贏了
			state[0] = 8'b00000110;
			state[1] = 8'b00010010;
			state[2] = 8'b00100110;
			state[3] = 8'b01000000;
			state[4] = 8'b01000000;
			state[5] = 8'b00100110;
			state[6] = 8'b00010010;
			state[7] = 8'b00000110;
			
			stateR[0] = 8'b00000110;			
			stateR[1] = 8'b00010010;
			stateR[2] = 8'b00100110;
			stateR[3] = 8'b01000000;
			stateR[4] = 8'b01000000;
			stateR[5] = 8'b00100110;
			stateR[6] = 8'b00010010;
			stateR[7] = 8'b00000110;
			
			stateG[0] = 8'b00000000;			
			stateG[1] = 8'b00000000;
			stateG[2] = 8'b00000000;
			stateG[3] = 8'b00000000;
			stateG[4] = 8'b00000000;
			stateG[5] = 8'b00000000;
			stateG[6] = 8'b00000000;
			stateG[7] = 8'b00000000;
			
			stateB[0] = 8'b00000110;
			stateB[1] = 8'b00010010;
			stateB[2] = 8'b00100110;
			stateB[3] = 8'b01000000;
			stateB[4] = 8'b01000000;
			stateB[5] = 8'b00100110;
			stateB[6] = 8'b00010010;
			stateB[7] = 8'b00000110;
			
			background=0;
			panel_center = 4;
			alreadyShoot = 0;
			ball_x = 4;
			ball_y = 6;
			go_mode = 11;
			con=0;
			hp=8;
			{a,b,c,d,e,f,g}<= 7'b0000000;
			win<=8'b11111111;
		end
	end
	
	if(hp>=0)
	begin
	   if(hp==8)   win<=8'b11111111; //血量or血槽
		else if(hp==7)   win<=8'b11111110;
		else if(hp==6)   win<=8'b11111100;
		else if(hp==5)   win<=8'b11111000;
		else if(hp==4)   win<=8'b11110000;
	   else if(hp==3)   win<=8'b11100000;
	   else if(hp==2)   win<=8'b11000000;
	   else if(hp==1)   win<=8'b10000000;
	   else if(hp==0)   
		begin //輸了
				state[0] = 8'b11111111;
				state[1] = 8'b11000011;
				state[2] = 8'b10100101;
				state[3] = 8'b10011001;
				state[4] = 8'b10011001;
				state[5] = 8'b10100101;
				state[6] = 8'b11000011;
				state[7] = 8'b11111111;
					
				stateR[0] = 8'b11111111;
				stateR[1] = 8'b11000011;
				stateR[2] = 8'b10100101;
				stateR[3] = 8'b10011001;
				stateR[4] = 8'b10011001;
				stateR[5] = 8'b10100101;
				stateR[6] = 8'b11000011;
				stateR[7] = 8'b11111111;
					
				stateG[0] = 8'b00000000;
				stateG[1] = 8'b00000000;
				stateG[2] = 8'b00000000;
				stateG[3] = 8'b00000000;
				stateG[4] = 8'b00000000;
				stateG[5] = 8'b00000000;
				stateG[6] = 8'b00000000;
				stateG[7] = 8'b00000000;

				stateB[0] = 8'b00000000;
				stateB[1] = 8'b00000000;
				stateB[2] = 8'b00000000;
				stateB[3] = 8'b00000000;
				stateB[4] = 8'b00000000;
				stateB[5] = 8'b00000000;
				stateB[6] = 8'b00000000;
				stateB[7] = 8'b00000000;

				background=0;
				panel_center = 4;
				alreadyShoot = 0;
				ball_x = 4;
				ball_y = 6;
				go_mode = 11;
				con=0;
				hp=0;
				{a,b,c,d,e,f,g}<= 7'b0000001;
				win<=8'b00000000;
		end
	end
	
	if (sw_L)
	begin
		if (panel_center-2 >= 0)//防超出邊界
		begin
			panel_center = panel_center - 1;
			if (alreadyShoot==0)//未射擊
			begin //把球向左邊移並刪除原本的球
				state[panel_center][6]=1;
				stateR[panel_center][6]=1;
				stateG[panel_center][6]=1;
				stateB[panel_center][6]=1;
				state[panel_center+1][6]=0;
				stateR[panel_center+1][6]=0;
				stateG[panel_center+1][6]=0;
				stateB[panel_center+1][6]=0;
				ball_x = ball_x - 1;
			end //把球板向左邊移並刪除因移動而原本凸出來的部分		
			state[panel_center-1][7]=1;
			stateR[panel_center-1][7]=0;
			stateG[panel_center-1][7]=0;
			stateB[panel_center-1][7]=1;
			state[panel_center+2][7]=0;
			stateR[panel_center+2][7]=0;
			stateG[panel_center+2][7]=0;
			stateB[panel_center+2][7]=0;
		end
	end
	
	if (sw_R)
	begin
		if (panel_center+2 <= 7)
		begin
			panel_center = panel_center + 1;
			if (alreadyShoot==0)
			begin
				state[panel_center][6]=1;
				stateR[panel_center][6]=1;
				stateG[panel_center][6]=1;
				stateB[panel_center][6]=1;
				state[panel_center-1][6]=0;
				stateR[panel_center-1][6]=0;
				stateG[panel_center-1][6]=0;
				stateB[panel_center-1][6]=0;
				ball_x = ball_x + 1;
			end
			state[panel_center+1][7]=1;
			stateR[panel_center+1][7]=0;
			stateG[panel_center+1][7]=0;
			stateB[panel_center+1][7]=1;
			state[panel_center-2][7]=0;
			stateR[panel_center-2][7]=0;
			stateG[panel_center-2][7]=0;
			stateB[panel_center-2][7]=0;
		end
	end
		
	if (shoot)
	begin
		state[ball_x][ball_y] = 0;
		stateR[ball_x][ball_y] = 0;
		stateG[ball_x][ball_y] = 0;
		stateB[ball_x][ball_y] = 0;
		alreadyShoot = 1;
		go_mode = 11;
	end	
		
	if (alreadyShoot)
	begin
		case(go_mode)
		11:     //直上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			ball_y = ball_y - 1;
			if (state[ball_x][ball_y]==1&&ball_y>=0) //打到磚塊
			begin
			   con=con+1;
				ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;
				go_mode = 21;
				if (state[ball_x][ball_y-2]==1) //刪掉原本的球
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else if(ball_y<0) //打到上牆
			begin
			   ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;	
				go_mode = 21;
				if (state[ball_x][ball_y-2]==1)
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else //沒打到就前進
			begin
				state[ball_x][ball_y] = 1;
				stateR[ball_x][ball_y] = 1;
				stateG[ball_x][ball_y] = 1;
				stateB[ball_x][ball_y] = 1;
			end
		end
		12:     //左上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==0||ball_y==0)//左邊界或上邊界
			begin
			   if(ball_x==0&&ball_y==0)//左上的角
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode= 23;
				end
				else if(ball_x==0)//左邊界
				begin
					if(state[ball_x+1][ball_y-1]==1)
					begin
						state[ball_x+1][ball_y-1]=0;
						stateR[ball_x+1][ball_y-1]=0;
						stateG[ball_x+1][ball_y-1]=0;
						stateB[ball_x+1][ball_y-1]=0;
						con=con+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=23;
					end
				   else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=13;
					end
				end
				else
				begin
					ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=22;
				end			
			end
			else
			begin
				if(state[ball_x-1][ball_y-1]==1)//打到磚塊
				begin
				   state[ball_x-1][ball_y-1]=0;
					stateR[ball_x-1][ball_y-1]=0;
					stateG[ball_x-1][ball_y-1]=0;
					stateB[ball_x-1][ball_y-1]=0;
					con=con+1;
					go_mode=23;//右下
				end
				else
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=12;
				end
			end
		end
		13:     //右上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==7||ball_y==0)//右邊界或上邊界
			begin
			   if(ball_x==7&&ball_y==0)//右上的腳
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode= 22;//左下
				end
				else if(ball_x==7)//右邊界
				begin
					if(state[ball_x-1][ball_y-1]==1)
					begin
						state[ball_x-1][ball_y-1]=0;
						stateR[ball_x-1][ball_y-1]=0;
						stateG[ball_x-1][ball_y-1]=0;
						stateB[ball_x-1][ball_y-1]=0;
						con=con+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=22;
					end
				   else
					begin
						ball_x=ball_x-1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=12;
					end
				end
				else//上邊界
				begin
					ball_x=ball_x+1;
					ball_y=ball_y+1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					state[ball_x][ball_y]=1;
					go_mode=23;
				end			
			end
			else//沒有打到邊界們
			begin
				if(state[ball_x+1][ball_y-1]==1)//打到磚塊
				begin
					state[ball_x+1][ball_y-1]=0;
					stateR[ball_x+1][ball_y-1]=0;
					stateG[ball_x+1][ball_y-1]=0;
					stateB[ball_x+1][ball_y-1]=0;
					con=con+1;
					go_mode=22;//左下
				end
				else//持續右上
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=13;
				end
			end
		end
		21:      //直下
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_y==6 && ball_x >= panel_center-1 && ball_x <= panel_center+1)    //打到平台
			begin
				ball_y = ball_y - 1;
				if (ball_x == panel_center)     //打到平台中間
				begin
					go_mode = 11;
					state[ball_x][ball_y] = 1;
					stateR[ball_x][ball_y] = 1;
					stateG[ball_x][ball_y] = 1;
					stateB[ball_x][ball_y] = 1;
				end
				else //左或右                         
				begin
					if (ball_x == panel_center-1)  //打到平台左邊
					begin
						go_mode = 12;//左上
						if (ball_x-1 < 0)//左邊界
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
							go_mode = 13;//右上
						end
						else//一直左上
						begin
							ball_x = ball_x - 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
					else                           //打到平台右邊
					begin
						go_mode = 13;//右上
						if (ball_x + 1 > 7)//右邊界
						begin
							ball_x = ball_x - 1;
							go_mode = 12;//左上
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
						   stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
						else//一直右上
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
				end
			end
			else//沒有打到平台
			begin
				if (ball_y==7)//掉下去
				begin
					if (hp == 0)//血量用完
					begin
						state[0] = 8'b11111111;
						state[1] = 8'b11000011;
						state[2] = 8'b10100101;
						state[3] = 8'b10011001;
						state[4] = 8'b10011001;
						state[5] = 8'b10100101;
						state[6] = 8'b11000011;
						state[7] = 8'b11111111;
							
						stateR[0] = 8'b11111111;
						stateR[1] = 8'b11000011;
						stateR[2] = 8'b10100101;
						stateR[3] = 8'b10011001;
						stateR[4] = 8'b10011001;
						stateR[5] = 8'b10100101;
						stateR[6] = 8'b11000011;
						stateR[7] = 8'b11111111;
					
						stateG[0] = 8'b00000000;
						stateG[1] = 8'b00000000;
						stateG[2] = 8'b00000000;
						stateG[3] = 8'b00000000;
						stateG[4] = 8'b00000000;
						stateG[5] = 8'b00000000;
						stateG[6] = 8'b00000000;
						stateG[7] = 8'b00000000;

						stateB[0] = 8'b00000000;
						stateB[1] = 8'b00000000;
						stateB[2] = 8'b00000000;
						stateB[3] = 8'b00000000;
						stateB[4] = 8'b00000000;
						stateB[5] = 8'b00000000;
						stateB[6] = 8'b00000000;
						stateB[7] = 8'b00000000;

						background=0;
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
						con=0;
						hp=0;
						{a,b,c,d,e,f,g}<= 7'b0000001;
						win<=8'b00000000;
					end
				
					else//血量減一並重製板子和球
					begin
					
					  hp <= hp -1;
					  for (i=0;i<8;i=i+1)
					  begin//背景形狀+顏色
							
							state[i][7]=0;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=0;
							state[i][6] = 0;
							stateR[i][6] = 0;
							stateG[i][6] = 0;
							stateB[i][6] = 0;
							
						 if (i>=3 & i<=5)
						 begin//
							state[i][7]=1;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=1;
						 end
						 if (i==4)
						 begin
							state[i][6] = 1;
							stateR[i][6] = 1;
							stateG[i][6] = 1;
							stateB[i][6] = 1;
						 end
					   end
					  
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
					end
				end
				else//一直往下
				begin
					if(state[ball_x][ball_y+1] == 1)
					begin
						state[ball_x][ball_y+1] = 0;
						stateR[ball_x][ball_y+1] = 0;
						stateG[ball_x][ball_y+1] = 0;
						stateB[ball_x][ball_y+1] = 0;
						con=con+1;
						ball_y = ball_y - 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
						go_mode=11;
					end
					else
					begin
						ball_y = ball_y + 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
					end
				end
			end
		end
		22:      //左下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_y==7)//掉下去
				begin
					if (hp == 0)//血量用完
					begin
						state[0] = 8'b11111111;
						state[1] = 8'b11000011;
						state[2] = 8'b10100101;
						state[3] = 8'b10011001;
						state[4] = 8'b10011001;
						state[5] = 8'b10100101;
						state[6] = 8'b11000011;
						state[7] = 8'b11111111;
							
						stateR[0] = 8'b11111111;
						stateR[1] = 8'b11000011;
						stateR[2] = 8'b10100101;
						stateR[3] = 8'b10011001;
						stateR[4] = 8'b10011001;
						stateR[5] = 8'b10100101;
						stateR[6] = 8'b11000011;
						stateR[7] = 8'b11111111;
					
						stateG[0] = 8'b00000000;
						stateG[1] = 8'b00000000;
						stateG[2] = 8'b00000000;
						stateG[3] = 8'b00000000;
						stateG[4] = 8'b00000000;
						stateG[5] = 8'b00000000;
						stateG[6] = 8'b00000000;
						stateG[7] = 8'b00000000;

						stateB[0] = 8'b00000000;
						stateB[1] = 8'b00000000;
						stateB[2] = 8'b00000000;
						stateB[3] = 8'b00000000;
						stateB[4] = 8'b00000000;
						stateB[5] = 8'b00000000;
						stateB[6] = 8'b00000000;
						stateB[7] = 8'b00000000;

						background=0;
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
						con=0;
						hp=0;
						{a,b,c,d,e,f,g}<= 7'b0000001;
						win<=8'b00000000;
					end
				
					else//血量減一並重製板子和球
					begin
					
					  hp <= hp -1;
					  for (i=0;i<8;i=i+1)
					  begin//背景形狀+顏色
							
							state[i][7]=0;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=0;
							state[i][6] = 0;
							stateR[i][6] = 0;
							stateG[i][6] = 0;
							stateB[i][6] = 0;
							
						 if (i>=3 & i<=5)
						 begin//
							state[i][7]=1;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=1;
						 end
						 if (i==4)
						 begin
							state[i][6] = 1;
							stateR[i][6] = 1;
							stateG[i][6] = 1;
							stateB[i][6] = 1;
						 end
					   end
					  
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
					end
				end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==panel_center||ball_x==panel_center+1||ball_x==panel_center-1))//打到板子
					begin
						if(ball_x==panel_center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=11;
						end
						else if(ball_x==panel_center-1)//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=12;
						end
						else//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=13;
						end
					end
					else
					begin//y+1
						ball_x=ball_x-1;
						ball_y=ball_y+1;				
					end
				end
				else if(ball_x==0)//左邊界
				begin
				   if(state[ball_x+1][ball_y+1]==1)
					begin
					   state[ball_x+1][ball_y+1]=0;
						stateR[ball_x+1][ball_y+1]=0;
						stateG[ball_x+1][ball_y+1]=0;
						stateB[ball_x+1][ball_y+1]=0;
						con=con+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=13;
					end
					else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=23;
					end
				end
				else if(state[ball_x-1][ball_y+1]==1)//打到磚塊
				begin
				   state[ball_x-1][ball_y+1]=0;
					stateR[ball_x-1][ball_y+1]=0;
					stateG[ball_x-1][ball_y+1]=0;
					stateB[ball_x-1][ball_y+1]=0;
					con=con+1;
					ball_x=ball_x+1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=13;
				end
				else//持續左下
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=22;
				end
			end
		end
		23:      //右下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_y==7)//掉下去
				begin
					if (hp == 0)//血量用完
					begin
						state[0] = 8'b11111111;
						state[1] = 8'b11000011;
						state[2] = 8'b10100101;
						state[3] = 8'b10011001;
						state[4] = 8'b10011001;
						state[5] = 8'b10100101;
						state[6] = 8'b11000011;
						state[7] = 8'b11111111;
							
						stateR[0] = 8'b11111111;
						stateR[1] = 8'b11000011;
						stateR[2] = 8'b10100101;
						stateR[3] = 8'b10011001;
						stateR[4] = 8'b10011001;
						stateR[5] = 8'b10100101;
						stateR[6] = 8'b11000011;
						stateR[7] = 8'b11111111;
					
						stateG[0] = 8'b00000000;
						stateG[1] = 8'b00000000;
						stateG[2] = 8'b00000000;
						stateG[3] = 8'b00000000;
						stateG[4] = 8'b00000000;
						stateG[5] = 8'b00000000;
						stateG[6] = 8'b00000000;
						stateG[7] = 8'b00000000;

						stateB[0] = 8'b00000000;
						stateB[1] = 8'b00000000;
						stateB[2] = 8'b00000000;
						stateB[3] = 8'b00000000;
						stateB[4] = 8'b00000000;
						stateB[5] = 8'b00000000;
						stateB[6] = 8'b00000000;
						stateB[7] = 8'b00000000;

						background=0;
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
						con=0;
						hp=0;
						{a,b,c,d,e,f,g}<= 7'b0000001;
						win<=8'b00000000;
					end
				
					else//血量減一並重製板子和球
					begin
					
					  hp <= hp -1;
					  for (i=0;i<8;i=i+1)
					  begin//背景形狀+顏色
							
							state[i][7]=0;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=0;
							state[i][6] = 0;
							stateR[i][6] = 0;
							stateG[i][6] = 0;
							stateB[i][6] = 0;
							
						 if (i>=3 & i<=5)
						 begin//
							state[i][7]=1;
							stateR[i][7]=0;
							stateG[i][7]=0;
							stateB[i][7]=1;
						 end
						 if (i==4)
						 begin
							state[i][6] = 1;
							stateR[i][6] = 1;
							stateG[i][6] = 1;
							stateB[i][6] = 1;
						 end
					   end
					  
						panel_center = 4;
						alreadyShoot = 0;
						ball_x = 4;
						ball_y = 6;
						go_mode = 11;
					end
				end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==panel_center||ball_x==panel_center+1||ball_x==panel_center-1))//打到板子
					begin
						if(ball_x==panel_center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=11;
						end
						else if(ball_x==panel_center-1)//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=12;
						end
						else//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							go_mode=13;
						end
					end
					else
					begin//y+1
						ball_x=ball_x+1;
						ball_y=ball_y+1;
					end
				end
				else if(ball_x==7)//右邊界
				begin
				   if(state[ball_x-1][ball_y+1]==1)
					begin
					   state[ball_x-1][ball_y+1]=0;
						stateR[ball_x-1][ball_y+1]=0;
						stateG[ball_x-1][ball_y+1]=0;
						stateB[ball_x-1][ball_y+1]=0;
						con=con+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=12;
					end
					else
					begin
						ball_x=ball_x-1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						go_mode=22;
					end
				end
				else if(state[ball_x+1][ball_y+1]==1)//打到磚塊
				begin
				   state[ball_x+1][ball_y+1]=0;
					stateR[ball_x+1][ball_y+1]=0;
					stateG[ball_x+1][ball_y+1]=0;
					stateB[ball_x+1][ball_y+1]=0;
					con=con+1;
					ball_x=ball_x-1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=12;//左上
				end
				else//持續右下
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					go_mode=23;
				end
			end
		end	
		endcase//6
   end//begin alreadyShoot
  end
end

always @(posedge CLK_div)
begin
	whichCol = whichCol + 1;
end
assign EN=1;
assign lightR = ~stateR[whichCol];
assign lightG = ~stateG[whichCol];
assign lightB = ~stateB[whichCol];

endmodule

//助教辛苦了看完這冗長的扣的，謝謝你們一年來的照顧：）祝你們越來越年輕美麗<3

