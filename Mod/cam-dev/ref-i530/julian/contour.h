0  BEGIN PGM contour MM 
1  BLK FORM 0.1 Z  X+0  Y-123.974  Z-25
2  BLK FORM 0.2  X+180.003  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #6 D=12 - ZMIN=-24.9 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 6 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-10.9  Y-125.174 R0 FMAX
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
24 L  Z-23.7 FQ58
25 CC  X-9.7  Z-23.7
26 CP IPA-90 DR- FQ53
27 L  X-8.5  Z-24.9
28 CC  X-8.5  Y-123.974
29 CP IPA+90 DR+
30 L  X-7.3  Y+0 FQ50
31 CC  X-8.5  Y+0
32 CP IPA+90 DR+ FQ54
33 L  X-9.7  Y+1.2
34 CC  X-9.7  Z-23.7
35 CP IPA+90 DR+
36 L  X-10.9  Z+5 FMAX
37 L  X-9.7  Y-125.174 FMAX
38 L  Z-23.7 FQ58
39 CC  X-8.5  Z-23.7
40 CP IPA-90 DR- FQ53
41 L  X-7.3  Z-24.9
42 CC  X-7.3  Y-123.974
43 CP IPA+90 DR+
44 L  X-6.1  Y+0 FQ52
45 CC  X-7.3  Y+0
46 CP IPA+90 DR+ FQ54
47 L  X-8.5  Y+1.2
48 CC  X-8.5  Z-23.7
49 CP IPA+90 DR+
50 L  X-9.7  Z+15 FMAX
51 M9
52 M5
53 L M140 MB MAX
54 M30
55 END PGM contour MM 
