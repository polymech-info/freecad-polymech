0  BEGIN PGM bore-65 MM 
1  BLK FORM 0.1 Z  X-42.5  Y-60  Z-30
2  BLK FORM 0.2  X+42.5  Y+60  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-4 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - contour-laser
9  M5
10 TOOL CALL 27 Z S2426
11 L M140 MB MAX
12 M3
13 L  X-19.9  Y+1.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-2.6 F61
20 CC  X-21.3  Z-2.6
21 CP IPA+90 DR+ F182
22 L  X-22.7  Z-4
23 CC  X-22.7  Y+0
24 CP IPA+90 DR+
25 CC  X+0  Y+0
26 CP IPA+360 DR+
27 CC  X+0.7  Y+0
28 CP IPA+180 DR+
29 CC  X+0  Y+0
30 CP IPA+360 DR+
31 CC  X+24.1  Y+0
32 CP IPA+90 DR+
33 L  X+22.7  Y+1.4
34 CC  X+22.7  Z-2.6
35 CP IPA+90 DR+
36 L  X+21.3  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM bore-65 MM 
