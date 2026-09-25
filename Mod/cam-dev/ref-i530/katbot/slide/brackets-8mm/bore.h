0  BEGIN PGM bore MM 
1  BLK FORM 0.1 Z  X+0  Y-68  Z-8
2  BLK FORM 0.2  X+210  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13 - ZMIN=-10.2 - ZMAX=+25 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (8)
9  M5
10 TOOL CALL 27 Z S1617
11 L M140 MB MAX
12 M3
13 L  X+65.464  Y-37.811 R0 FMAX
14 L  Z+25 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-10.2 F182
20 L  X+65.469  Y-37.825
21 L  X+65.483  Y-37.831
22 L  X+78.943
23 L  X+78.958  Y-37.825
24 L  X+78.964  Y-37.811
25 CC  X+65.464  Y-37.811
26 CP IPA+762.441 DR+
27 L  X+75.426  Y-28.7  Z+25 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM bore MM 
