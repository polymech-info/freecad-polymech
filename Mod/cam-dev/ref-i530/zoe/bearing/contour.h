0  BEGIN PGM contour MM 
1  BLK FORM 0.1 Z  X-80  Y-51.5  Z-10
2  BLK FORM 0.2  X+80  Y+51.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #6 D=12 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 6 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+87.6  Y+1.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+495 ; Finish
19 FN 0: Q53 =+495 ; Entry
20 FN 0: Q54 =+495 ; Exit
21 FN 0: Q58 =+165 ; Plunge
22 L  Z+5 FMAX
23 L  Z-10.8 FQ58
24 CC  X+86.4  Z-10.8
25 CP IPA+90 DR+ FQ53
26 L  X+85.2  Z-12
27 CC  X+85.2  Y+0
28 CP IPA+90 DR+
29 CC  X+58.5  Y+0
30 CP IPA-65.241 DR- FQ52
31 L  X+20.94  Y-45.404
32 CC  X+0  Y+0
33 CP IPA-49.518 DR-
34 L  X-69.18  Y-23.156
35 CC  X-58.5  Y+0
36 CP IPA-130.482 DR-
37 L  X-20.94  Y+45.404
38 CC  X+0  Y+0
39 CP IPA-49.518 DR-
40 L  X+69.18  Y+23.156
41 CC  X+58.5  Y+0
42 CP IPA-65.241 DR-
43 CC  X+85.2  Y+0
44 CP IPA+90 DR+ FQ54
45 L  X+86.4  Y-1.2
46 CC  X+86.4  Z-10.8
47 CP IPA-90 DR-
48 L  X+87.6  Z+15 FMAX
49 M9
50 M5
51 L M140 MB MAX
52 M30
53 END PGM contour MM 
