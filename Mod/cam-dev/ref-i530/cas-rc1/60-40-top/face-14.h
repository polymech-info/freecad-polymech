0  BEGIN PGM face-14 MM 
1  BLK FORM 0.1 Z  X+0  Y-82  Z-45
2  BLK FORM 0.2  X+142  Y+0  Z+0
3  ;-------------------------------------
4  ;T23 D=+80 CR=+0 - ZMIN=-14 - face mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Face3 (9)
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+195  Y-93.9 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-6 F333
20 CC  X+187  Z-6
21 CP IPA+90 DR+ F1000
22 L  X-45  Z-14
23 CC  X-45  Z-6
24 CP IPA+90 DR+
25 L  X-53  Z+5 FMAX
26 L  X+195  Y-66.1 FMAX
27 L  Z-6 F333
28 CC  X+187  Z-6
29 CP IPA+90 DR+ F1000
30 L  X-45  Z-14
31 CC  X-45  Z-6
32 CP IPA+90 DR+
33 L  X-53  Z+5 FMAX
34 L  X+195  Y-38.3 FMAX
35 L  Z-6 F333
36 CC  X+187  Z-6
37 CP IPA+90 DR+ F1000
38 L  X-45  Z-14
39 CC  X-45  Z-6
40 CP IPA+90 DR+
41 L  X-53  Z+15 FMAX
42 M9
43 M5
44 L M140 MB MAX
45 M30
46 END PGM face-14 MM 
