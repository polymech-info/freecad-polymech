0  BEGIN PGM fBottom MM 
1  BLK FORM 0.1 Z  X+0  Y-139  Z-40
2  BLK FORM 0.2  X+38.6  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #4 D=12 - ZMIN=-34.8 - ZMAX=+10 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 4 Z S1617
11 L M140 MB MAX
12 M3
13 L  X+49.6  Y+1.2 R0 FMAX
14 L  Z+10 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+232 ; Cutting
19 FN 0: Q52 =+232 ; Finish
20 FN 0: Q53 =+232 ; Entry
21 FN 0: Q54 =+232 ; Exit
22 FN 0: Q58 =+77 ; Plunge
23 L  Z+5 FMAX
24 L  Z-33.6 FQ58
25 CC  X+48.4  Z-33.6
26 CP IPA+90 DR+ FQ53
27 L  X+47.2  Z-34.8
28 CC  X+47.2  Y+0
29 CP IPA+90 DR+
30 L  X+46  Y-139 FQ50
31 CC  X+38.6  Y-139
32 CP IPA-90 DR-
33 L  X+0  Y-146.4
34 CC  X+0  Y-139
35 CP IPA-90 DR-
36 L  X-7.4  Y+0
37 CC  X+0  Y+0
38 CP IPA-90 DR-
39 L  X+38.6  Y+7.4
40 CC  X+38.6  Y+0
41 CP IPA-90 DR-
42 CC  X+45.025  Y+0
43 CP IPA-67.38 DR-
44 CC  X+45.775  Y-1.8
45 CP IPA+67.38 DR+
46 L  X+44.8  Y-139 FQ52
47 CC  X+38.6  Y-139
48 CP IPA-90 DR-
49 L  X+0  Y-145.2
50 CC  X+0  Y-139
51 CP IPA-90 DR-
52 L  X-6.2  Y+0
53 CC  X+0  Y+0
54 CP IPA-90 DR-
55 L  X+38.6  Y+6.2
56 CC  X+38.6  Y+0
57 CP IPA-90 DR-
58 L  X+44.8  Y-1.8
59 CC  X+46  Y-1.8
60 CP IPA+90 DR+ FQ54
61 L  X+47.2  Y-3
62 CC  X+47.2  Z-33.6
63 CP IPA-90 DR-
64 L  X+48.4  Z+10 FMAX
65 M9
66 M5
67 L M140 MB MAX
68 M30
69 END PGM fBottom MM 
