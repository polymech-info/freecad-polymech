0  BEGIN PGM round-roughing-1 MM 
1  BLK FORM 0.1 Z  X+0  Y-207.8  Z-30
2  BLK FORM 0.2  X+478.9  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-30 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (2)
9  M5
10 TOOL CALL 27 Z S8000
11 L M140 MB MAX
12 M3
13 L  X+373.6  Y+31.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-28.6 F402
20 CC  Y+29.8  Z-28.6
21 CP IPA-90 DR- F1206
22 L  Y+9.4  Z-30
23 CC  X+375  Y+9.4
24 CP IPA+90 DR+
25 CC  X+375  Y-103.9
26 CP IPA-180 DR-
27 CC  X+375  Y-217.2
28 CP IPA+90 DR+
29 L  X+373.6  Y-237.6
30 CC  Y-237.6  Z-28.6
31 CP IPA-90 DR-
32 L  Y-239  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM round-roughing-1 MM 
