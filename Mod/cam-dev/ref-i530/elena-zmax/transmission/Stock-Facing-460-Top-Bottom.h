0  BEGIN PGM Stock-Facing-460-Top-Bottom MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z+0
2  BLK FORM 0.2  X+460  Y+0  Z+73
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+70 - ZMAX=+88 - face mill
6  ;-------------------------------------
7  ;
8  * - Face-Top
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+512  Y-30 R0 FMAX
14 L  Z+88 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+79.5 FMAX
19 CC  X+504  Z+79.5
20 CP IPA+90 DR+ F1000
21 L  X+500.01  Z+71.5
22 L  X-40.01
23 CC  X-40.01  Z+79.5
24 CP IPA+90 DR+
25 L  X-48.01  Z+88 FMAX
26 M0
27 * - Face-Bottom
28 TOOL CALL  Z S5000
29 M3
30 L  X+512  Y-30 R0 FMAX
31 L  Z+88 R0 FMAX
32 M8
33 L  Z+78 FMAX
34 CC  X+504  Z+78
35 CP IPA+90 DR+ F1000
36 L  X+500.01  Z+70
37 L  X-40.01
38 CC  X-40.01  Z+78
39 CP IPA+90 DR+
40 L  X-48.01  Z+88 FMAX
41 M9
42 M5
43 L M140 MB MAX
44 M30
45 END PGM Stock-Facing-460-Top-Bottom MM 
