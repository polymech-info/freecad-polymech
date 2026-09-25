0  BEGIN PGM chaf2 MM 
1  BLK FORM 0.1 Z  X+0  Y-50  Z-25
2  BLK FORM 0.2  X+50  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #1 D=3 TAPER=60deg - ZMIN=-1.577 - ZMAX=+15 - chamfer mill
6  ;-------------------------------------
7  ;
8  * - 2D Chamfer1
9  M5
10 TOOL CALL 1 Z S9702
11 L M140 MB MAX
12 M3
13 L  X-2.082  Y-50 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+4051 ; Finish
19 FN 0: Q53 =+4051 ; Entry
20 FN 0: Q54 =+4051 ; Exit
21 FN 0: Q58 =+1350 ; Plunge
22 L  Z+5 FMAX
23 L  Z-1.577 FQ58
24 L  X-1.782 FQ53
25 L  Y+0 FQ52
26 L  X-2.082 FQ54
27 L  Z+15 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM chaf2 MM 
