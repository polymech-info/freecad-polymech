0  BEGIN PGM contour_finish MM 
1  BLK FORM 0.1 Z  X-80  Y-80  Z-24.7
2  BLK FORM 0.2  X+80  Y+80  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #4 D=12 - ZMIN=-24.7 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour - Finish
9  M5
10 TOOL CALL 4 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-1.2  Y+88.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+632 ; Finish
19 FN 0: Q53 =+632 ; Entry
20 FN 0: Q54 =+632 ; Exit
21 FN 0: Q58 =+211 ; Plunge
22 L  Z+6 FMAX
23 L  Z-23.5 FQ58
24 CC  Y+87.4  Z-23.5
25 CP IPA-90 DR- FQ53
26 L  Y+86.2  Z-24.7
27 CC  X+0  Y+86.2
28 CP IPA+90 DR+
29 CC  X+0  Y+0
30 CP IPA-360 DR- FQ52
31 CC  X+0  Y+86.2
32 CP IPA+90 DR+ FQ54
33 L  X+1.2  Y+87.4
34 CC  Y+87.4  Z-23.5
35 CP IPA+90 DR+
36 L  Y+88.6  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM contour_finish MM 
