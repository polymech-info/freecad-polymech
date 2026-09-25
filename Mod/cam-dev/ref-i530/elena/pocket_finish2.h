0  BEGIN PGM pocket_finish2 MM 
1  BLK FORM 0.1 Z  X+0  Y-70  Z-20
2  BLK FORM 0.2  X+142  Y+0  Z+0
3  ;-------------------------------------
4  ;Machine
5  ;  vendor: Autodesk
6  ;  model: Generic 3-axis
7  ;  description: This machine has YX axis on the Table and Z axis on the~
 Head
8  ;-------------------------------------
9  ;
10 ;-------------------------------------
11 ;Tools
12 ;  #4 D=12 - ZMIN=-21.9 - ZMAX=+15 - flat end mill
13 ;-------------------------------------
14 ;
15 * - 2D Contour3
16 M5
17 TOOL CALL 4 Z S8085
18 L M140 MB MAX
19 M3
20 L  X+54  Y-29.3 R0 FMAX
21 L  Z+15 R0 FMAX
22 M8
23 CYCL DEF 32.0 TOLERANCE
24 CYCL DEF 32.1
25 FN 0: Q52 =+3203 ; Finish
26 FN 0: Q53 =+3203 ; Entry
27 FN 0: Q54 =+3203 ; Exit
28 FN 0: Q58 =+1068 ; Plunge
29 L  Z+5 FMAX
30 L  Z-20.7 FQ58
31 CC  X+52.8  Z-20.7
32 CP IPA+90 DR+ FQ53
33 L  X+51.6  Z-21.9
34 CC  X+51.6  Y-30.5
35 CP IPA+90 DR+
36 CC  X+56.1  Y-30.5
37 CP IPA+360 DR+ FQ52
38 CC  X+56.7  Y-30.5
39 CP IPA+180 DR+
40 CC  X+56.1  Y-30.5
41 CP IPA+360 DR+
42 CC  X+61.8  Y-30.5
43 CP IPA+90 DR+ FQ54
44 L  X+60.6  Y-29.3
45 CC  X+60.6  Z-20.7
46 CP IPA+90 DR+
47 L  X+59.4  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM pocket_finish2 MM 
