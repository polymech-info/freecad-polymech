0  BEGIN PGM face-145-top MM 
1  BLK FORM 0.1 Z  X+0  Y-50  Z-146.8
2  BLK FORM 0.2  X+300  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1.85 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face2
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+352  Y-25 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.95 FMAX
19 CC  X+344  Z+7.95
20 CP IPA+90 DR+ F1000
21 L  X+300  Z-0.05
22 L  X+0
23 L  X-40
24 L  Z-0.95
25 L  X+0
26 L  X+300
27 L  X+340
28 L  Z-1.85
29 L  X+300
30 L  X+0
31 CC  X+0  Z+6.15
32 CP IPA+90 DR+
33 L  X-8  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM face-145-top MM 
