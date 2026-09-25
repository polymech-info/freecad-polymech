0  BEGIN PGM face-16-2x MM 
1  BLK FORM 0.1 Z  X+0  Y-32  Z-16
2  BLK FORM 0.2  X+650  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+45 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+702  Y-16 R0 FMAX
14 L  Z+45 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.5 FMAX
19 CC  X+694  Z+7.5
20 CP IPA+90 DR+ F1000
21 L  X+690  Z-0.5
22 L  X-40
23 CC  X-40  Z+7.5
24 CP IPA+90 DR+
25 L  X-48  Z+35 FMAX
26 L  X+702 FMAX
27 L  Z+7 FMAX
28 CC  X+694  Z+7
29 CP IPA+90 DR+ F1000
30 L  X+690  Z-1
31 L  X-40
32 CC  X-40  Z+7
33 CP IPA+90 DR+
34 L  X-48  Z+45 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM face-16-2x MM 
