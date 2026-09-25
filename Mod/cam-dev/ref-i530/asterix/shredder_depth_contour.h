0  BEGIN PGM shredder_depth_contour MM 
1  BLK FORM 0.1 Z  X+0  Y-200  Z-15
2  BLK FORM 0.2  X+500  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #3 D=10 - ZMIN=-4.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 3 Z S1940
11 L M140 MB MAX
12 M3
13 L  X+297  Y+1 R0 FMAX
14 L  Z+15 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 FN 0: Q52 =+202 ; Finish
18 FN 0: Q53 =+202 ; Entry
19 FN 0: Q54 =+202 ; Exit
20 FN 0: Q56 =+50 ; Reduced
21 FN 0: Q58 =+67 ; Plunge
22 L  Z+5 FMAX
23 L  Z-3.5 FQ58
24 CC  X+296  Z-3.5
25 CP IPA+90 DR+ FQ53
26 L  X+295  Z-4.5
27 CC  X+295  Y+0
28 CP IPA+90 DR+
29 L  X+294  Y-23.25 FQ52
30 CC  X+289  Y-23.25
31 CP IPA-90 DR-
32 CC  X+289  Y-28.5
33 CP IPA+90 DR+ FQ56
34 CC  X+283.75  Y-28.5
35 CP IPA-90 DR- FQ52
36 L  X+63.5  Y-33.5
37 CC  X+63.5  Y-28.5
38 CP IPA-6.061 DR- FQ56
39 CC  X+58  Y-34
40 CP IPA-6.061 DR- FQ52
41 L  X+63  Y-190.5
42 L  Y-192.5 FQ56
43 L  X+302 FQ52
44 L  X+304 FQ56
45 L  Y+0 FQ52
46 CC  X+303  Y+0
47 CP IPA+90 DR+ FQ54
48 L  X+302  Y+1
49 CC  X+302  Z-3.5
50 CP IPA+90 DR+
51 L  X+301  Z+15 FMAX
52 M5
53 L M140 MB MAX
54 M30
55 END PGM shredder_depth_contour MM 
