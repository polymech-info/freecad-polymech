0  BEGIN PGM m5_slot MM 
1  BLK FORM 0.1 Z  X+0  Y-14  Z-14
2  BLK FORM 0.2  X+25  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=5 - ZMIN=-2.6 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (5)
9  M5
10 TOOL CALL 3 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+4.044  Y-7 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+550 ; Cutting
19 FN 0: Q53 =+550 ; Entry
20 FN 0: Q57 =+550 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  X+20.799  Z+1.99 FQ57
24 L  X+4.044  Z+1.48
25 L  X+20.799  Z+0.97
26 L  X+4.044  Z+0.46
27 L  X+20.799  Z-0.05
28 L  X+4.044  Z-0.56
29 L  X+20.799  Z-1.07
30 L  X+4.044  Z-1.58
31 L  X+20.799  Z-2.09
32 L  X+4.044  Z-2.6
33 L  X+20.799 FQ50
34 L  X+4.044
35 L  Z+85 FMAX
36 M9
37 M5
38 L M140 MB MAX
39 M30
40 END PGM m5_slot MM 
