0  BEGIN PGM bt-lh-con MM 
1  BLK FORM 0.1 Z  X+0  Y-100  Z-89
2  BLK FORM 0.2  X+102  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-11 - ZMAX=+40 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour - Cleaning (2)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0.3  Y-51.4 R0 FMAX
14 L  Z+40 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-9.6 F165
20 CC  X+1.7  Z-9.6
21 CP IPA-90 DR- F495
22 L  X+3.1  Z-11
23 CC  X+3.1  Y-50
24 CP IPA+90 DR+
25 CC  X+51.5  Y-50
26 CP IPA-360 DR-
27 CC  X+3.1  Y-50
28 CP IPA+90 DR+
29 L  X+1.7  Y-48.6
30 CC  X+1.7  Z-9.6
31 CP IPA+90 DR+
32 L  X+0.3  Z+40 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM bt-lh-con MM 
