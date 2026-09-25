0  BEGIN PGM contour-648-17 MM 
1  BLK FORM 0.1 Z  X-294  Y-364  Z-15
2  BLK FORM 0.2  X+354  Y+284  Z+20
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-17 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-301  Y-41.084 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+10 FMAX
19 L  Z-17 F1333
20 L  Y-39.684 F1000
21 L  Y+284
22 CC  X-294  Y+284
23 CP IPA-90 DR-
24 L  X+354  Y+291
25 CC  X+354  Y+284
26 CP IPA-90 DR-
27 L  X+361  Y-39.684
28 L  Y-41.084
29 L  Z+60 FMAX
30 M9
31 M5
32 L M140 MB MAX
33 M30
34 END PGM contour-648-17 MM 
