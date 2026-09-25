0  BEGIN PGM bore-20mm-48D-finish MM 
1  BLK FORM 0.1 Z  X+0  Y-41  Z-50
2  BLK FORM 0.2  X+58  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-48 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Bore1 (2)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+29.05  Y-13.25 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+0.4 FMAX
19 L  Z+0 F495
20 L  X+28.25
21 CC  X+28.25  Y-14
22 CP IPA+90 DR+
23 CC  X+29  Y-14
24 CP IPA+5400  Z-24.934 DR+
25 CC  X+29  Y-14
26 CP IPA+4995.332  Z-48 DR+
27 CC  X+29  Y-14
28 CP IPA+360 DR+
29 CC  X+28.467  Y-13.473
30 CP IPA+90 DR+
31 L  X+28.508  Y-14.569
32 L  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM bore-20mm-48D-finish MM 
