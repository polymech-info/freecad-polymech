0  BEGIN PGM face-760-1d MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z+0
2  BLK FORM 0.2  X+760  Y+0  Z+40
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+39 - ZMAX=+55 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S955
11 L M140 MB MAX
12 M3
13 L  X+806.069  Y-69 R0 FMAX
14 L  Z+55 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+47 FMAX
19 CC  X+798.069  Z+47
20 CP IPA+90 DR+ F460
21 L  X+795.01  Z+39
22 L  X-35.01
23 CC  X-35.01  Z+47
24 CP IPA+90 DR+
25 L  X+807  Y-38.4  Z+47 FMAX
26 CC  X+799  Z+47
27 CP IPA+90 DR+ F460
28 L  X+795.01  Z+39
29 L  X-35.01
30 CC  X-35.01  Z+47
31 CP IPA+90 DR+
32 L  X-43.01  Z+55 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM face-760-1d MM 
