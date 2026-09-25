0  BEGIN PGM face-bottom MM 
1  BLK FORM 0.1 Z  X+0  Y-25  Z+0
2  BLK FORM 0.2  X+500  Y+0  Z+225.8
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=+207.8 - ZMAX=+240.8 - face mill
6  ;-------------------------------------
7  ;
8  * - Face-Bottom
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+552  Y-12.5 R0 FMAX
14 L  Z+240.8 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+215.8 FMAX
19 CC  X+544  Z+215.8
20 CP IPA+90 DR+ F1000
21 L  X+540.01  Z+207.8
22 L  X-40.01
23 CC  X-40.01  Z+215.8
24 CP IPA+90 DR+
25 L  X-48.01  Z+240.8 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM face-bottom MM 
