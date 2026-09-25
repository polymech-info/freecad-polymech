0  BEGIN PGM lower-register_cleaning_m14 MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-46
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #18 D=14 - ZMIN=-2 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (2)
9  M5
10 TOOL CALL 18 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+1.4  Y-59.7 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+632 ; Finish
19 FN 0: Q53 =+632 ; Entry
20 FN 0: Q54 =+632 ; Exit
21 FN 0: Q58 =+211 ; Plunge
22 L  Z+5 FMAX
23 L  Z-0.6 FQ58
24 CC  Y-58.3  Z-0.6
25 CP IPA+90 DR+ FQ53
26 L  Y-56.9  Z-2
27 CC  X+0  Y-56.9
28 CP IPA+90 DR+
29 CC  X+0  Y+0
30 CP IPA-360 DR- FQ52
31 CC  X+0  Y-56.9
32 CP IPA+90 DR+ FQ54
33 L  X-1.4  Y-58.3
34 CC  Y-58.3  Z-0.6
35 CP IPA-90 DR-
36 L  Y-59.7  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM lower-register_cleaning_m14 MM 
