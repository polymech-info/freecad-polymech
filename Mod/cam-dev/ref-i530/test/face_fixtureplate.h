0  BEGIN PGM face_fixtureplate MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+350  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.3 - ZMAX=+10 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+399  Y-170.747 R0 FMAX
14 L  Z+10 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 FN 0: Q50 =+1000 ; Cutting
18 FN 0: Q52 =+1000 ; Finish
19 FN 0: Q53 =+1000 ; Entry
20 FN 0: Q54 =+1000 ; Exit
21 L  Z+7.7 FMAX
22 CC  X+391  Z+7.7
23 CP IPA+90 DR+ FQ53
24 L  X+347  Z-0.3
25 L  X+2 FQ52
26 CC  X+2  Y-138.5
27 CP IPA-180 DR- FQ50
28 L  X+347  Y-106.253 FQ52
29 CC  X+347  Y-74.007
30 CP IPA+180 DR+ FQ50
31 L  X+2  Y-41.76 FQ52
32 CC  X+2  Z+7.7
33 CP IPA+90 DR+ FQ54
34 L  X-6  Z+10 FMAX
35 M5
36 L M140 MB MAX
37 M30
38 END PGM face_fixtureplate MM 
