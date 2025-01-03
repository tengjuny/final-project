module snake(
	output [7:0] data_r, data_g, data_b,
	output reg[3:0] comm,
	input [3:0] direction,
	output reg [6:0] d7_1,
	output reg [1:0] COMM_CLK,
	input clk,clear);
	reg [7:0] status [7:0];
	reg [5:0] i;
	reg [7:0] apple [7:0];
	reg [7:0] greenapple [7:0];
	reg [1:0] moveway;
	reg [5:0] body;
	reg [3:0] bcd_10, bcd_1;
	reg [6:0] seg1, seg2;

	integer snakex [63:0];
	integer snakey [63:0];
	integer applex;
	integer appley;
	integer applex2;
	integer appley2;
	integer greenapplex;
	integer greenappley;
	integer greenapplex2;
	integer greenappley2;
	integer randomseedx = 1;
	integer randomseedy = 1;
	integer randomseedx2 = 1;
	integer randomseedy2 = 1;
	//byte count1;

	reg [3:0] A_count;
	reg [3:0] score;
	reg [35:0] speed;

	initial
		begin
			body <= 2'b11;
			i <= 1'b0;
			score <= 1'b0;
			speed <= 8'b11111111;
			snakex[2] = 2;
			snakex[1] = 1;
			snakex[0] = 0;
			snakey[3] = 0;
			snakey[2] = 0;
			snakey[1] = 0;
			snakey[0] = 0;
			moveway = 2'b11; // left = 00,down = 01,up = 10,right = 11
			COMM_CLK = 2'b10;
			data_r = 8'b11111111;
			data_g = 8'b11111111;
			data_b = 8'b11111111;
			status[0] = 8'b00000000;
			status[1] = 8'b00000000;
			status[2] = 8'b00000000;
			status[3] = 8'b00000000;
			status[4] = 8'b00000000;
			status[5] = 8'b00000000;
			status[6] = 8'b00000000;
			status[7] = 8'b00000000;
		end
	bit [2:0] cnt;

	divfreq DIV01(clk,clk_div);
	segment7 S0(score, A0,B0,C0,D0,E0,F0,G0);
	segment7 S1(bcd_10, A1,B1,C1,D1,E1,F1,G1);
	divfreq_mv DIV02(clk/*, speed*/, clk_mv);
	// Frame refresh
	always@(posedge clk_div) 
		begin
			if(cnt >= 7)
				cnt = 0;
			else
				cnt = cnt + 1;
			comm = {1'b1,cnt};
 			
			//if(score > 3'b101 ) begin data_g = status[cnt]; end
			//else begin ; end
			data_b = status[cnt];
			data_r = apple[cnt];
			data_g = greenapple[cnt];
		end
	// 7段顯示器的視覺暫留
	always@(posedge clk_div)
		begin
			seg1[0] = A0;seg1[1] = B0;seg1[2] = C0;
			seg1[3] = D0;seg1[4] = E0;seg1[5] = F0;
			seg1[6] = G0;
			seg2[0] = A1;seg2[1] = B1;seg2[2] = C1;
			seg2[3] = D1;seg2[4] = E1;seg2[5] = F1;
			seg2[6] = G1;
			if(COMM_CLK == 2'b01)
				begin
					d7_1 <= seg1;
					COMM_CLK[1] <= 1'b1;
					COMM_CLK[0] <= 1'b0;
					//count1 <= 1'b1;
				end
			else if(COMM_CLK == 2'b10)
				begin
					d7_1 <= seg2;
					COMM_CLK[1] <= 1'b0;
					COMM_CLK[0] <= 1'b1;
					//count1 <= 1'b0;
				end
		end
	// game logic
	always@(posedge clk_mv)
		begin
			if(clear == 1)
				begin
					bcd_10 = 3'b0;
					score = 4'b0;
					body <= 2'b11;
					speed = 100000000;
					snakex[2] = 2;
					snakex[1] = 1;
					snakex[0] = 0;
					snakey[2] = 0;
					snakey[1] = 0;
					snakey[0] = 0;
					moveway = 2'b11; //left = 00,up = 01,down = 10,right = 11
					status[0] = 8'b11111110;
					status[1] = 8'b11111110;
					status[2] = 8'b11111110;
					status[3] = 8'b11111111;
					status[4] = 8'b11111111;
					status[5] = 8'b11111111;
					status[6] = 8'b11111111;
					status[7] = 8'b11111111;
					greenapple[0] = 8'b11111111;
					greenapple[1] = 8'b11111111;
					greenapple[2] = 8'b11111111;
					greenapple[3] = 8'b11111111;
					greenapple[4] = 8'b11111111;
					greenapple[5] = 8'b11111111;
					greenapple[6] = 8'b11111111;
					greenapple[7] = 8'b11111111;
					apple[0] = 8'b11111111;
					apple[1] = 8'b11111111;
					apple[2] = 8'b11111111;
					apple[3] = 8'b11111111;
					apple[4] = 8'b11111111;
					apple[5] = 8'b11111111;
					apple[6] = 8'b11111111;
					apple[7] = 8'b11111111;
					// spawn random apple positions 
					apple[applex][appley] = 1'b1;
					greenapple[greenapplex][greenappley] = 1'b1;
					randomseedx = ((5*randomseedx) +107321003) % 17;
					randomseedy = ((3*randomseedy) +107321009) % 13;
					randomseedx2 = ((5*randomseedx2) +300123701) % 19;
					randomseedy2 = ((3*randomseedy2) +900123701) % 23;
					applex = randomseedx % 8;
					appley = randomseedy % 8;
					applex2 = randomseedx2 % 8;
					appley2 = randomseedy2 % 8;
					greenapplex = randomseedx % 9;
					greenappley = randomseedy % 9;
					greenapplex2 = randomseedx2 % 9;
					greenappley2 = randomseedy2 % 9;
					apple[applex][appley] = 1'b0;
					apple[applex2][appley2] = 1'b0;
					greenapple[greenapplex][greenappley] = 1'b0;
					greenapple[greenapplex2][greenappley2] = 1'b0;
				end
	else
				begin	
					// Handle score carry out
					if(score >= 9)
						begin
							score <= 0;
							bcd_10 <= bcd_10 + 1;
						end
					if(bcd_10 >= 9) bcd_10 <= 0;
					// regenerate apple when reach
					if(snakex[body-1] == applex && snakey[body - 1] == appley)
						begin
							apple[applex][appley] = 1'b1;	
							randomseedx = ((5*randomseedx) +3) % 16;
							randomseedy = (randomseedy * 107321009) %13;
							applex = randomseedx % 8;
							appley = randomseedy % 8;
							apple[applex][appley] = 1'b0;
							score <= score + 1'b1;
							//score <= score + 2'b10;
						end
						
					if(snakex[body-1] == greenapplex && snakey[body - 1] == greenappley)
						begin
							greenapple[greenapplex][greenappley] = 1'b1;	
							randomseedx = ((5*randomseedx) +3) % 16;
							randomseedy = (randomseedy * 107321009) %13;
							greenapplex = randomseedx % 9;
							greenappley = randomseedy % 9;
							greenapple[greenapplex][greenappley] = 1'b0;
							if (score > 0) begin
									score <= score - 1'b1;
							end
						end
					
						
						// regenerate apple2 when reach
						if(snakex[body-1] == applex2 && snakey[body - 1] == appley2)
							begin
								apple[applex2][appley2] = 1'b1;	
								randomseedx2 = ((5*randomseedx2) +300123701) % 19;
								randomseedy2 = ((3*randomseedy2) +900123701) % 23;
								applex2 = randomseedx2 % 8;
								appley2 = randomseedy2 % 8;
								apple[applex2][appley2] = 1'b0;
								score <= score + 1'b1;
							end
							
							if(snakex[body-1] == greenapplex2 && snakey[body - 1] == greenappley2)
							begin	
								greenapple[applex2][appley2] = 1'b1;
								randomseedx2 = ((5*randomseedx2) +300123701) % 19;
								randomseedy2 = ((3*randomseedy2) +900123701) % 23;
								greenapplex = randomseedx % 9;
								greenappley = randomseedy % 9;
								greenapple[greenapplex2][greenappley2] = 1'b0;
								//score <= score - 1'b1;
								if (score > 0) begin
									score <= score - 1'b1;
								end
							end
					//if((score+1) % 5 == 0)
						//speed <= speed / 3'b100;
					// store direction
					if(direction[3] && moveway != 2'b00) 
						moveway = 2'b11;
					else if(direction[0] && moveway != 2'b11)
							moveway = 2'b00;
					else if(direction[1] && moveway != 2'b10)
							moveway = 2'b01;
					else if(direction[2] && moveway != 2'b01)
							moveway = 2'b10;
					// control move forward
					if(moveway == 2'b11) // right
						begin
							status[snakex[0]][snakey[0]] = 1'b1;
							for(i=0; i+1 < body;i++)
								begin
									snakex[i] = snakex[i+1];
									snakey[i] = snakey[i+1];
								end
							snakex[body-1] = snakex[body-1] + 1;						
						end
					else if(moveway == 2'b00) // left
						begin
							status[snakex[0]][snakey[0]] = 1'b1;
							for(i=0;i+1 < body;i++)
								begin
									snakex[i] = snakex[i+1];
									snakey[i] = snakey[i+1];
								end
							snakex[body-1] = snakex[body-1] - 1;
						end
					else if(moveway == 2'b01) // up
						begin
							status[snakex[0]][snakey[0]] = 1'b1;
							for(i=0;i+1 < body;i++)
								begin
									snakex[i] = snakex[i+1];
									snakey[i] = snakey[i+1];
								end
							snakey[body-1] = snakey[body-1] + 1;	
						end
					else if(moveway == 2'b10) // down
						begin
							status[snakex[0]][snakey[0]] = 1'b1;
							for(i=0;i+1 < body;i++)
								begin
									snakex[i] = snakex[i+1];
									snakey[i] = snakey[i+1];
								end
							snakey[body-1] = snakey[body-1] - 1;		
						end
					status[snakex[body-1]][snakey[body-1]] = 1'b0;

					// body collision game over
					for(i=0;i+1<body;i++)
						begin
							if (snakex[i] == snakex[body-1] && snakey[i] == snakey[body-1])
								begin
									status[0] = 8'b01111110;
									status[1] = 8'b10111101;
									status[2] = 8'b11011011;
									status[3] = 8'b11100111;
									status[4] = 8'b11100111;
									status[5] = 8'b11011011;
									status[6] = 8'b10111101;
									status[7] = 8'b01111110;
									greenapple[0] = 8'b11111111;
									greenapple[1] = 8'b11111111;
									greenapple[2] = 8'b11111111;
									greenapple[3] = 8'b11111111;
									greenapple[4] = 8'b11111111;
									greenapple[5] = 8'b11111111;
									greenapple[6] = 8'b11111111;
									greenapple[7] = 8'b11111111;
									apple[0] = 8'b11111111;
									apple[1] = 8'b11111111;
									apple[2] = 8'b11111111;
									apple[3] = 8'b11111111;
									apple[4] = 8'b11111111;
									apple[5] = 8'b11111111;
									apple[6] = 8'b11111111;
									apple[7] = 8'b11111111;
								end		
						end

					// border collision game over
					if(snakex[body-1] < 0 || snakex[body-1] > 7 || snakey[body-1] < 0 || snakey[body-1] > 7)
						begin
							status[0] = 8'b01111110;
							status[1] = 8'b10111101;
							status[2] = 8'b11011011;
							status[3] = 8'b11100111;
							status[4] = 8'b11100111;
							status[5] = 8'b11011011;
							status[6] = 8'b10111101;
							status[7] = 8'b01111110;
							greenapple[0] = 8'b11111111;
					      greenapple[1] = 8'b11111111;
					      greenapple[2] = 8'b11111111;
							greenapple[3] = 8'b11111111;
							greenapple[4] = 8'b11111111;
							greenapple[5] = 8'b11111111;
							greenapple[6] = 8'b11111111;
							greenapple[7] = 8'b11111111;
							apple[0] = 8'b11111111;
							apple[1] = 8'b11111111;
							apple[2] = 8'b11111111;
							apple[3] = 8'b11111111;
							apple[4] = 8'b11111111;
							apple[5] = 8'b11111111;
							apple[6] = 8'b11111111;
							apple[7] = 8'b11111111;
						end
					if(((score)/2) == 1)
						begin
							status[0] = 8'b11100000;
							status[1] = 8'b11101010;
							status[2] = 8'b11101010;
							status[3] = 8'b11101110;
							status[4] = 8'b11101100;
							status[5] = 8'b11101010;
							status[6] = 8'b11100110;
							status[7] = 8'b11101110;
							greenapple[0] = 8'b11111111;
							greenapple[1] = 8'b11111111;
							greenapple[2] = 8'b11111111;
							greenapple[3] = 8'b11111111;
							greenapple[4] = 8'b11111111;
							greenapple[5] = 8'b11111111;
							greenapple[6] = 8'b11111111;
							greenapple[7] = 8'b11111111;
							apple[0] = 8'b11111111;
							apple[1] = 8'b11111111;
							apple[2] = 8'b11111111;
							apple[3] = 8'b11111111;
							apple[4] = 8'b11111111;
							apple[5] = 8'b11111111;
							apple[6] = 8'b11111111;
							apple[7] = 8'b11111111;
						end
				end	
		end
endmodule

module divfreq(input clk, output reg clk_div);
	reg[24:0] count;
	always@(posedge clk)
		begin
			if(count > 10000)
				begin
					count <= 25'b0;
					clk_div <= ~clk_div;
				end
			else
				count <= count + 1'b1;
		end
endmodule

module divfreq_mv(input clk/*,input reg speed*/,output reg clk_mv);
	reg[35:0] count;
	always@(posedge clk)
		begin
			if(count > 15000000)
				begin
					count <= 35'b0;
					clk_mv <= ~clk_mv;
				end
			else
				count <= count + 1'b1;
		end
endmodule

//秒數轉7段顯示器
module segment7(input [3:0] a, output A,B,C,D,E,F,G);

	always@(a)
	  case(a)
		4'b0000:{A,B,C,D,E,F,G}=7'b0000001;
		4'b0001:{A,B,C,D,E,F,G}=7'b1001111;
		4'b0010:{A,B,C,D,E,F,G}=7'b0010010;
		4'b0011:{A,B,C,D,E,F,G}=7'b0000110;
		4'b0100:{A,B,C,D,E,F,G}=7'b1001100;
		4'b0101:{A,B,C,D,E,F,G}=7'b0100100;
		4'b0110:{A,B,C,D,E,F,G}=7'b0100000;
		4'b0111:{A,B,C,D,E,F,G}=7'b0001111;
		4'b1000:{A,B,C,D,E,F,G}=7'b0000000;
		4'b1001:{A,B,C,D,E,F,G}=7'b0000100;
		default:{A,B,C,D,E,F,G}=7'b1111111;
	  endcase
endmodule
