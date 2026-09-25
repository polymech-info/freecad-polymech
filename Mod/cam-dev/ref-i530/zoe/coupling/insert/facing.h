0  BEGIN PGM facing MM 
1  BLK FORM 0.1 Z  X+0  Y-90  Z-24
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+172  Y-84 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 FN 0: Q50 =+1000 ; Cutting
19 FN 0: Q52 =+1000 ; Finish
20 FN 0: Q53 =+1000 ; Entry
21 FN 0: Q54 =+1000 ; Exit
22 L  Z+7 FMAX
23 CC  X+164  Z+7
24 CP IPA+90 DR+ FQ53
25 L  X+120  Z-1
26 L  X+0 FQ52
27 CC  X+0  Y-61.38
28 CP IPA-180 DR- FQ50
29 L  X+120  Y-38.76 FQ52
30 CC  X+120  Z+7
31 CP IPA-90 DR- FQ54
32 L  X+128  Z+15 FMAX
33 M9
34 M5
35 L M140 MB MAX
36 M30
37 END PGM facing MM 
