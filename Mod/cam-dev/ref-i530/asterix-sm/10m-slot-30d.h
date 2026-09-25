0  BEGIN PGM 10m-slot-30d MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-50
2  BLK FORM 0.2  X+585  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-4 - ZMAX=+85 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1 (9)
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+30.005  Y-15 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F183
20 L  X+9.995  Z+1.85 F550
21 L  X+30.005  Z+1.2
22 L  X+9.995  Z+0.55
23 L  X+30.005  Z-0.1
24 L  X+9.995  Z-0.75
25 L  X+30.005  Z-1.4
26 L  X+9.995  Z-2.05
27 L  X+30.005  Z-2.7
28 L  X+9.995  Z-3.35
29 L  X+30.005  Z-4
30 L  X+9.995
31 L  X+30.005
32 L  Z+85 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM 10m-slot-30d MM 
