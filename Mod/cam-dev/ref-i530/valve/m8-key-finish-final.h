0  BEGIN PGM m8-key-finish-final MM 
1  BLK FORM 0.1 Z  X-10  Y-10  Z-75
2  BLK FORM 0.2  X+10  Y+10  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-17 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (2)
9  M5
10 TOOL CALL 27 Z S1617
11 L M140 MB MAX
12 M3
13 L  X-16.875  Y-1.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-15.4 F77
20 CC  X-15.275  Z-15.4
21 CP IPA-90 DR- F232
22 L  X-13.675  Z-17
23 CC  X-13.675  Y+0
24 CP IPA+90 DR+
25 L  X-12.075  Y+3.775 F200
26 CC  X-3.775  Y+3.775
27 CP IPA-90 DR-
28 L  X+3.775  Y+12.075
29 CC  X+3.775  Y+3.775
30 CP IPA-90 DR-
31 L  X+12.075  Y-3.775
32 CC  X+3.775  Y-3.775
33 CP IPA-90 DR-
34 L  X-3.775  Y-12.075
35 CC  X-3.775  Y-3.775
36 CP IPA-90 DR-
37 L  X-12.075  Y+0
38 CC  X-13.675  Y+0
39 CP IPA+90 DR+ F232
40 L  X-15.275  Y+1.6
41 CC  X-15.275  Z-15.4
42 CP IPA+90 DR+
43 L  X-16.875  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM m8-key-finish-final MM 
