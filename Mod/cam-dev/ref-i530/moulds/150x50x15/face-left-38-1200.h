0  BEGIN PGM face-left-38-1200 MM 
1  BLK FORM 0.1 Z  X+0  Y-84  Z-36
2  BLK FORM 0.2  X+1200  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-38 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (18)
9  M5
10 TOOL CALL 27 Z S4851
11 L M140 MB MAX
12 M3
13 L  X-7  Y-95.105 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+4 FMAX
19 L  Z-13.04 F184
20 L  Y+13.362 F551
21 L  Z+45 FMAX
22 L  Y-95.105 FMAX
23 L  Z+4 FMAX
24 L  Z-26.079 F184
25 L  Y+13.362 F551
26 L  Z+45 FMAX
27 L  Y-95.105 FMAX
28 L  Z+4 FMAX
29 L  Z-38 F184
30 L  Y+13.362 F551
31 L  Z+60 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM face-left-38-1200 MM 
