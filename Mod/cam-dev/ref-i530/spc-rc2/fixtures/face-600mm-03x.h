0  BEGIN PGM face-600mm-03x MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-40
2  BLK FORM 0.2  X+600  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.3 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  L  Z+0 R0 FMAX M91
9  * - Face1
10 M5
11 TOOL CALL 23 Z S955
12 L  Z+0 R0 FMAX M91
13 M3
14 L  X+651.069  Y-69 R0 FMAX
15 L  Z+15 R0 FMAX
16 M8
17 CYCL DEF 32.0 TOLERANCE
18 CYCL DEF 32.1
19 L  Z+7.7 FMAX
20 CC  X+643.069  Z+7.7
21 CP IPA+90 DR+ F460
22 L  X+640.01  Z-0.3
23 L  X-40.01
24 CC  X-40.01  Z+7.7
25 CP IPA+90 DR+
26 L  X+652  Y-38.4  Z+7.7 FMAX
27 CC  X+644  Z+7.7
28 CP IPA+90 DR+ F460
29 L  X+640.01  Z-0.3
30 L  X-40.01
31 CC  X-40.01  Z+7.7
32 CP IPA+90 DR+
33 L  X-48.01  Z+15 FMAX
34 M9
35 M5
36 L  Z+0 R0 FMAX M91
37 M30
38 END PGM face-600mm-03x MM 
