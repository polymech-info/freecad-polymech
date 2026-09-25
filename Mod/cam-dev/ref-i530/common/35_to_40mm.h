0  BEGIN PGM 35_to_40mm MM 
1  BLK FORM 0.1 Z  X-50  Y-30  Z-4
2  BLK FORM 0.2  X+50  Y+30  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #6 D=12 - ZMIN=-6 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 6 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-9.45  Y+1.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+3203 ; Finish
19 FN 0: Q53 =+3203 ; Entry
20 FN 0: Q54 =+3203 ; Exit
21 FN 0: Q58 =+1068 ; Plunge
22 L  Z+5 FMAX
23 L  Z-4.8 FQ58
24 CC  X-10.65  Z-4.8
25 CP IPA+90 DR+ FQ53
26 L  X-11.85  Z-6
27 CC  X-11.85  Y+0
28 CP IPA+90 DR+
29 CC  X+0  Y+0
30 CP IPA+360 DR+ FQ52
31 CC  X+0.6  Y+0
32 CP IPA+180 DR+
33 CC  X+0  Y+0
34 CP IPA+360 DR+
35 CC  X+13.05  Y+0
36 CP IPA+90 DR+ FQ54
37 L  X+11.85  Y+1.2
38 CC  X+11.85  Z-4.8
39 CP IPA+90 DR+
40 L  X+10.65  Z+15 FMAX
41 M9
42 M5
43 L M140 MB MAX
44 M30
45 END PGM 35_to_40mm MM 
