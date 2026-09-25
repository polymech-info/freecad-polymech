0  BEGIN PGM m30-1 MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-30
2  BLK FORM 0.2  X+150  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #11 D=12 - ZMIN=-20 - ZMAX=+15.24 - form mill
6  ;    AB Tools, Inc.
7  ;    TM1/4
8  ;-------------------------------------
9  ;
10 * - 1/4-20 Thread (7)
11 M5
12 TOOL CALL 11 Z S5000
13 L M140 MB MAX
14 M3
15 L  X+37.5  Y-60.325 R0 FMAX
16 L  Z+15.24 R0 FMAX
17 M8
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 L  Z+2.032 FMAX
21 L  Z+0 F2203
22 CC  X+37.5  Y-40
23 CP IPA-3600  Z-20 DR- F806
24 L  X+37.5  Y-60.325  Z+5.08 FMAX
25 L  Y-59.725 FMAX
26 L  Z+2.032 FMAX
27 L  Z+0 F2203
28 CC  X+37.5  Y-40
29 CP IPA-3600  Z-20 DR- F806
30 L  X+37.5  Y-59.725  Z+15.24 FMAX
31 M9
32 M5
33 L M140 MB MAX
34 M30
35 END PGM m30-1 MM 
