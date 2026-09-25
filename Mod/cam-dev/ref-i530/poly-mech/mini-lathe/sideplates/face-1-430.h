0  BEGIN PGM face-1-430 MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-350
2  BLK FORM 0.2  X+430  Y+0  Z+0
3  ;-------------------------------------
4  ;T23 D=+80 CR=+0 - ZMIN=-1 - face mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Face3 (13)
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-53  Y-30 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7 FMAX
19 CC  X-45  Z+7
20 CP IPA-90 DR- F1000
21 L  X+475  Z-1
22 CC  X+475  Z+7
23 CP IPA-90 DR-
24 L  X+483  Z+15 FMAX
25 M9
26 M5
27 L M140 MB MAX
28 M30
29 END PGM face-1-430 MM 
