0  BEGIN PGM keyway-25-31Lx MM 
1  BLK FORM 0.1 Z  X+0  Y-25  Z-35
2  BLK FORM 0.2  X+220  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #31 D=10 - ZMIN=-4.3 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (10)
9  M5
10 TOOL CALL 31 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+10.547  Y-12.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F583
20 L  X+32.453  Z+1.814 F550
21 L  X+10.547  Z+1.128
22 L  X+32.453  Z+0.443
23 L  X+10.547  Z-0.243
24 L  X+32.453
25 L  X+10.547
26 L  X+32.453  Z-0.919
27 L  X+10.547  Z-1.595
28 L  X+32.453  Z-2.272
29 L  X+10.547  Z-2.948
30 L  X+32.453  Z-3.624
31 L  X+10.547  Z-4.3
32 L  X+32.453
33 L  X+10.547
34 L  Z+85 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM keyway-25-31Lx MM 
