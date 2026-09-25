0  BEGIN PGM face-600mm-03 MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-40
2  BLK FORM 0.2  X+600  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.3 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S955
11 L M140 MB MAX
12 M3
13 L  X+651.069  Y-69 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.7 FMAX
19 CC  X+643.069  Z+7.7
20 CP IPA+90 DR+ F460
21 L  X+640.01  Z-0.3
22 L  X-40.01
23 CC  X-40.01  Z+7.7
24 CP IPA+90 DR+
25 L  X+652  Y-38.4  Z+7.7 FMAX
26 CC  X+644  Z+7.7
27 CP IPA+90 DR+ F460
28 L  X+640.01  Z-0.3
29 L  X-40.01
30 CC  X-40.01  Z+7.7
31 CP IPA+90 DR+
32 L  X-48.01  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM face-600mm-03 MM 
