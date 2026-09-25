0  BEGIN PGM mount-plate_elena_21 MM 
1  BLK FORM 0.1 Z  X+0  Y-84.001  Z-10
2  BLK FORM 0.2  X+119.999  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket2
9  M5
10 TOOL CALL 3 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+60  Y-42 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+3203 ; Cutting
19 FN 0: Q51 =+3203 ; Predrilling
20 FN 0: Q54 =+3203 ; Exit
21 L  Z+5 FMAX
22 L  Z-12 FQ51
23 CC  X+60.125  Y-42
24 CP IPA-180 DR- FQ50
25 CC  X+61.5  Y-42
26 CP IPA+180 DR+
27 CC  X+60  Y-42
28 CP IPA+180 DR+
29 CC  X+61.5  Y-42
30 CP IPA+180 DR+
31 CC  X+60  Y-42
32 CP IPA+360 DR+
33 CC  X+64.75  Y-42
34 CP IPA+14.829  Z-11.966 DR+ FQ54
35 L  X+65.679  Y-41.63  Z-11.916
36 L  X+65.627  Y-41.521  Z-11.866
37 L  X+65.573  Y-41.433  Z-11.787
38 L  X+65.51  Y-41.351  Z-11.707
39 L  X+65.456  Y-41.293  Z-11.604
40 L  X+65.398  Y-41.239  Z-11.5
41 L  X+65.318  Y-41.178  Z-11.259
42 L  X+65.29  Y-41.159  Z-11
43 L  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM mount-plate_elena_21 MM 
