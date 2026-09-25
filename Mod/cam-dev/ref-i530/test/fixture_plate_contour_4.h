0  BEGIN PGM fixture_plate_contour_4 MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+350  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #4 D=12 - ZMIN=-17 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (2)
9  M5
10 TOOL CALL 4 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+349.2  Y-206.8 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+3203 ; Cutting
19 FN 0: Q52 =+3203 ; Finish
20 FN 0: Q53 =+3203 ; Entry
21 FN 0: Q54 =+3203 ; Exit
22 FN 0: Q58 =+1068 ; Plunge
23 L  Z+5 FMAX
24 L  Z+1 FQ58
25 L  Z-15.8
26 CC  Y-205.6  Z-15.8
27 CP IPA+90 DR+ FQ53
28 L  Y-204.4  Z-17
29 CC  X+348  Y-204.4
30 CP IPA+90 DR+
31 L  X+2  Y-203.2 FQ50
32 CC  X+2  Y-196
33 CP IPA-90 DR-
34 L  X-5.2  Y-3
35 CC  X+2  Y-3
36 CP IPA-90 DR-
37 L  X+348  Y+4.2
38 CC  X+348  Y-3
39 CP IPA-90 DR-
40 L  X+355.2  Y-196
41 CC  X+348  Y-196
42 CP IPA-90 DR-
43 CC  X+348  Y-202.225
44 CP IPA-67.38 DR-
45 CC  X+346.2  Y-202.975
46 CP IPA+67.38 DR+
47 L  X+2  Y-202 FQ52
48 CC  X+2  Y-196
49 CP IPA-90 DR-
50 L  X-4  Y-3
51 CC  X+2  Y-3
52 CP IPA-90 DR-
53 L  X+348  Y+3
54 CC  X+348  Y-3
55 CP IPA-90 DR-
56 L  X+354  Y-196
57 CC  X+348  Y-196
58 CP IPA-90 DR-
59 L  X+346.2  Y-202
60 CC  X+346.2  Y-203.2
61 CP IPA+90 DR+ FQ54
62 L  X+345  Y-204.4
63 CC  Y-204.4  Z-15.8
64 CP IPA-90 DR-
65 L  Y-205.6  Z+15 FMAX
66 M9
67 M5
68 L M140 MB MAX
69 M30
70 END PGM fixture_plate_contour_4 MM 
