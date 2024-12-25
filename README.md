# final-project
Authors:112321006 112321066 112321069
## Input/Output unit:<br>
* 8x8 LED 矩陣：
用來顯示貪吃蛇遊戲畫面<br>
藍色為貪吃蛇，紅色為蘋果<br>
圖為按下reset的初始畫面。<br>
用 4 bits SW 輸入上下左右<br>
 <img src=https://github.com/user-attachments/assets/b38c1d8e-6d1a-455c-853a-d9ae204d894c
width="200"/><br>
<img src=https://github.com/user-attachments/assets/31db5b58-748e-4c32-8d5a-ba9d06ae9668
width="200"/><br>

* 七段顯示器：用來顯示得分。<br>
 <img src=https://github.com/user-attachments/assets/9242f952-eb5f-4220-9344-1584309b6703
width="200"/><br>

### 功能說明:
最一開始隨機出現紅蘋果與綠蘋果的初始位置<br>
藍色貪吃蛇要去吃地圖上的紅色蘋果，吃到紅色蘋果加一分，吃到綠色蘋果扣一分<br>
貪吃蛇藉由按下 4 bits SW 來控制貪吃蛇的下一步行走方向<br>
碰到邊界則遊戲結束，在 8 x 8 LED 矩陣顯示叉叉<br>
負分則遊戲結束<br>

### 程式模組說明:

  * 輸入端口<br>
direction：蛇的移動方向，接到 4 bits SW (direction[3]=往右、direction[2]上、direction[1]下、direction[0]左)。<br>
clk：系統時鐘。<br>
clear：重置訊號，遊戲重新開始。<br>

  * 輸出端口<br>
 data_r, data_g, data_b：控制LED矩陣的RGB顯示資料。<br>
 comm：LED矩陣的掃描行控制訊號。<br>
 d7_1：連接七段顯示器的資料輸出。<br>
 COMM_CLK：七段顯示器的切換訊號(得分分數)。<br>
 
  * 顯示邏輯
    ##### 1.LED 矩陣掃描刷新 (always @(posedge clk_div))
    逐行掃描 LED 矩陣，刷新畫面。<br>
    根據分數 (score) 動態調整顯示顏色：分數到達兩分時遊戲結束，顯示 "EZ" ；蛇進入牆壁，遊戲失敗，顯示 "X" 。<br>
    ##### 2. 7段顯示器控制 (always @ (posedge clk_div))
    使用 segment7 模組將數字轉換為 7 段顯示器的控制訊號。<br>
    通過交替切換 COMM_CLK，實現 7 段顯示器的兩位數顯示。<br>
  * 遊戲邏輯(always @ (posedge clk_mv))
    ##### 1.分數計算與蘋果再生
     當蛇吃到紅色蘋果 (snakex[body-1] == applex && snakey[body-1] == appley) 時，分數增加並重新生成蘋果位置。<br>
     當蛇吃到綠色蘋果 (snakex[body-1] == greenapplex && snakey[body-1] == greenappley) 時，分數減少 (若分數為 0 則保持不變)。<br>
     ##### 2.速度調整<br>
      數每到達 5 的倍數時，移動速度加快 (speed = speed / 4)。<br>
     ##### 3.方向控制<br>
      根據 direction 信號改變蛇的移動方向，但不允許與當前方向相反。<br>
     ##### 4.蛇的移動
      根據當前方向 (moveway)，更新蛇頭的位置，並移動身體位置(left = 00,down = 01,up = 10,right = 11)。<br>
      使用 status 陣列記錄蛇的每個節點在 LED 矩陣中的位置。<br>
     ##### 5.碰撞檢測<br>
      邊界碰撞: 若蛇的頭超出矩陣範圍(蛇頭進入牆壁)，則顯示遊戲結束畫面叉叉。<br>
      身體碰撞: 若蛇的頭與身體的某個節點重疊，則顯示遊戲結束畫面叉叉。<br>
   * 遊戲結束<br>
      蛇碰撞邊界或身體後，將 status 設置為遊戲結束圖案，並停止更新。<br>
   * 遊戲主要流程<br>
      初始化 -> 刷新畫面 -> 接收方向控制 -> 更新蛇和蘋果位置 -> 碰撞檢測 -> 結束或繼續。<br>

 ### DEMO VIDEO
  https://youtu.be/y5ercWCx0NE
