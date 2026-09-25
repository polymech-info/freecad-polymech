0  BEGIN PGM asterix-34-42l MM 
1  BLK FORM 0.1 Z  X+0  Y-31.9  Z-33.3
2  BLK FORM 0.2  X+330  Y+0  Z+3.4
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-4.5 - ZMAX=+88.4 - flat end mill
6  ;-------------------------------------
7  ;
8  * - Slot1
9  M5
10 TOOL CALL 12 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+14.991  Y-15.95 R0 FMAX
14 L  Z+88.4 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+8.4 FMAX
19 L  Z+5.9 F183
20 L  X+47.509  Z+4.8 F550
21 L  X+14.991  Z+3.7
22 L  X+47.509  Z+2.6
23 L  X+14.991  Z+1.5
24 L  X+47.509
25 L  X+14.991
26 L  X+47.509  Z+0.5
27 L  X+14.991  Z-0.5
28 L  X+47.509
29 L  X+14.991
30 L  X+47.509  Z-1.5
31 L  X+14.991  Z-2.5
32 L  X+47.509
33 L  X+14.991
34 L  X+47.509  Z-3.5
35 L  X+14.991  Z-4.5
36 L  X+47.509
37 L  X+14.991
38 L  Z+88.4 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM asterix-34-42l MM 
