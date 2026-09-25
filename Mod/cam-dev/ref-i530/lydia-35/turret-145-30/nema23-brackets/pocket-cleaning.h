0  BEGIN PGM pocket-cleaning MM 
1  BLK FORM 0.1 Z  X-60  Y-60  Z-10
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour15 (3)
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X-23.15  Y-31.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F1350
20 L  Z-10.6
21 CC  X-21.75  Z-10.6
22 CP IPA-90 DR- F4051
23 L  X-20.35  Z-12
24 CC  X-20.35  Y-30
25 CP IPA+90 DR+
26 CC  X-30  Y-30
27 CP IPA+360 DR+
28 CC  X-20.35  Y-30
29 CP IPA+90 DR+
30 L  X-21.75  Y-28.6
31 CC  X-21.75  Z-10.6
32 CP IPA+90 DR+
33 L  X-23.15  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM pocket-cleaning MM 
