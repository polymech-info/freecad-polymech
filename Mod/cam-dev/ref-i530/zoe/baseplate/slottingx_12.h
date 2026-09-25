0  BEGIN PGM slottingx_12 MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+810  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #6 D=12 - ZMIN=-17 - ZMAX=+10 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (2)
9  M5
10 TOOL CALL 6 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+64  Y-43.008 R0 FMAX
14 L  Z+10 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+550 ; Finish
19 FN 0: Q56 =+138 ; Reduced
20 FN 0: Q58 =+183 ; Plunge
21 L  Z+5 FMAX
22 L  Z-17 FQ58
23 L  Y-156.6 FQ52
24 L  Y-159 FQ56
25 L  X+200.6 FQ52
26 L  X+203 FQ56
27 L  Y-43.4 FQ52
28 L  Y-41 FQ56
29 L  X+66.4 FQ52
30 L  X+64 FQ56
31 L  Y-43.008 FQ52
32 L  Z+10 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM slottingx_12 MM 
