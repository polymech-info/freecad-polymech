0  BEGIN PGM m10_final MM 
1  BLK FORM 0.1 Z  X-25  Y-25  Z-50
2  BLK FORM 0.2  X+25  Y+25  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=7.8 - ZMIN=-37 - ZMAX=+16 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket1 (2)
9  M5
10 TOOL CALL 5 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+3203 ; Cutting
19 FN 0: Q51 =+3203 ; Predrilling
20 FN 0: Q54 =+3203 ; Exit
21 L  Z-37 FQ51
22 CC  X+0.39  Y+0
23 CP IPA+90 DR+ FQ50
24 L  X+0.66  Y-0.39
25 CC  X+0.66  Y+0
26 CP IPA+90 DR+
27 CC  X+0  Y+0
28 CP IPA+360 DR+
29 L  X+1.046  Y+0.08  Z-36.987 FQ54
30 L  X+1.034  Y+0.16  Z-36.975
31 L  X+1.013  Y+0.237  Z-36.962
32 L  X+0.973  Y+0.338  Z-36.906
33 L  X+0.919  Y+0.433  Z-36.851
34 L  X+0.867  Y+0.502  Z-36.765
35 L  X+0.808  Y+0.564  Z-36.678
36 L  X+0.723  Y+0.635  Z-36.461
37 L  X+0.691  Y+0.656  Z-36.22
38 L  Z+16 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM m10_final MM 
