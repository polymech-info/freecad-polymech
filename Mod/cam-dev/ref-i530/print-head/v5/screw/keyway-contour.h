0  BEGIN PGM keyway-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-30
2  BLK FORM 0.2  X+140  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=5.95 - ZMIN=-3.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 3 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+71.405  Y-14.24 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F185
20 L  Z-2.905
21 CC  Y-14.835  Z-2.905
22 CP IPA-90 DR- F555
23 L  Y-15.43  Z-3.5
24 CC  X+72  Y-15.43
25 CP IPA+90 DR+
26 L  X+130.025  Y-16.025
27 L  Y-13.975
28 L  X+70.975
29 L  Y-16.025
30 L  X+72
31 CC  X+72  Y-15.43
32 CP IPA+90 DR+
33 L  X+72.595  Y-14.835
34 CC  Y-14.835  Z-2.905
35 CP IPA+90 DR+
36 L  Y-14.24  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM keyway-contour MM 
