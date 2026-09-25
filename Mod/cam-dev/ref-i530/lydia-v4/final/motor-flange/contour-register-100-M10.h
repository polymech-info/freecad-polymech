0  BEGIN PGM contour-register-100-M10 MM 
1  BLK FORM 0.1 Z  X-79.5  Y-79.5  Z-18
2  BLK FORM 0.2  X+79.5  Y+79.5  Z+0
3  ;-------------------------------------
4  ;T12 D=+10 CR=+0 - ZMIN=-2 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour10 (3)
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-2 F632
19 CC  X+0.5  Y+0
20 CP IPA+90 DR+
21 L  X+44.5  Y-0.5
22 CC  X+44.5  Y+0
23 CP IPA+90 DR+
24 CC  X+0  Y+0
25 CP IPA+372.732 DR+
26 CC  X+42.918  Y+9.698
27 CP IPA+90 DR+
28 L  X+41.722  Y+10.453
29 L  X+41.605  Y+10.426  Z-1.993
30 L  X+41.489  Y+10.4  Z-1.971
31 L  X+41.376  Y+10.374  Z-1.935
32 L  X+41.269  Y+10.35  Z-1.885
33 L  X+41.168  Y+10.327  Z-1.823
34 L  X+41.075  Y+10.306  Z-1.749
35 L  X+40.992  Y+10.288  Z-1.663
36 L  X+40.919  Y+10.271  Z-1.568
37 L  X+40.859  Y+10.257  Z-1.465
38 L  X+40.81  Y+10.246  Z-1.355
39 L  X+40.775  Y+10.239  Z-1.239
40 L  X+40.754  Y+10.234  Z-1.121
41 L  X+40.747  Y+10.232  Z-1
42 L  Z+15 FMAX
43 M9
44 M5
45 L M140 MB MAX
46 M30
47 END PGM contour-register-100-M10 MM 
