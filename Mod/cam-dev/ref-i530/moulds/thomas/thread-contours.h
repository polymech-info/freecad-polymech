0  BEGIN PGM thread-contours MM 
1  BLK FORM 0.1 Z  X+0  Y-126  Z-30
2  BLK FORM 0.2  X+360  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-20 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (14)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+202  Y-63 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-20 F483
20 CC  X+180  Y-63
21 CP IPA-373.022 DR- F550
22 L  X+201.434  Y-67.957  Z+5 FMAX
23 L  X+203  Y-63 FMAX
24 L  Z-20 F483
25 CC  X+180  Y-63
26 CP IPA+372.456 DR+ F550
27 L  X+202.459  Y-58.039  Z+15 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM thread-contours MM 
