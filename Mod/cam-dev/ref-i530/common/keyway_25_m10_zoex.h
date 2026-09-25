0  BEGIN PGM keyway_25_m10_zoex MM 
1  BLK FORM 0.1 Z  X+0  Y-25  Z-35
2  BLK FORM 0.2  X+220  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-4.5 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (3)
9  M5
10 TOOL CALL 3 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+9.99  Y-12.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+550 ; Cutting
19 FN 0: Q53 =+550 ; Entry
20 FN 0: Q57 =+550 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  X+40.01  Z+1.75 FQ57
24 L  X+9.99  Z+1
25 L  X+40.01  Z+0.25
26 L  X+9.99  Z-0.5
27 L  X+40.01 FQ50
28 L  X+9.99
29 L  X+40.01  Z-1.5 FQ57
30 L  X+9.99  Z-2.5
31 L  X+40.01 FQ50
32 L  X+9.99
33 L  X+40.01  Z-3.5 FQ57
34 L  X+9.99  Z-4.5
35 L  X+40.01 FQ50
36 L  X+9.99
37 L  Z+85 FMAX
38 M9
39 M5
40 L M140 MB MAX
41 M30
42 END PGM keyway_25_m10_zoex MM 
