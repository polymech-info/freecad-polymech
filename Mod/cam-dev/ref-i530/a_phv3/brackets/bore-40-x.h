0  BEGIN PGM bore-40-x MM 
1  BLK FORM 0.1 Z  X-56.209  Y-90  Z-30
2  BLK FORM 0.2  X+56.209  Y+49.75  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13.87 - ZMIN=-13.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour14 (3)
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+8.904  Y-1.387 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-13.5 F333
20 L  X+11.678 F1000
21 CC  X+11.678  Y+0
22 CP IPA+90 DR+
23 CC  X+0  Y+0
24 CP IPA+360 DR+
25 CC  X+11.678  Y+0
26 CP IPA+90 DR+
27 L  X+8.904  Y+1.387
28 L  Z+15 FMAX
29 M9
30 M5
31 L M140 MB MAX
32 M30
33 END PGM bore-40-x MM 
