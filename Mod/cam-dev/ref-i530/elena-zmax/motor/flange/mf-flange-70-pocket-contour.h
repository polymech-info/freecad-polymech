0  BEGIN PGM mf-flange-70-pocket-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-176  Z-30
2  BLK FORM 0.2  X+218  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-8 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+42.6  Y-111.8 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2 F333
20 L  Z-6.6
21 CC  Y-113.2  Z-6.6
22 CP IPA-90 DR- F1000
23 L  Y-114.6  Z-8
24 CC  X+44  Y-114.6
25 CP IPA+90 DR+
26 L  X+202  Y-116
27 L  Y-60
28 L  X+16
29 L  Y-116
30 L  X+44
31 CC  X+44  Y-114.6
32 CP IPA+90 DR+
33 L  X+45.4  Y-113.2
34 CC  Y-113.2  Z-6.6
35 CP IPA+90 DR+
36 L  Y-111.8  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM mf-flange-70-pocket-contour MM 
