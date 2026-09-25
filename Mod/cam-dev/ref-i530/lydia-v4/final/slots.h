0  BEGIN PGM slots MM 
1  BLK FORM 0.1 Z  X+0  Y-35  Z-35
2  BLK FORM 0.2  X+220  Y+0  Z+0
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
13 L  X+60  Y-17.5 R0 FMAX
14 L  Z+85 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F550
20 L  X+24  Z+1.85
21 L  X+60  Z+1.2
22 L  X+24  Z+0.55
23 L  X+60  Z-0.1
24 L  X+24
25 L  X+60
26 L  X+24  Z-1.1
27 L  X+60  Z-2.1
28 L  X+24
29 L  X+60
30 L  X+24  Z-3.1
31 L  X+60  Z-4.1
32 L  X+24
33 L  X+60
34 L  Z+45 FMAX
35 L  X+108 FMAX
36 L  Z+5 FMAX
37 L  Z+2.5 F550
38 L  X+144  Z+1.85
39 L  X+108  Z+1.2
40 L  X+144  Z+0.55
41 L  X+108  Z-0.1
42 L  X+144
43 L  X+108
44 L  X+144  Z-1.1
45 L  X+108  Z-2.1
46 L  X+144
47 L  X+108
48 L  X+144  Z-3.1
49 L  X+108  Z-4.1
50 L  X+144
51 L  X+108
52 L  Z+85 FMAX
53 M9
54 M5
55 L M140 MB MAX
56 M30
57 END PGM slots MM 
