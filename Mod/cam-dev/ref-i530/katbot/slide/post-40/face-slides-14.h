0  BEGIN PGM face-slides-14 MM 
1  BLK FORM 0.1 Z  X+0  Y-40  Z-40
2  BLK FORM 0.2  X+710  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1.565 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face3
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-52  Y-20 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+6.435 FMAX
19 CC  X-44  Z+6.435
20 CP IPA-90 DR- F1000
21 L  X+0  Z-1.565
22 L  X+240
23 CC  X+240  Z+6.435
24 CP IPA-90 DR-
25 L  X+248  Z+15 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM face-slides-14 MM 
