0  BEGIN PGM side-contour MM 
1  BLK FORM 0.1 Z  X+0  Y-120  Z-30
2  BLK FORM 0.2  X+350  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-32 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (17)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-10.3  Y-121.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-30.6 F483
20 CC  X-8.9  Z-30.6
21 CP IPA-90 DR- F550
22 L  X-8.4  Z-32
23 CC  X-8.4  Y-120
24 CP IPA+90 DR+
25 L  X-7  Y+0
26 L  Z+15 FMAX
27 M9
28 M5
29 L M140 MB MAX
30 M30
31 END PGM side-contour MM 
