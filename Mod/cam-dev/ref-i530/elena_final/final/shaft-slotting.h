0  BEGIN PGM shaft-slotting MM 
1  BLK FORM 0.1 Z  X+0  Y-25  Z-35
2  BLK FORM 0.2  X+220  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-4.2 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (10)
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+11.041  Y-12.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F550
20 L  X+31.959  Z+1.839
21 L  X+11.041  Z+1.178
22 L  X+31.959  Z+0.518
23 L  X+11.041  Z-0.143
24 L  X+31.959
25 L  X+11.041
26 L  X+31.959  Z-0.819
27 L  X+11.041  Z-1.495
28 L  X+31.959  Z-2.172
29 L  X+11.041  Z-2.848
30 L  X+31.959  Z-3.524
31 L  X+11.041  Z-4.2
32 L  X+31.959
33 L  X+11.041
34 L  Z+85 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM shaft-slotting MM 
