0  BEGIN PGM bore-52-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-120  Z-30
2  BLK FORM 0.2  X+85  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-3 - ZMAX=+45 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour12
9  M5
10 TOOL CALL 27 Z S2426
11 L M140 MB MAX
12 M3
13 L  X+59.3  Y-61.4 R0 FMAX
14 L  Z+45 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+6 FMAX
19 L  Z+2 F67
20 L  Z-1.6
21 CC  X+60.7  Z-1.6
22 CP IPA-90 DR- F202
23 L  X+62.1  Z-3
24 CC  X+62.1  Y-60
25 CP IPA+90 DR+
26 CC  X+42.5  Y-60
27 CP IPA+360 DR+
28 CC  X+62.1  Y-60
29 CP IPA+90 DR+
30 L  X+60.7  Y-58.6
31 CC  X+60.7  Z-1.6
32 CP IPA+90 DR+
33 L  X+59.3  Z+45 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM bore-52-contour MM 
