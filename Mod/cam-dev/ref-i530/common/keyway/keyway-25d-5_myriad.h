0  BEGIN PGM keyway-25d-5_myriad MM 
1  BLK FORM 0.1 Z  X+0  Y-25  Z-35
2  BLK FORM 0.2  X+220  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-5.2 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (11)
9  M5
10 TOOL CALL 31 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+8.024  Y-12.47 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F283
20 L  X+27.976  Z+1.92 F550
21 L  X+8.024  Z+1.339
22 L  X+27.976  Z+0.759
23 L  X+8.024  Z+0.178
24 L  X+27.976  Z-0.402
25 L  X+8.024  Z-0.982
26 L  X+27.976  Z-1.563
27 L  X+8.024  Z-2.143
28 L  X+27.976
29 L  X+8.024
30 L  X+27.976  Z-2.653
31 L  X+8.024  Z-3.162
32 L  X+27.976  Z-3.672
33 L  X+8.024  Z-4.181
34 L  X+27.976  Z-4.691
35 L  X+8.024  Z-5.2
36 L  X+27.976
37 L  X+8.024
38 L  Z+85 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM keyway-25d-5_myriad MM 
