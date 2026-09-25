0  BEGIN PGM nyl_inner_finish_6mm MM 
1  BLK FORM 0.1 Z  X-29.625  Y-29.625  Z-12
2  BLK FORM 0.2  X+29.625  Y+29.625  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #1 D=6 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket7
9  M5
10 TOOL CALL 1 Z S10000
11 L M140 MB MAX
12 M3
13 L  X+2.6  Y+0.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+1440 ; Cutting
19 FN 0: Q53 =+1440 ; Entry
20 FN 0: Q54 =+1440 ; Exit
21 FN 0: Q58 =+330 ; Plunge
22 L  Z+5 FMAX
23 L  Z+2.5 FQ53
24 L  Z-11.4 FQ58
25 CC  Y+0  Z-11.4
26 CP IPA-90 DR-
27 CC  X+2.85  Y+0
28 CP IPA+180 DR+ FQ50
29 CC  X+0  Y+0
30 CP IPA+180 DR+
31 CC  X+2.85  Y+0
32 CP IPA+180 DR+
33 CC  X+0  Y+0
34 CP IPA+180 DR+
35 CC  X+2.85  Y+0
36 CP IPA+180 DR+
37 CC  X+0  Y+0
38 CP IPA+360 DR+
39 L  X+14.493  Y+0.092  Z-11.985 FQ54
40 L  X+14.472  Y+0.182  Z-11.971
41 L  X+14.441  Y+0.26  Z-11.928
42 L  X+14.399  Y+0.333  Z-11.885
43 L  X+14.36  Y+0.386  Z-11.819
44 L  X+14.314  Y+0.434  Z-11.753
45 L  X+14.248  Y+0.488  Z-11.585
46 L  X+14.224  Y+0.505  Z-11.4
47 L  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM nyl_inner_finish_6mm MM 
