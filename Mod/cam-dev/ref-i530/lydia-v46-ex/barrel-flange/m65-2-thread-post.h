0  BEGIN PGM m65-2-thread-post MM 
1  BLK FORM 0.1 Z  X-65  Y-65  Z-20
2  BLK FORM 0.2  X+65  Y+65  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #11 D=12 - ZMIN=-23 - ZMAX=+15.24 - form mill
6  ;    AB Tools, Inc.
7  ;    TM1/4
8  ;-------------------------------------
9  ;
10 * - 1/4-20 Thread (6)
11 M5
12 TOOL CALL 11 Z S5000
13 L M140 MB MAX
14 M3
15 L  X+0  Y+0 R0 FMAX
16 L  Z+15.24 R0 FMAX
17 M8
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 L  Z-20.968 FMAX
21 L  Z-23 F2203
22 L  X+26.57
23 CC  X+0  Y+0
24 CP IPA+4140  Z+0 DR+ F806
25 L  X+0  Y+0 F2203
26 L  Z+15.24 FMAX
27 M9
28 M5
29 L M140 MB MAX
30 M30
31 END PGM m65-2-thread-post MM 
