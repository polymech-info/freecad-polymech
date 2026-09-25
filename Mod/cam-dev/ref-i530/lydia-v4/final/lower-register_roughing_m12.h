0  BEGIN PGM lower-register_roughing_m12 MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-46
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #17 D=12 - ZMIN=-1.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 17 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+1.2  Y-58.6 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+495 ; Finish
19 FN 0: Q53 =+495 ; Entry
20 FN 0: Q54 =+495 ; Exit
21 FN 0: Q58 =+165 ; Plunge
22 L  Z+5 FMAX
23 L  Z-0.3 FQ58
24 CC  Y-57.4  Z-0.3
25 CP IPA+90 DR+ FQ53
26 L  Y-56.2  Z-1.5
27 CC  X+0  Y-56.2
28 CP IPA+90 DR+
29 CC  X+0  Y+0
30 CP IPA-360 DR- FQ52
31 CC  X+0  Y-56.2
32 CP IPA+90 DR+ FQ54
33 L  X-1.2  Y-57.4
34 CC  Y-57.4  Z-0.3
35 CP IPA-90 DR-
36 L  Y-58.6  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM lower-register_roughing_m12 MM 
