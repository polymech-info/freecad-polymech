0  BEGIN PGM m10_contour_shredder_cutout MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+810  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-17 - ZMAX=+10 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 3 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+64  Y-41 R0 FMAX
14 L  Z+10 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+551 ; Cutting
19 FN 0: Q51 =+551 ; Predrilling
20 FN 0: Q52 =+551 ; Finish
21 FN 0: Q56 =+138 ; Reduced
22 L  Z+5 FMAX
23 L  Z-17 FQ51
24 L  X+64.014  Y-40.994 FQ50
25 L  X+64.02  Y-40.98
26 L  Y-40.02
27 L  X+64.014  Y-40.006
28 L  X+64  Y-40
29 L  X+63 FQ56
30 L  Y-158 FQ52
31 L  Y-160 FQ56
32 L  X+202 FQ52
33 L  X+204 FQ56
34 L  Y-42 FQ52
35 L  Y-40 FQ56
36 L  X+64 FQ52
37 L  Z+10 FMAX
38 M9
39 M5
40 L M140 MB MAX
41 M30
42 END PGM m10_contour_shredder_cutout MM 
