0  BEGIN PGM flange-reactor-id-cleanup MM 
1  BLK FORM 0.1 Z  X-60  Y-60  Z-10
2  BLK FORM 0.2  X+60  Y+60  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-11 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (3)
9  M5
10 TOOL CALL 27 Z S9000
11 L M140 MB MAX
12 M3
13 L  X+3.8  Y-1.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-9.6 F157
20 CC  X+5.2  Z-9.6
21 CP IPA-90 DR- F472
22 L  X+6.6  Z-11
23 CC  X+6.6  Y+0
24 CP IPA+90 DR+
25 CC  X+0  Y+0
26 CP IPA+431.62 DR+
27 CC  X+2.081  Y+6.263
28 CP IPA+90 DR+
29 L  X+0.311  Y+5.376
30 L  X+0.265  Y+5.237  Z-10.992
31 L  X+0.219  Y+5.1  Z-10.969
32 L  X+0.175  Y+4.966  Z-10.931
33 L  X+0.132  Y+4.836  Z-10.879
34 L  X+0.09  Y+4.712  Z-10.812
35 L  X+0.052  Y+4.595  Z-10.733
36 L  X+0.016  Y+4.487  Z-10.64
37 L  X-0.017  Y+4.389  Z-10.537
38 L  X-0.046  Y+4.301  Z-10.423
39 L  X-0.071  Y+4.226  Z-10.3
40 L  X-0.092  Y+4.162  Z-10.169
41 L  X-0.109  Y+4.113  Z-10.033
42 L  X-0.121  Y+4.077  Z-9.891
43 L  X-0.128  Y+4.055  Z-9.746
44 L  X-0.13  Y+4.048  Z-9.6
45 L  Z+15 FMAX
46 M9
47 M5
48 L M140 MB MAX
49 M30
50 END PGM flange-reactor-id-cleanup MM 
