0  BEGIN PGM face-32-430-rev MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-350
2  BLK FORM 0.2  X+430  Y+0  Z+0
3  ;-------------------------------------
4  ;T23 D=+80 CR=+0 - ZMIN=-3.3 - face mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Face3 (12)
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-53  Y+19.233 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+4.7 F333
20 CC  X-45  Z+4.7
21 CP IPA-90 DR- F1000
22 L  X+475  Z-3.3
23 CC  X+475  Z+4.7
24 CP IPA-90 DR-
25 L  X+483  Z+5 FMAX
26 L  X-53  Y-1.233 FMAX
27 L  Z+4.7 F333
28 CC  X-45  Z+4.7
29 CP IPA-90 DR- F1000
30 L  X+475  Z-3.3
31 CC  X+475  Z+4.7
32 CP IPA-90 DR-
33 L  X+483  Z+5 FMAX
34 L  X-53  Y-21.7 FMAX
35 L  Z+4.7 F333
36 CC  X-45  Z+4.7
37 CP IPA-90 DR- F1000
38 L  X+475  Z-3.3
39 CC  X+475  Z+4.7
40 CP IPA-90 DR-
41 L  X+483  Z+15 FMAX
42 M9
43 M5
44 L M140 MB MAX
45 M30
46 END PGM face-32-430-rev MM 
