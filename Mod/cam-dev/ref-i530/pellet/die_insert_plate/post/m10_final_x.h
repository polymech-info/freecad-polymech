0  BEGIN PGM m10_final_x MM 
1  BLK FORM 0.1 Z  X-25  Y-25  Z-50
2  BLK FORM 0.2  X+25  Y+25  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=7.75 - ZMIN=-37 - ZMAX=+16 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Pocket1 (2)
9  M5
10 TOOL CALL 5 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+632 ; Cutting
19 FN 0: Q51 =+632 ; Predrilling
20 FN 0: Q54 =+632 ; Exit
21 L  Z-37 FQ51
22 CC  X+0.387  Y+0
23 CP IPA+90 DR+ FQ50
24 L  X+0.688  Y-0.387
25 CC  X+0.688  Y+0
26 CP IPA+90 DR+
27 CC  X+0  Y+0
28 CP IPA+360 DR+
29 L  X+1.071  Y+0.08  Z-36.987 FQ54
30 L  X+1.059  Y+0.159  Z-36.975
31 L  X+1.038  Y+0.236  Z-36.962
32 L  X+0.998  Y+0.336  Z-36.907
33 L  X+0.945  Y+0.43  Z-36.852
34 L  X+0.894  Y+0.498  Z-36.766
35 L  X+0.835  Y+0.561  Z-36.681
36 L  X+0.75  Y+0.631  Z-36.464
37 L  X+0.719  Y+0.652  Z-36.225
38 L  Z+16 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM m10_final_x MM 
