0  BEGIN PGM face-0_6 MM 
1  BLK FORM 0.1 Z  X+0  Y-100  Z-102
2  BLK FORM 0.2  X+118  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.6 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+170  Y-89 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.4 FMAX
19 CC  X+162  Z+7.4
20 CP IPA+90 DR+ F1000
21 L  X+158.01  Z-0.6
22 L  X-40.01
23 CC  X-40.01  Y-63.78
24 CP IPA-180 DR-
25 L  X+158.01  Y-38.56
26 CC  X+158.01  Z+7.4
27 CP IPA-90 DR-
28 L  X+166.01  Z+15 FMAX
29 M9
30 M5
31 L M140 MB MAX
32 M30
33 END PGM face-0_6 MM 
