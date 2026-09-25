0  BEGIN PGM c-down-tmp MM 
1  BLK FORM 0.1 Z  X-71  Y-34.25  Z-65
2  BLK FORM 0.2  X+694  Y+45.75  Z+0
3  ;-------------------------------------
4  ;T30 D=+17 CR=+0 - ZMIN=-66 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour1 (7)
10 TOOL CALL 30 Z S10000
11 L M140 MB MAX
12 M3
13 L  X+29.646  Y+53.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-50 FMAX
19 L  Z-66 F1059
20 L  X+27.946 F3177
21 L  X-27.946
22 CC  X-27.946  Y+45
23 CP IPA+90 DR+
24 L  X-36.446  Y+33.495
25 CC  X+0  Y+0
26 CP IPA+42.584 DR+
27 L  X-68  Y+0
28 CC  X-68  Y-10.5
29 CP IPA+90 DR+
30 L  X-78.5  Y-33.5
31 CC  X-70  Y-33.5
32 CP IPA+90 DR+
33 L  X+70  Y-42
34 L  Z+15 FMAX
35 ;-------------------------------------
36 * - 2D Contour1 (8)
37 M3
38 L  X+36.446  Y+46.7 R0 FMAX
39 L  Z+15 R0 FMAX
40 L  Z-50 FMAX
41 L  Z-66 F1059
42 L  Y+45 F3177
43 L  Y+36.895
44 L  Y+33.495 F794
45 CC  X+0  Y+0
46 CP IPA-38.648 DR- F3177
47 CC  X+0  Y+0
48 CP IPA-3.935 DR- F794
49 L  X+68  Y+0 F3177
50 CC  X+68  Y-10.5
51 CP IPA-90 DR-
52 L  X+78.5  Y-33.5
53 L  Z+15 FMAX
54 M9
55 M5
56 L M140 MB MAX
57 M30
58 END PGM c-down-tmp MM 
