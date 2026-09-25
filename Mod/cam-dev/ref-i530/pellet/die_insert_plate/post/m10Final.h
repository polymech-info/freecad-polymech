0  BEGIN PGM m10Final MM 
1  BLK FORM 0.1 Z  X-25  Y-25  Z-50
2  BLK FORM 0.2  X+25  Y+25  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=7.7 - ZMIN=-37 - ZMAX=+16 - flat end mill
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
22 CC  X+0.385  Y+0
23 CP IPA+90 DR+ FQ50
24 L  X+0.715  Y-0.385
25 CC  X+0.715  Y+0
26 CP IPA+90 DR+
27 CC  X+0  Y+0
28 CP IPA+360 DR+
29 L  X+1.096  Y+0.079  Z-36.987 FQ54
30 L  X+1.084  Y+0.158  Z-36.975
31 L  X+1.064  Y+0.234  Z-36.962
32 L  X+1.024  Y+0.334  Z-36.908
33 L  X+0.971  Y+0.427  Z-36.853
34 L  X+0.92  Y+0.495  Z-36.768
35 L  X+0.861  Y+0.557  Z-36.683
36 L  X+0.777  Y+0.627  Z-36.468
37 L  X+0.746  Y+0.648  Z-36.23
38 L  Z+16 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM m10Final MM 
