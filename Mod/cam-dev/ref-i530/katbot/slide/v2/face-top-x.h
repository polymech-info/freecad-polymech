0  BEGIN PGM face-top-x MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-80
2  BLK FORM 0.2  X+185  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-12 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face3 (3)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+237  Y-79 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+6 FMAX
19 CC  X+229  Z+6
20 CP IPA+90 DR+ F1000
21 L  X+225  Z-2
22 L  X-40
23 CC  X-40  Y-58.78
24 CP IPA-180 DR-
25 L  X+225  Y-38.56
26 CC  X+225  Z+6
27 CP IPA-90 DR-
28 L  X+237  Y-79  Z+6 FMAX
29 L  Z+5 FMAX
30 L  Z-4 F333
31 CC  X+229  Z-4
32 CP IPA+90 DR+ F1000
33 L  X+225  Z-12
34 L  X-40
35 CC  X-40  Y-58.78
36 CP IPA-180 DR-
37 L  X+225  Y-38.56
38 CC  X+225  Z-4
39 CP IPA-90 DR-
40 L  X+233  Z+15 FMAX
41 M9
42 M5
43 L M140 MB MAX
44 M30
45 END PGM face-top-x MM 
