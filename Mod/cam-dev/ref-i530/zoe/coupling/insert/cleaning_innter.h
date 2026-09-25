0  BEGIN PGM cleaning_innter MM 
1  BLK FORM 0.1 Z  X+0  Y-90  Z-24
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #1 D=2 - ZMIN=-6 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour6 (2)
9  M5
10 TOOL CALL 1 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+79.6  Y-44.8 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+4047 ; Cutting
19 FN 0: Q52 =+4047 ; Finish
20 FN 0: Q53 =+4047 ; Entry
21 FN 0: Q54 =+4047 ; Exit
22 FN 0: Q58 =+1349 ; Plunge
23 L  Z+5 FMAX
24 L  Z-5.8 FQ58
25 CC  X+79.4  Z-5.8
26 CP IPA+90 DR+ FQ53
27 L  X+79.2  Z-6
28 CC  X+79.2  Y-45
29 CP IPA+90 DR+
30 CC  X+60  Y-45
31 CP IPA-360 DR- FQ50
32 CC  X+78.592  Y-45
33 CP IPA-67.827 DR-
34 CC  X+78.905  Y-45.767
35 CP IPA+65.504 DR+
36 CC  X+60  Y-45
37 CP IPA-360 DR- FQ52
38 CC  X+78.685  Y-45.758
39 CP IPA+90.001 DR+ FQ54
40 L  X+78.876  Y-45.966
41 L  X+78.928  Y-45.968  Z-5.993
42 L  X+78.976  Y-45.97  Z-5.973
43 L  X+79.018  Y-45.972  Z-5.941
44 L  X+79.049  Y-45.973  Z-5.9
45 L  X+79.069  Y-45.974  Z-5.852
46 L  X+79.076  Z-5.8
47 L  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM cleaning_innter MM 
