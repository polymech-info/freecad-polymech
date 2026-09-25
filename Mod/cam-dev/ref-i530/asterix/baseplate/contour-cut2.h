0  BEGIN PGM contour-cut2 MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+460  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-17 - ZMAX=+10 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 12 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+204.093  Y-172.5 R0 FMAX
14 L  Z+10 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+551 ; Finish
19 FN 0: Q56 =+138 ; Reduced
20 FN 0: Q57 =+551 ; Ramping
21 FN 0: Q58 =+184 ; Plunge
22 L  Z+5 FMAX
23 L  Z+2.5 FQ58
24 L  X+264  Z+0.408 FQ57
25 L  Y-53.5  Z-3.748
26 L  X+63  Z-10.767
27 L  Y-172.5  Z-14.922
28 L  X+122.5  Z-17
29 L  X+262 FQ52
30 L  X+264 FQ56
31 L  Y-55.5 FQ52
32 L  Y-53.5 FQ56
33 L  X+65 FQ52
34 L  X+63 FQ56
35 L  Y-170.5 FQ52
36 L  Y-172.5 FQ56
37 L  X+122.5 FQ52
38 L  Z+10 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM contour-cut2 MM 
