0  BEGIN PGM 100mm-support-blocks-facing-2 MM 
1  BLK FORM 0.1 Z  X+0  Y-40  Z+0
2  BLK FORM 0.2  X+70  Y+0  Z+100
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+100 - ZMAX=+125 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (4)
9  M5
10 TOOL CALL 23 Z S700
11 L M140 MB MAX
12 M3
13 L  X-4  Y-91.817 R0 FMAX
14 L  Z+125 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+108 FMAX
19 CC  Y-83.817  Z+108
20 CP IPA+90 DR+ F860
21 L  Y-80.01  Z+100
22 L  Y+40.01 F460
23 CC  Y+40.01  Z+108
24 CP IPA+90 DR+ F860
25 L  Y+48.01  Z+115 FMAX
26 L  X+31.6  Y-92 FMAX
27 L  Z+108 FMAX
28 CC  Y-84  Z+108
29 CP IPA+90 DR+ F860
30 L  Y-80.01  Z+100
31 L  Y+40.01 F460
32 CC  Y+40.01  Z+108
33 CP IPA+90 DR+ F860
34 L  Y+48.01  Z+125 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM 100mm-support-blocks-facing-2 MM 
