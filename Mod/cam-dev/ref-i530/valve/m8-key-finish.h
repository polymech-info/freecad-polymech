0  BEGIN PGM m8-key-finish MM 
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
13 L  X-16.9  Y-1.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-15.4 F77
20 CC  X-15.3  Z-15.4
21 CP IPA-90 DR- F232
22 L  X-13.7  Z-17
23 CC  X-13.7  Y+0
24 CP IPA+90 DR+
25 L  X-12.1  Y+4.1 F1
26 CC  X-4.1  Y+4.1
27 CP IPA-90 DR-
28 L  X+4.1  Y+12.1
29 CC  X+4.1  Y+4.1
30 CP IPA-90 DR-
31 L  X+12.1  Y-4.1
32 CC  X+4.1  Y-4.1
33 CP IPA-90 DR-
34 L  X-4.1  Y-12.1
35 CC  X-4.1  Y-4.1
36 CP IPA-90 DR-
37 L  X-12.1  Y+0
38 CC  X-13.7  Y+0
39 CP IPA+90 DR+ F232
40 L  X-15.3  Y+1.6
41 CC  X-15.3  Z-15.4
42 CP IPA+90 DR+
43 L  X-16.9  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM m8-key-finish MM 
