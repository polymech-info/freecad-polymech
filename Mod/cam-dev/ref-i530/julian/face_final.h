0  BEGIN PGM face_final MM 
1  BLK FORM 0.1 Z  X+0  Y-127.974  Z-25
2  BLK FORM 0.2  X+180.003  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face2
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+232.003  Y-102.987 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q52 =+1000 ; Finish
19 FN 0: Q53 =+1000 ; Entry
20 FN 0: Q54 =+1000 ; Exit
21 L  Z+7.9 FMAX
22 CC  X+224.003  Z+7.9
23 CP IPA+90 DR+ FQ53
24 L  X+180.003  Z-0.1
25 L  X+0 FQ52
26 CC  X+0  Z+7.9
27 CP IPA+90 DR+ FQ54
28 L  X-52  Y-38.76  Z+7.9 FMAX
29 CC  X-44  Z+7.9
30 CP IPA-90 DR- FQ53
31 L  X+0  Z-0.1
32 L  X+180.003 FQ52
33 CC  X+180.003  Z+7.9
34 CP IPA-90 DR- FQ54
35 L  X+188.003  Z+15 FMAX
36 M9
37 M5
38 L M140 MB MAX
39 M30
40 END PGM face_final MM 
