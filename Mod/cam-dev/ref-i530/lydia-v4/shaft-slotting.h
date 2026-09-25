0  BEGIN PGM shaft-slotting MM 
1  BLK FORM 0.1 Z  X-220  Y-35  Z-35
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-4.1 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (6)
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-160  Y-17.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+550 ; Cutting
19 FN 0: Q53 =+550 ; Entry
20 FN 0: Q57 =+550 ; Ramping
21 L  Z+5 FMAX
22 L  Z+2.5 FQ53
23 L  X-196  Z+1.85 FQ57
24 L  X-160  Z+1.2
25 L  X-196  Z+0.55
26 L  X-160  Z-0.1
27 L  X-196 FQ50
28 L  X-160
29 L  X-196  Z-1.1 FQ57
30 L  X-160  Z-2.1
31 L  X-196 FQ50
32 L  X-160
33 L  X-196  Z-3.1 FQ57
34 L  X-160  Z-4.1
35 L  X-196 FQ50
36 L  X-160
37 L  Z+45 FMAX
38 L  X-112 FMAX
39 L  Z+5 FMAX
40 L  Z+2.5 FQ53
41 L  X-76  Z+1.85 FQ57
42 L  X-112  Z+1.2
43 L  X-76  Z+0.55
44 L  X-112  Z-0.1
45 L  X-76 FQ50
46 L  X-112
47 L  X-76  Z-1.1 FQ57
48 L  X-112  Z-2.1
49 L  X-76 FQ50
50 L  X-112
51 L  X-76  Z-3.1 FQ57
52 L  X-112  Z-4.1
53 L  X-76 FQ50
54 L  X-112
55 L  Z+85 FMAX
56 M9
57 M5
58 L M140 MB MAX
59 M30
60 END PGM shaft-slotting MM 
