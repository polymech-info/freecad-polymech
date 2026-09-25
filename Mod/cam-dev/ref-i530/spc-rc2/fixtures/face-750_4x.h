0  BEGIN PGM face-750_4x MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-40
2  BLK FORM 0.2  X+914  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S955
11 L M140 MB MAX
12 M3
13 L  X-44  Y-30 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-1 F460
20 L  X+0
21 L  X+914
22 L  Z+15 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM face-750_4x MM 
