0  BEGIN PGM face-760-80-80 MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-60
2  BLK FORM 0.2  X+765  Y+0  Z+0
3  ;-------------------------------------
4  ;T23 D=+80 CR=+0 - ZMIN=-0.7 - face mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Face3 (8)
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-53  Y+12.567 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.7 FMAX
19 CC  X-45  Z+7.7
20 CP IPA-90 DR- F1000
21 L  X+810  Z-0.7
22 CC  X+810  Z+7.7
23 CP IPA-90 DR-
24 L  X-53  Y-14.567  Z+7.7 FMAX
25 CC  X-45  Z+7.7
26 CP IPA-90 DR- F1000
27 L  X+810  Z-0.7
28 CC  X+810  Z+7.7
29 CP IPA-90 DR-
30 L  X-53  Y-41.7  Z+7.7 FMAX
31 CC  X-45  Z+7.7
32 CP IPA-90 DR- F1000
33 L  X+810  Z-0.7
34 CC  X+810  Z+7.7
35 CP IPA-90 DR-
36 L  X+818  Z+15 FMAX
37 M9
38 M5
39 L M140 MB MAX
40 M30
41 END PGM face-760-80-80 MM 
