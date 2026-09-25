0  BEGIN PGM slot-750xxx MM 
1  BLK FORM 0.1 Z  X+243  Y-60  Z-20
2  BLK FORM 0.2  X+733  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #31 D=10 CR=5 - ZMIN=-6.053 - ZMAX=+30 - ball end mill
6  ;-------------------------------------
7  ;
8  * - Parallel1
9  M5
10 TOOL CALL 31 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+753.691  Y-29.98 R0 FMAX
14 L  Z+30 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-2.323 FMAX
19 L  Z-5.054 F1069
20 CC  X+752.691  Z-5.054
21 CP IPA+112.913 DR+ F3206
22 CC  X+749.999  Z-10.973
23 CP IPA-22.057 DR-
24 L  X+749.356  Z-5.47
25 L  X+3.394
26 CC  X+3.394  Z-4.47
27 CP IPA+90 DR+
28 L  X+2.394  Z+30 FMAX
29 M9
30 M5
31 L M140 MB MAX
32 M30
33 END PGM slot-750xxx MM 
