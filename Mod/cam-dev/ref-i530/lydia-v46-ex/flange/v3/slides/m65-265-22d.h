0  BEGIN PGM m65-265-22d MM 
1  BLK FORM 0.1 Z  X+0  Y-145  Z-30
2  BLK FORM 0.2  X+145  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #11 D=12 - ZMIN=-22.5 - ZMAX=+15.24 - form mill
6  ;    AB Tools, Inc.
7  ;    TM1/4
8  ;-------------------------------------
9  ;
10 * - 1/4-20 Thread (7)
11 M5
12 TOOL CALL 11 Z S5000
13 L M140 MB MAX
14 M3
15 L  X+72.5  Y-72.5 R0 FMAX
16 L  Z+15.24 R0 FMAX
17 M8
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 L  Z-20.468 FMAX
21 L  Z-22.5 F2203
22 L  X+98.365
23 CC  X+72.5  Y-72.5
24 CP IPA+4050  Z+0 DR+ F806
25 L  X+72.5  Y-72.5 F2203
26 L  Z+5.08 FMAX
27 L  Z-20.468 FMAX
28 L  Z-22.5 F2203
29 L  X+99.165
30 CC  X+72.5  Y-72.5
31 CP IPA+4050  Z+0 DR+ F806
32 L  X+72.5  Y-72.5 F2203
33 L  Z+15.24 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM m65-265-22d MM 
