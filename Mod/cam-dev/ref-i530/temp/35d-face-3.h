0  BEGIN PGM 35d-face-3 MM 
1  BLK FORM 0.1 Z  X+0  Y-35  Z-35
2  BLK FORM 0.2  X+300  Y+0  Z-3
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-3 - ZMAX=+12 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S955
11 L M140 MB MAX
12 M3
13 L  X-52  Y-17.5 R0 FMAX
14 L  Z+12 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 CC  X-44  Z+5
20 CP IPA-90 DR- F860
21 L  X-40.01  Z-3
22 L  X+340.01
23 CC  X+340.01  Z+5
24 CP IPA-90 DR-
25 L  X+348.01  Z+12 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM 35d-face-3 MM 
