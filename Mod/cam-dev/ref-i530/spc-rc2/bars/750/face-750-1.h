0  BEGIN PGM face-750-1 MM 
1  BLK FORM 0.1 Z  X+251.4  Y-60  Z-20
2  BLK FORM 0.2  X+741.4  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S955
11 L M140 MB MAX
12 M3
13 L  X-51.596  Y-30 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7 FMAX
19 CC  X-43.596  Z+7
20 CP IPA-90 DR- F860
21 L  X-40.01  Z-1
22 L  X+789.91
23 CC  X+789.91  Z+7
24 CP IPA-90 DR-
25 L  X+797.91  Z+15 FMAX
26 M9
27 M5
28 L  X+400  Y+240  Z+400 FMAX
29 L M140 MB MAX
30 M30
31 END PGM face-750-1 MM 
