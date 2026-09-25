0  BEGIN PGM stock-face-top-support-1 MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z+0
2  BLK FORM 0.2  X+650  Y+0  Z+100
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+102 - ZMAX=+120 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (7)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+701.069  Y-69 R0 FMAX
14 L  Z+120 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+110 FMAX
19 CC  X+693.069  Z+110
20 CP IPA+90 DR+ F1000
21 L  X+650  Z+102
22 L  X+0
23 CC  X+0  Y-53.68
24 CP IPA-180 DR-
25 L  X+650  Y-38.36
26 CC  X+650  Z+110
27 CP IPA-90 DR-
28 L  X+658  Z+120 FMAX
29 M9
30 M5
31 L M140 MB MAX
32 M30
33 END PGM stock-face-top-support-1 MM 
