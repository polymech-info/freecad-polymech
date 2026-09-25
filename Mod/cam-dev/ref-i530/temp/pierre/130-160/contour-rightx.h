0  BEGIN PGM contour-rightx MM 
1  BLK FORM 0.1 Z  X+0  Y-160  Z-30
2  BLK FORM 0.2  X+508  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13 - ZMIN=-5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour4 (11)
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+518.4  Y+1.3 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-3.7 F1069
20 CC  X+517.1  Z-3.7
21 CP IPA+90 DR+ F3206
22 L  X+515.8  Z-5
23 CC  X+515.8  Y+0
24 CP IPA+90 DR+
25 L  X+514.5  Y-160
26 CC  X+515.8  Y-160
27 CP IPA+90 DR+
28 L  X+517.1  Y-161.3
29 CC  X+517.1  Z-3.7
30 CP IPA-90 DR-
31 L  X+518.4  Z+15 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM contour-rightx MM 
