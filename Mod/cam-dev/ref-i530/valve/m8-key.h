0  BEGIN PGM m8-key MM 
1  BLK FORM 0.1 Z  X-10  Y-10  Z-75
2  BLK FORM 0.2  X+10  Y+10  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-17 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 27 Z S1617
11 L M140 MB MAX
12 M3
13 L  X-1.6  Y+18.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-15.4 F61
20 CC  Y+16.9  Z-15.4
21 CP IPA-90 DR- F182
22 L  Y+15.3  Z-17
23 CC  X+0  Y+15.3
24 CP IPA+90 DR+
25 L  X+4.1  Y+13.7
26 CC  X+4.1  Y+4.1
27 CP IPA-90 DR-
28 L  X+13.7  Y-4.1
29 CC  X+4.1  Y-4.1
30 CP IPA-90 DR-
31 L  X-4.1  Y-13.7
32 CC  X-4.1  Y-4.1
33 CP IPA-90 DR-
34 L  X-13.7  Y+4.1
35 CC  X-4.1  Y+4.1
36 CP IPA-90 DR-
37 L  X+0  Y+13.7
38 CC  X+0  Y+12.4
39 CP IPA-67.38 DR-
40 CC  X+2.4  Y+13.4
41 CP IPA+67.38 DR+
42 L  X+4.1  Y+12.1 F1
43 CC  X+4.1  Y+4.1
44 CP IPA-90 DR-
45 L  X+12.1  Y-4.1
46 CC  X+4.1  Y-4.1
47 CP IPA-90 DR-
48 L  X-4.1  Y-12.1
49 CC  X-4.1  Y-4.1
50 CP IPA-90 DR-
51 L  X-12.1  Y+4.1
52 CC  X-4.1  Y+4.1
53 CP IPA-90 DR-
54 L  X+2.4  Y+12.1
55 CC  X+2.4  Y+13.7
56 CP IPA+90 DR+ F182
57 L  X+4  Y+15.3
58 CC  Y+15.3  Z-15.4
59 CP IPA+90 DR+
60 L  Y+16.9  Z+15 FMAX
61 M9
62 M5
63 L M140 MB MAX
64 M30
65 END PGM m8-key MM 
