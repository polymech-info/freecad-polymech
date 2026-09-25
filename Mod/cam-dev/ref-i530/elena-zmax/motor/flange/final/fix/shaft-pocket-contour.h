0  BEGIN PGM shaft-pocket-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-176  Z-30
2  BLK FORM 0.2  X+218  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13.98 - ZMIN=-31.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+123.316  Y-89.398 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2 F333
20 L  Z-30.102
21 CC  X+124.714  Z-30.102
22 CP IPA-90 DR- F1000
23 L  X+126.112  Z-31.5
24 CC  X+126.112  Y-88
25 CP IPA+90 DR+
26 CC  X+109  Y-88
27 CP IPA+360 DR+
28 CC  X+126.112  Y-88
29 CP IPA+90 DR+
30 L  X+124.714  Y-86.602
31 CC  X+124.714  Z-30.102
32 CP IPA+90 DR+
33 L  X+123.316  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM shaft-pocket-contour MM 
