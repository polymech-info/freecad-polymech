0  BEGIN PGM tb-tc-rad-roughing MM 
1  BLK FORM 0.1 Z  X+0  Y-207.8  Z-30
2  BLK FORM 0.2  X+478.9  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-30.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+373.4  Y+13.3 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-28.9 F333
20 CC  Y+11.7  Z-28.9
21 CP IPA-90 DR- F1000
22 L  Y+10.1  Z-30.5
23 CC  X+375  Y+10.1
24 CP IPA+90 DR+
25 CC  X+375  Y-103.9
26 CP IPA-180 DR-
27 CC  X+375  Y-217.9
28 CP IPA+90 DR+
29 L  X+373.4  Y-219.5
30 CC  Y-219.5  Z-28.9
31 CP IPA-90 DR-
32 L  Y-221.1  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM tb-tc-rad-roughing MM 
