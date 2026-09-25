0  BEGIN PGM test-contour-square-90-M14 MM 
1  BLK FORM 0.1 Z  X+0  Y-118  Z-65
2  BLK FORM 0.2  X+118  Y+0  Z+0
3  ;-------------------------------------
4  ;T27 D=+14 CR=+0 - ZMIN=-10 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour2 (13)
10 TOOL CALL 27 Z S2274
11 L M140 MB MAX
12 M3
13 L  X+60.4  Y-115.3 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-8.6 F67
20 CC  Y-113.9  Z-8.6
21 CP IPA+90 DR+ F200
22 L  Y-112.5  Z-10
23 CC  X+59  Y-112.5
24 CP IPA+90 DR+
25 L  X+14  Y-111.1 F2000
26 CC  X+14  Y-104
27 CP IPA-90 DR-
28 L  X+6.9  Y-14
29 CC  X+14  Y-14
30 CP IPA-90 DR-
31 L  X+104  Y-6.9
32 CC  X+104  Y-14
33 CP IPA-90 DR-
34 L  X+111.1  Y-104
35 CC  X+104  Y-104
36 CP IPA-90 DR-
37 L  X+49  Y-111.1
38 CC  X+49  Y-112.5
39 CP IPA+90 DR+ F200
40 L  X+47.6  Y-113.9
41 CC  Y-113.9  Z-8.6
42 CP IPA-90 DR-
43 L  Y-115.3  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM test-contour-square-90-M14 MM 
