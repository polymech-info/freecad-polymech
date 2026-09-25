0  BEGIN PGM bar-slots MM 
1  BLK FORM 0.1 Z  X+0  Y-35  Z-9
2  BLK FORM 0.2  X+150  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #18 D=7.95 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket5
9  M5
10 TOOL CALL 8 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+52  Y-17.475 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-12 F183
20 L  X+26.59 F550
21 L  X+25 F138
22 L  X+24.982  Y-17.482
23 L  X+24.975  Y-17.5
24 L  X+24.982  Y-17.518
25 L  X+25  Y-17.525
26 L  X+52 F550
27 L  X+52.018  Y-17.518 F138
28 L  X+52.025  Y-17.5
29 L  X+52.018  Y-17.482
30 L  X+52  Y-17.475
31 CC  X+52  Z-11.205
32 CP IPA+90 DR+ F550
33 L  X+51.205  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM bar-slots MM 
