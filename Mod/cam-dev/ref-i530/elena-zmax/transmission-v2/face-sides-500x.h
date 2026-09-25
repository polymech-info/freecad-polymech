0  BEGIN PGM face-sides-500x MM 
1  BLK FORM 0.1 Z  X+6  Y-70  Z-30
2  BLK FORM 0.2  X+246  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-36 - ZMAX=+50 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour - sides
9  M5
10 TOOL CALL 21 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+510  Y+2 R0 FMAX
14 L  Z+50 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-34 F1350
20 CC  X+508  Z-34
21 CP IPA+90 DR+ F4051
22 L  X+506  Z-36
23 CC  X+506  Y+0
24 CP IPA+90 DR+
25 L  X+504  Y-70
26 CC  X+506  Y-70
27 CP IPA+90 DR+
28 L  X+508  Y-72
29 CC  X+508  Z-34
30 CP IPA-90 DR-
31 L  X+510  Z+40 FMAX
32 L  X-10 FMAX
33 L  Z+5 FMAX
34 L  Z-34 F1350
35 CC  X-8  Z-34
36 CP IPA-90 DR- F4051
37 L  X-6  Z-36
38 CC  X-6  Y-70
39 CP IPA+90 DR+
40 L  X-4  Y+0
41 CC  X-6  Y+0
42 CP IPA+90 DR+
43 L  X-8  Y+2
44 CC  X-8  Z-34
45 CP IPA+90 DR+
46 L  X-10  Z+50 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM face-sides-500x MM 
