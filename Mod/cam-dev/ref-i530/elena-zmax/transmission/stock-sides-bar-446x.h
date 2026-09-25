0  BEGIN PGM stock-sides-bar-446x MM 
1  BLK FORM 0.1 Z  X+0  Y-70  Z-30
2  BLK FORM 0.2  X+448  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-30 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour - sides (2)
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+494  Y+10 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-20 F1350
20 CC  X+484  Z-20
21 CP IPA+90 DR+ F4051
22 L  X+464  Z-30
23 CC  X+464  Y+0
24 CP IPA+90 DR+
25 L  X+454  Y-70
26 CC  X+464  Y-70
27 CP IPA+90 DR+
28 L  X+484  Y-80
29 CC  X+484  Z-20
30 CP IPA-90 DR-
31 L  X+494  Z+50 FMAX
32 L  X-46 FMAX
33 L  Z+5 FMAX
34 L  Z-20 F1350
35 CC  X-36  Z-20
36 CP IPA-90 DR- F4051
37 L  X-16  Z-30
38 CC  X-16  Y-70
39 CP IPA+90 DR+
40 L  X-6  Y+0
41 CC  X-16  Y+0
42 CP IPA+90 DR+
43 L  X-36  Y+10
44 CC  X-36  Z-20
45 CP IPA+90 DR+
46 L  X-46  Z+60 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM stock-sides-bar-446x MM 
