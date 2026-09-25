0  BEGIN PGM countour_x MM 
1  BLK FORM 0.1 Z  X+0  Y-127.974  Z-25
2  BLK FORM 0.2  X+180.003  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #6 D=11 - ZMIN=-24.9 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 6 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-10  Y-129.074 R0 FMAX
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
24 L  Z-23.8 FQ58
25 CC  X-8.9  Z-23.8
26 CP IPA-90 DR- FQ53
27 L  X-7.8  Z-24.9
28 CC  X-7.8  Y-127.974
29 CP IPA+90 DR+
30 L  X-6.7  Y+0 FQ50
31 CC  X-7.8  Y+0
32 CP IPA+90 DR+ FQ54
33 L  X-8.9  Y+1.1
34 CC  X-8.9  Z-23.8
35 CP IPA+90 DR+
36 L  X-10  Z+5 FMAX
37 L  X-8.9  Y-129.074 FMAX
38 L  Z-23.8 FQ58
39 CC  X-7.8  Z-23.8
40 CP IPA-90 DR- FQ53
41 L  X-6.7  Z-24.9
42 CC  X-6.7  Y-127.974
43 CP IPA+90 DR+
44 L  X-5.6  Y+0 FQ52
45 CC  X-6.7  Y+0
46 CP IPA+90 DR+ FQ54
47 L  X-7.8  Y+1.1
48 CC  X-7.8  Z-23.8
49 CP IPA+90 DR+
50 L  X-8.9  Z+15 FMAX
51 M9
52 M5
53 L M140 MB MAX
54 M30
55 END PGM countour_x MM 
