0  BEGIN PGM side-slots MM 
1  BLK FORM 0.1 Z  X+0  Y-40  Z-100
2  BLK FORM 0.2  X+80  Y+0  Z+0
3  ;-------------------------------------
4  ;T2 D=+4 CR=+0 - ZMIN=-15 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Slot1
10 TOOL CALL 2 Z S3000
11 L M140 MB MAX
12 M3
13 L  X+78.008  Y-20 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2.5 F1006
20 L  X+1.992  Z+1.042 F3177
21 L  X+78.008  Z-0.417
22 L  X+1.992  Z-1.875
23 L  X+78.008  Z-3.333
24 L  X+1.992  Z-4.792
25 L  X+78.008  Z-6.25
26 L  X+1.992  Z-7.708
27 L  X+78.008  Z-9.167
28 L  X+1.992  Z-10.625
29 L  X+78.008  Z-12.083
30 L  X+1.992  Z-13.542
31 L  X+78.008  Z-15
32 L  X+1.992 F318
33 L  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM side-slots MM 
