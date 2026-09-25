0  BEGIN PGM roughing MM 
1  BLK FORM 0.1 Z  X+0  Y-301  Z-25
2  BLK FORM 0.2  X+301  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #4 D=16 - ZMIN=-26 - ZMAX=+25 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 4 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-12.3  Y-302.1 R0 FMAX
14 L  Z+25 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+4047 ; Finish
19 FN 0: Q53 =+4047 ; Entry
20 FN 0: Q54 =+4047 ; Exit
21 FN 0: Q58 =+1349 ; Plunge
22 L  Z+5 FMAX
23 L  Z-24.4 FQ58
24 CC  X-10.7  Z-24.4
25 CP IPA-90 DR- FQ53
26 L  X-9.1  Z-26
27 CC  X-9.1  Y-300.5
28 CP IPA+90 DR+
29 L  X-7.5  Y-0.5 FQ52
30 CC  X-9.1  Y-0.5
31 CP IPA+90 DR+ FQ54
32 L  X-10.7  Y+1.1
33 CC  X-10.7  Z-24.4
34 CP IPA+90 DR+
35 L  X-12.3  Z+5 FMAX
36 L  X+313.3 FMAX
37 L  Z-24.4 FQ58
38 CC  X+311.7  Z-24.4
39 CP IPA+90 DR+ FQ53
40 L  X+310.1  Z-26
41 CC  X+310.1  Y-0.5
42 CP IPA+90 DR+
43 L  X+308.5  Y-300.5 FQ52
44 CC  X+310.1  Y-300.5
45 CP IPA+90 DR+ FQ54
46 L  X+311.7  Y-302.1
47 CC  X+311.7  Z-24.4
48 CP IPA-90 DR-
49 L  X+313.3  Z+25 FMAX
50 M9
51 M5
52 L M140 MB MAX
53 M30
54 END PGM roughing MM 
