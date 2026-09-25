0  BEGIN PGM chamfer-contours MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-17
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #15 D=12.45 TAPER=90deg - ZMIN=-0.5 - ZMAX=+15 - countersink
6  ;-------------------------------------
7  ;
8  * - 2D Chamfer1 (3)
9  M5
10 TOOL CALL 15 Z S1500
11 L M140 MB MAX
12 M3
13 L  X+17.555  Y+0 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-0.5 F633
20 L  X+18.8 F1000
21 CC  X+0  Y+0
22 CP IPA+390.476 DR+
23 L  X+15.13  Y+8.904
24 L  Z+5 FMAX
25 L  X+52.745  Y+0 FMAX
26 L  Z-0.5 F633
27 L  X+51.5 F1000
28 CC  X+0  Y+0
29 CP IPA-371.125 DR-
30 L  X+51.754  Y-10.178
31 L  Z+15 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM chamfer-contours MM 
