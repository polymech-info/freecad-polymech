0  BEGIN PGM m20-bore MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-10
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-23 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket2 (4)
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-23 F550
19 CC  X+0.5  Y+0
20 CP IPA+90 DR+
21 L  X+2.125  Y-0.5
22 CC  X+2.125  Y+0
23 CP IPA+90 DR+
24 CC  X+0  Y+0
25 CP IPA+180 DR+
26 CC  X+0.5  Y+0
27 CP IPA+180 DR+
28 CC  X+0  Y+0
29 CP IPA+360 DR+
30 CC  X+2.625  Y+0
31 CP IPA+14.829  Z-22.966 DR+
32 L  X+3.554  Y+0.37  Z-22.916
33 L  X+3.503  Y+0.479  Z-22.866
34 L  X+3.448  Y+0.568  Z-22.787
35 L  X+3.385  Y+0.65  Z-22.707
36 L  X+3.331  Y+0.708  Z-22.604
37 L  X+3.273  Y+0.762  Z-22.5
38 L  X+3.194  Y+0.823  Z-22.259
39 L  X+3.165  Y+0.841  Z-22
40 L  Z+15 FMAX
41 M9
42 M5
43 L M140 MB MAX
44 M30
45 END PGM m20-bore MM 
