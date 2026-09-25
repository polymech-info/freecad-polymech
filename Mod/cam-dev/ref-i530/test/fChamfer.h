0  BEGIN PGM fChamfer MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+350  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #11 D=5 TAPER=45deg - ZMIN=-1 - ZMAX=+15 - chamfer mill
6  ;-------------------------------------
7  ;
8  * - 2D Chamfer1
9  M5
10 TOOL CALL 11 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+347  Y-197.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 FN 0: Q52 =+1000 ; Finish
18 FN 0: Q53 =+1000 ; Entry
19 FN 0: Q54 =+1000 ; Exit
20 FN 0: Q58 =+333 ; Plunge
21 L  Z+5 FMAX
22 L  Z-1 FQ58
23 L  Y-197 FQ53
24 L  X+2 FQ52
25 CC  X+2  Y-196
26 CP IPA-90 DR-
27 L  X+1  Y-3
28 CC  X+2  Y-3
29 CP IPA-90 DR-
30 L  X+347  Y-2
31 CC  X+347  Y-3
32 CP IPA-90 DR-
33 L  X+348  Y-196
34 CC  X+347  Y-196
35 CP IPA-90 DR-
36 L  X+347  Y-197.5 FQ54
37 L  Z+15 FMAX
38 M5
39 L M140 MB MAX
40 M30
41 END PGM fChamfer MM 
