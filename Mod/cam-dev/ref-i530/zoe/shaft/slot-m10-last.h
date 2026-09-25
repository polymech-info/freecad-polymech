0  BEGIN PGM slot-m10-last MM 
1  BLK FORM 0.1 Z  X+0  Y-24  Z-35
2  BLK FORM 0.2  X+210  Y+0  Z+0
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
13 L  X+8  Y-12 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F183
20 L  X+33  Z+1.85 F550
21 L  X+8  Z+1.2
22 L  X+33  Z+0.55
23 L  X+8  Z-0.1
24 L  X+33
25 L  X+8
26 L  X+33  Z-0.6
27 L  X+8  Z-1.1
28 L  X+33  Z-1.6
29 L  X+8  Z-2.1
30 L  X+33
31 L  X+8
32 L  X+33  Z-2.6
33 L  X+8  Z-3.1
34 L  X+33  Z-3.6
35 L  X+8  Z-4.1
36 L  X+33
37 L  X+8
38 L  Z+85 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM slot-m10-last MM 
