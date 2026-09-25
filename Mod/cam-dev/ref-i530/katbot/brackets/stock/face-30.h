0  BEGIN PGM face-30 MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-25
2  BLK FORM 0.2  X+193.52  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-5 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face3
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+244.589  Y-69 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+3 F333
20 CC  X+236.589  Z+3
21 CP IPA+90 DR+ F1000
22 L  X+233.53  Z-5
23 L  X-40.01
24 CC  X-40.01  Y-53.78
25 CP IPA-180 DR-
26 L  X+233.53  Y-38.56
27 CC  X+233.53  Z+3
28 CP IPA-90 DR-
29 L  X+241.53  Z+15 FMAX
30 M9
31 M5
32 L M140 MB MAX
33 M30
34 END PGM face-30 MM 
