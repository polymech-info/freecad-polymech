0  BEGIN PGM keyway_25_m10_zoe MM 
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
13 L  X+9.995  Y-12.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+550 ; Cutting
19 FN 0: Q53 =+550 ; Entry
20 FN 0: Q57 =+550 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  X+30.005  Z+2 FQ57
24 L  X+9.995  Z+1.5
25 L  X+30.005  Z+1
26 L  X+9.995  Z+0.5
27 L  X+30.005  Z+0
28 L  X+9.995  Z-0.5
29 L  X+30.005 FQ50
30 L  X+9.995
31 L  X+30.005  Z-1 FQ57
32 L  X+9.995  Z-1.5
33 L  X+30.005  Z-2
34 L  X+9.995  Z-2.5
35 L  X+30.005 FQ50
36 L  X+9.995
37 L  X+30.005  Z-3 FQ57
38 L  X+9.995  Z-3.5
39 L  X+30.005  Z-4
40 L  X+9.995  Z-4.5
41 L  X+30.005 FQ50
42 L  X+9.995
43 L  Z+85 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM keyway_25_m10_zoe MM 
