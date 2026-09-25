0  BEGIN PGM bt-inset-4 MM 
1  BLK FORM 0.1 Z  X+0  Y-99  Z-89
2  BLK FORM 0.2  X+103  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-3 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour4 (2)
9  M5
10 TOOL CALL 27 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+79.8  Y-50.9 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F1068
20 L  Z-1.6
21 CC  X+81.2  Z-1.6
22 CP IPA-90 DR- F3203
23 L  X+82.6  Z-3
24 CC  X+82.6  Y-49.5
25 CP IPA+90 DR+
26 CC  X+52  Y-49.5
27 CP IPA+360 DR+
28 CC  X+82.6  Y-49.5
29 CP IPA+90 DR+
30 L  X+81.2  Y-48.1
31 CC  X+81.2  Z-1.6
32 CP IPA+90 DR+
33 L  X+79.8  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM bt-inset-4 MM 
