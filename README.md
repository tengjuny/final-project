# final-project
Authors:112321006 112321066 112321069
### Input/Output unit:<br>
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

#### 功能說明:
藍色貪吃蛇要去吃地圖上的紅色蘋果，吃到紅色蘋果加一分，吃到綠色蘋果扣一分<br>
貪吃蛇藉由按下 4 bits SW 來控制貪吃蛇的下一步行走方向<br>
碰到邊界則遊戲結束，在 8 x 8 LED 矩陣顯示叉叉<br>
負分則遊戲結束<br>

#### 程式模組說明:
