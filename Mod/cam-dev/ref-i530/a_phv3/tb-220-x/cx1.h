0  BEGIN PGM cx1 MM 
1  BLK FORM 0.1 Z  X-217.566  Y-110  Z-30
2  BLK FORM 0.2  X+341.676  Y+110  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=12.45 TAPER=90deg - ZMIN=-1.5 - ZMAX=+15 - countersink
6  ;-------------------------------------
7  ;
8  * - 2D Chamfer1 (2)
9  M5
10 TOOL CALL 7 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-17.745  Y+84.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 L  Z+5 FMAX
18 L  Z-1.5 F1333
19 L  X-16.5 F1000
20 CC  X-26  Y+84.5
21 CP IPA+420.311 DR+
22 L  X-21.911  Y+91.671
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM cx1 MM 
