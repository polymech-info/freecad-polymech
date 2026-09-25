0  BEGIN PGM m40-register MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-22
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;T12 D=+10 CR=+0 - ZMIN=-1.5 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour2 (9)
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+12.025  Y-1 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-0.5 F211
20 CC  X+13.025  Z-0.5
21 CP IPA-90 DR- F632
22 L  X+14.025  Z-1.5
23 CC  X+14.025  Y+0
24 CP IPA+90 DR+
25 CC  X+0  Y+0
26 CP IPA+398.134 DR+
27 CC  X+11.032  Y+8.66
28 CP IPA+90 DR+
29 L  X+9.628  Y+8.829
30 L  X+9.533  Y+8.755  Z-1.493
31 L  X+9.439  Y+8.682  Z-1.471
32 L  X+9.349  Y+8.611  Z-1.435
33 L  X+9.262  Y+8.543  Z-1.385
34 L  X+9.181  Y+8.479  Z-1.323
35 L  X+9.106  Y+8.42  Z-1.249
36 L  X+9.039  Y+8.367  Z-1.163
37 L  X+8.98  Y+8.321  Z-1.068
38 L  X+8.931  Y+8.283  Z-0.965
39 L  X+8.892  Y+8.252  Z-0.855
40 L  X+8.864  Y+8.23  Z-0.739
41 L  X+8.847  Y+8.216  Z-0.621
42 L  X+8.841  Y+8.212  Z-0.5
43 L  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM m40-register MM 
