0  BEGIN PGM bore-62-20d MM 
1  BLK FORM 0.1 Z  X-80  Y-80  Z-23
2  BLK FORM 0.2  X+80  Y+80  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #36 D=22 - ZMIN=-25 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour14
9  M5
10 TOOL CALL 36 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+13.79  Y-2.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-22.8 F165
20 CC  X+15.99  Z-22.8
21 CP IPA-90 DR- F496
22 L  X+18.19  Z-25
23 CC  X+18.19  Y+0
24 CP IPA+90 DR+
25 CC  X+0  Y+0
26 CP IPA+360 DR+
27 CC  X+18.19  Y+0
28 CP IPA+90 DR+
29 L  X+15.99  Y+2.2
30 CC  X+15.99  Z-22.8
31 CP IPA+90 DR+
32 L  X+13.79  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM bore-62-20d MM 
