0  BEGIN PGM m30-sink MM 
1  BLK FORM 0.1 Z  X-90  Y-40  Z-30
2  BLK FORM 0.2  X+90  Y+40  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-22 - ZMAX=+20 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (15)
9  M5
10 TOOL CALL 27 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+0  Y+21.975 R0 FMAX
14 L  Z+20 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+4 FMAX
19 L  Z-22 F184
20 CC  X+0  Y+0
21 CP IPA-386.073 DR- F551
22 L  X+9.658  Y+19.739  Z+20 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM m30-sink MM 
