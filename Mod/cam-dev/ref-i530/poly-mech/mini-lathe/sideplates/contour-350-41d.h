0  BEGIN PGM contour-350-41d MM 
1  BLK FORM 0.1 Z  X+0  Y-350  Z-60
2  BLK FORM 0.2  X+430  Y+0  Z+0
3  ;-------------------------------------
4  ;T30 D=+17 CR=+0 - ZMIN=-41 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour5 (30)
10 TOOL CALL 30 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-53.5  Y-365 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-26 F1068
20 CC  X-38.5  Z-26
21 CP IPA-90 DR- F3203
22 L  X-23.5  Z-41
23 CC  X-23.5  Y-350
24 CP IPA+90 DR+
25 L  X-8.5  Y+0
26 CC  X-23.5  Y+0
27 CP IPA+90 DR+
28 L  X-38.5  Y+15
29 CC  X-38.5  Z-26
30 CP IPA+90 DR+
31 L  X-53.5  Z+15 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM contour-350-41d MM 
