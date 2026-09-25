0  BEGIN PGM face-bottom MM 
1  BLK FORM 0.1 Z  X+0  Y-50  Z+0
2  BLK FORM 0.2  X+169  Y+0  Z+125
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+123 - ZMAX=+140 - face mill
6  ;-------------------------------------
7  ;
8  * - Face-Bottom (2)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+221  Y-25 R0 FMAX
14 L  Z+140 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+131 FMAX
19 CC  X+213  Z+131
20 CP IPA+90 DR+ F1000
21 L  X+209.01  Z+123
22 L  X-40.01
23 CC  X-40.01  Z+131
24 CP IPA+90 DR+
25 L  X-48.01  Z+140 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM face-bottom MM 
