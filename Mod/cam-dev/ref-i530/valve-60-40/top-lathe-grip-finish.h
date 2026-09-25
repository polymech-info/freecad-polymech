0  BEGIN PGM top-lathe-grip-finish MM 
1  BLK FORM 0.1 Z  X+0  Y-50  Z-40
2  BLK FORM 0.2  X+60  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-14 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour3
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-2.8  Y-26.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-12.4 F183
20 CC  X-1.2  Z-12.4
21 CP IPA-90 DR- F550
22 L  X+0.4  Z-14
23 CC  X+0.4  Y-25
24 CP IPA+90 DR+
25 CC  X+30  Y-25
26 CP IPA-360 DR-
27 CC  X+0.4  Y-25
28 CP IPA+90 DR+
29 L  X-1.2  Y-23.4
30 CC  X-1.2  Z-12.4
31 CP IPA+90 DR+
32 L  X-2.8  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM top-lathe-grip-finish MM 
