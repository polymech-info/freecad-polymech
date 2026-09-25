0  BEGIN PGM face-1-75-800 MM 
1  BLK FORM 0.1 Z  X+0  Y-130  Z-90
2  BLK FORM 0.2  X+130  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.5 - ZMAX=+35 - face mill
6  ;-------------------------------------
7  ;
8  * - Face-Top
9  M5
10 TOOL CALL 23 Z S500
11 L M140 MB MAX
12 M3
13 L  X+218  Y-104 R0 FMAX
14 L  Z+35 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.5 FMAX
19 CC  X+210  Z+7.5
20 CP IPA+90 DR+ F2800
21 L  X-80  Z-0.5 F800
22 CC  X-80  Z+7.5
23 CP IPA+90 DR+ F2800
24 L  X-88  Z+25 FMAX
25 L  X+218  Y-38.75 FMAX
26 L  Z+7.5 FMAX
27 CC  X+210  Z+7.5
28 CP IPA+90 DR+ F2800
29 L  X-80  Z-0.5 F800
30 CC  X-80  Z+7.5
31 CP IPA+90 DR+ F2800
32 L  X-88  Z+35 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM face-1-75-800 MM 
