0  BEGIN PGM shredder_sloting MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+500  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-17 - ZMAX=+10 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 3 Z S1940
11 L M140 MB MAX
12 M3
13 L  X+83  Y-56 R0 FMAX
14 L  Z+10 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 FN 0: Q52 =+202 ; Finish
18 FN 0: Q56 =+50 ; Reduced
19 FN 0: Q58 =+67 ; Plunge
20 L  Z+5 FMAX
21 L  Z-17 FQ58
22 L  Y-170.5 FQ52
23 L  Y-172.5 FQ56
24 L  X+282 FQ52
25 L  X+284 FQ56
26 L  Y-55.5 FQ52
27 L  Y-53.5 FQ56
28 L  X+85 FQ52
29 L  X+83 FQ56
30 L  Y-56 FQ52
31 L  Z+10 FMAX
32 M5
33 L M140 MB MAX
34 M30
35 END PGM shredder_sloting MM 
