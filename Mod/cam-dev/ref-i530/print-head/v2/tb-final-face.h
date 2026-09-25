0  BEGIN PGM tb-final-face MM 
1  BLK FORM 0.1 Z  X+0  Y-207.8  Z-30
2  BLK FORM 0.2  X+478.9  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.5 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+513.43  Y-195.07 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.5 FMAX
19 CC  X+505.43  Z+7.5
20 CP IPA+90 DR+ F1000
21 L  X-40.01  Z-0.5
22 CC  X-40.01  Y-168.985
23 CP IPA-180 DR-
24 L  X+518.91  Y-142.9
25 CC  X+518.91  Y-116.815
26 CP IPA+180 DR+
27 L  X-40.01  Y-90.73
28 CC  X-40.01  Y-64.645
29 CP IPA-180 DR-
30 L  X+515.768  Y-38.56
31 CC  X+515.768  Z+7.5
32 CP IPA-90 DR-
33 L  X+523.768  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM tb-final-face MM 
