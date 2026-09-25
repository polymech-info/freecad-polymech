0  BEGIN PGM front_door_status_led MM 
1  BLK FORM 0.1 Z  X+0  Y-500  Z-500
2  BLK FORM 0.2  X+400  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=12 - ZMIN=-8 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket1 (2)
9  M5
10 TOOL CALL 12 Z S1617
11 L M140 MB MAX
12 M3
13 L  X+200.586  Y-48.8 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+182 ; Cutting
19 FN 0: Q53 =+182 ; Entry
20 FN 0: Q54 =+182 ; Exit
21 FN 0: Q58 =+61 ; Plunge
22 L  Z+5 FMAX
23 L  Z+2.5 FQ53
24 L  Z-6.8 FQ58
25 CC  Y-50  Z-6.8
26 CP IPA-90 DR-
27 CC  X+201.459  Y-50
28 CP IPA+180 DR+ FQ50
29 CC  X+200  Y-50
30 CP IPA+180 DR+
31 CC  X+201.459  Y-50
32 CP IPA+180 DR+
33 CC  X+200  Y-50
34 CP IPA+360 DR+
35 CC  X+204.05  Y-50
36 CP IPA+12.75  Z-7.97 DR+ FQ54
37 CC  X+204.05  Y-50
38 CP IPA+12.11  Z-7.881 DR+
39 L  X+205.086  Y-49.395  Z-7.81
40 L  X+205.024  Y-49.299  Z-7.738
41 L  X+204.966  Y-49.224  Z-7.643
42 L  X+204.902  Y-49.155  Z-7.548
43 L  X+204.85  Y-49.105  Z-7.434
44 L  X+204.795  Y-49.059  Z-7.321
45 L  X+204.723  Y-49.007  Z-7.067
46 L  X+204.698  Y-48.99  Z-6.8
47 L  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM front_door_status_led MM 
