0  BEGIN PGM tx MM 
1  BLK FORM 0.1 Z  X-20  Y-20  Z-20
2  BLK FORM 0.2  X+20  Y+20  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #11 D=12 - ZMIN=-20 - ZMAX=+15.24 - form mill
6  ;    AB Tools, Inc.
7  ;    TM1/4
8  ;-------------------------------------
9  ;
10 * - 1/4-20 Thread
11 M5
12 TOOL CALL 11 Z S5000
13 L M140 MB MAX
14 M3
15 L  X+0  Y+0 R0 FMAX
16 L  Z+15.24 R0 FMAX
17 CYCL DEF 32.0 TOLERANCE
18 CYCL DEF 32.1
19 L  Z-17.968 FMAX
20 L  Z-20 F203
21 L  X+3.323
22 CC  X+0  Y+0
23 CP IPA+2880  Z+0 DR+ F406
24 L  X+0  Y+0 F203
25 L  Z+5.08 FMAX
26 L  Z-17.968 FMAX
27 L  Z-20 F203
28 L  X+3.885
29 CC  X+0  Y+0
30 CP IPA+2880  Z+0 DR+ F406
31 L  X+0  Y+0 F203
32 L  Z+5.08 FMAX
33 L  Z-17.968 FMAX
34 L  Z-20 F203
35 L  X+4.447
36 CC  X+0  Y+0
37 CP IPA+2880  Z+0 DR+ F406
38 L  X+0  Y+0 F203
39 L  Z+15.24 FMAX
40 M5
41 L M140 MB MAX
42 M30
43 END PGM tx MM 
