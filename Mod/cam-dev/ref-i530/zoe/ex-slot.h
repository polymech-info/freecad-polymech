0  BEGIN PGM ex-slot MM 
1  BLK FORM 0.1 Z  X-220  Y-24  Z-35
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-4.1 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (7)
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-18  Y-12 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+550 ; Cutting
19 FN 0: Q53 =+550 ; Entry
20 FN 0: Q57 =+550 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  X-43  Z+1.85 FQ57
24 L  X-18  Z+1.2
25 L  X-43  Z+0.55
26 L  X-18  Z-0.1
27 L  X-43 FQ50
28 L  X-18
29 L  X-43  Z-0.6 FQ57
30 L  X-18  Z-1.1
31 L  X-43  Z-1.6
32 L  X-18  Z-2.1
33 L  X-43 FQ50
34 L  X-18
35 L  X-43  Z-2.6 FQ57
36 L  X-18  Z-3.1
37 L  X-43  Z-3.6
38 L  X-18  Z-4.1
39 L  X-43 FQ50
40 L  X-18
41 L  Z+85 FMAX
42 M9
43 M5
44 L M140 MB MAX
45 M30
46 END PGM ex-slot MM 
