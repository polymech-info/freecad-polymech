0  BEGIN PGM bottom-register MM 
1  BLK FORM 0.1 Z  X+0  Y-99  Z-98
2  BLK FORM 0.2  X+99  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #18 D=14 - ZMIN=-3 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour3
9  M5
10 TOOL CALL 18 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+77.3  Y-50.9 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-1.6 F1068
20 CC  X+78.7  Z-1.6
21 CP IPA-90 DR- F3203
22 L  X+80.1  Z-3
23 CC  X+80.1  Y-49.5
24 CP IPA+90 DR+
25 CC  X+49.5  Y-49.5
26 CP IPA+360 DR+
27 CC  X+80.1  Y-49.5
28 CP IPA+90 DR+
29 L  X+78.7  Y-48.1
30 CC  X+78.7  Z-1.6
31 CP IPA+90 DR+
32 L  X+77.3  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM bottom-register MM 
