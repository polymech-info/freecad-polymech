0  BEGIN PGM m65-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-86.3  Z-20
2  BLK FORM 0.2  X+86.3  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-21 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+64.35  Y-44.55 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F402
20 L  Z-19.6
21 CC  X+65.75  Z-19.6
22 CP IPA-90 DR- F1206
23 L  X+67.15  Z-21
24 CC  X+67.15  Y-43.15
25 CP IPA+90 DR+
26 CC  X+43.15  Y-43.15
27 CP IPA+360 DR+
28 CC  X+67.15  Y-43.15
29 CP IPA+90 DR+
30 L  X+65.75  Y-41.75
31 CC  X+65.75  Z-19.6
32 CP IPA+90 DR+
33 L  X+64.35  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM m65-contour MM 
