0  BEGIN PGM face-189 MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z+0
2  BLK FORM 0.2  X+439  Y+0  Z+191
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+189 - ZMAX=+231 - face mill
6  ;-------------------------------------
7  ;
8  * - Face-Top (5)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+491  Y-15 R0 FMAX
14 L  Z+231 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+197 FMAX
19 CC  X+483  Z+197
20 CP IPA+90 DR+ F1000
21 L  X+479  Z+189
22 L  X-40
23 CC  X-40  Z+197
24 CP IPA+90 DR+
25 L  X-48  Z+231 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM face-189 MM 
