0  BEGIN PGM m20-bore-test-6 MM 
1  BLK FORM 0.1 Z  X-50  Y-10  Z-20
2  BLK FORM 0.2  X+50  Y+10  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #13 D=10 CR=5 - ZMIN=-6 - ZMAX=+15 - ball end mill
6  ;-------------------------------------
7  ;
8  * - Bore2 (3)
9  M5
10 TOOL CALL 13 Z S6000
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+2 FMAX
19 L  Z+0 F1000
20 L  X-0.512  Y-0.512
21 CC  X-0.512  Y+0
22 CP IPA-90 DR-
23 CC  X+0  Y+0
24 CP IPA-5400  Z-2.524 DR-
25 CC  X+0  Y+0
26 CP IPA-5400  Z-5.048 DR-
27 CC  X+0  Y+0
28 CP IPA-2037.224  Z-6 DR-
29 CC  X+0  Y+0
30 CP IPA-360 DR-
31 CC  X+0.277  Y-0.431
32 CP IPA-90 DR-
33 L  X+0  Y+0
34 L  Z+15 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM m20-bore-test-6 MM 
