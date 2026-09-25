0  BEGIN PGM keyway MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-30
2  BLK FORM 0.2  X+140  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=6 - ZMIN=-2.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket8
9  M5
10 TOOL CALL 3 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+93.175  Y-14 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+3.1 F185
20 CC  X+92.575  Z+3.1
21 CP IPA+88 DR+ F555
22 L  X+71  Z+1.746
23 L  Y-16  Z+1.676
24 L  X+130  Z-0.384
25 L  Y-14  Z-0.454
26 L  X+71.415  Z-2.5
27 L  X+71 F139
28 L  Y-14.8 F555
29 L  Y-16 F139
30 L  X+128.8 F555
31 L  X+130 F139
32 L  Y-15.2 F555
33 L  Y-14 F139
34 L  X+71.415 F555
35 CC  X+71.415  Z-1.9
36 CP IPA+43.762 DR+
37 CC  Y-13.585  Z-1.9
38 CP IPA-46.238 DR-
39 L  X+71  Y-14.185  Z+15 FMAX
40 M9
41 M5
42 L M140 MB MAX
43 M30
44 END PGM keyway MM 
