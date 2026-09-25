0  BEGIN PGM contour-685-130 MM 
1  BLK FORM 0.1 Z  X+0  Y-160  Z-30
2  BLK FORM 0.2  X+685  Y+490  Z+10
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13 - ZMIN=-29.5 - ZMAX=+25 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour3
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X-1.3  Y+10.4 R0 FMAX
14 L  Z+25 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+15 FMAX
19 L  Z-28.2 F1069
20 CC  Y+9.1  Z-28.2
21 CP IPA-90 DR- F3206
22 L  Y+7.8  Z-29.5
23 CC  X+0  Y+7.8
24 CP IPA+90 DR+
25 L  X+685  Y+6.5
26 CC  X+685  Y+7.8
27 CP IPA+90 DR+
28 L  X+686.3  Y+9.1
29 CC  Y+9.1  Z-28.2
30 CP IPA+90 DR+
31 L  Y+10.4  Z+25 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM contour-685-130 MM 
