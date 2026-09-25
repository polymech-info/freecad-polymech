0  BEGIN PGM face-1575-750 MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z+0
2  BLK FORM 0.2  X+1500  Y+0  Z+10
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+15.85 - ZMAX=+55 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+802  Y-40 R0 FMAX
14 L  Z+55 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+23.85 FMAX
19 CC  X+794  Z+23.85
20 CP IPA+90 DR+ F1000
21 L  X+790  Z+15.85
22 L  X-40
23 CC  X-40  Z+23.85
24 CP IPA+90 DR+
25 L  X-48  Z+55 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM face-1575-750 MM 
