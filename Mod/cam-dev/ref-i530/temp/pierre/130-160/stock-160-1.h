0  BEGIN PGM stock-160-1 MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z+0
2  BLK FORM 0.2  X+650  Y+0  Z+160
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+162 - ZMAX=+180 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (3)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+708.01  Y-69 R0 FMAX
14 L  Z+180 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+170 FMAX
19 CC  X+700.01  Z+170
20 CP IPA+90 DR+ F1000
21 L  X-50.01  Z+162
22 CC  X-50.01  Y-53.68
23 CP IPA-180 DR-
24 L  X+700.01  Y-38.36
25 CC  X+700.01  Z+170
26 CP IPA-90 DR-
27 L  X+708.01  Z+180 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM stock-160-1 MM 
