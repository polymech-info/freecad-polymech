0  BEGIN PGM plunger_linear_guide_slot MM 
1  BLK FORM 0.1 Z  X-40  Y-30  Z-8
2  BLK FORM 0.2  X+40  Y+30  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-2 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1
9  M5
10 TOOL CALL 3 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+0  Y+25.005 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+551 ; Cutting
19 FN 0: Q53 =+551 ; Entry
20 FN 0: Q57 =+551 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  Y-25.005  Z+1 FQ57
24 L  Y+25.005  Z-0.5
25 L  Y-25.005  Z-2
26 L  Y+25.005 FQ50
27 L  Z+15 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM plunger_linear_guide_slot MM 
