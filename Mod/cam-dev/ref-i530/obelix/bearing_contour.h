0  BEGIN PGM bearing_contour MM 
1  BLK FORM 0.1 Z  X-90  Y-139  Z-12
2  BLK FORM 0.2  X+90  Y+54  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #4 D=12 - ZMIN=-14 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 4 Z S1617
11 L M140 MB MAX
12 M3
13 L  X+30.4  Y-1.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 FN 0: Q52 =+232 ; Finish
18 FN 0: Q53 =+232 ; Entry
19 FN 0: Q54 =+232 ; Exit
20 FN 0: Q58 =+77 ; Plunge
21 L  Z+5 FMAX
22 L  Z-12.8 FQ58
23 CC  X+31.6  Z-12.8
24 CP IPA-90 DR- FQ53
25 L  X+32.8  Z-14
26 CC  X+32.8  Y+0
27 CP IPA+90 DR+
28 CC  X+0  Y+0
29 CP IPA+360 DR+ FQ52
30 CC  X+32.8  Y+0
31 CP IPA+90 DR+ FQ54
32 L  X+31.6  Y+1.2
33 CC  X+31.6  Z-12.8
34 CP IPA+90 DR+
35 L  X+30.4  Z+15 FMAX
36 M5
37 L M140 MB MAX
38 M30
39 END PGM bearing_contour MM 
