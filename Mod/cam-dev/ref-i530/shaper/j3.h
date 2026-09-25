0  BEGIN PGM j3 MM 
1  L  X+0  Y+0  Z+0 FMAX
2  Q30 = 10 ;            (key width - b)
3  Q32 = 4 ;            (keyway depth - t2)
4  Q33 = 35 ;            (shaft diameter - d)
5  Q34 = 3 ;            (cutter width)
6  Q35 = 10 ;            (cutter length +y from spindle center)
7  Q36 = 0.1 ;            (top of stroke)
8  Q37 = - 40 ;           (bottom of stroke)
9  Q38 = 0.2 ;            (depth of cut - per stroke)
10 Q39 = 0.001 ;            (x spring compensation)
11 Q40 = 0.002 ;          (y spring compensation)
12 Q41 = 1500 ;             (plunge feedrate)
13 Q50 = Q33 / 2 ;              (shaft radius)
14 Q51 = Q30 / 2 ;              (half of key width)
15 Q52 = ( Q30 - Q34 ) / 2 ;    (x offset - half of key width minus cutter~
 width)
16 Q53 = SQRT ( ( Q50 * Q50 ) - ( Q51 * Q51 ) ) - Q35 ; (starting Y position -~
 Pythagorus FTW)
17 Q54 = Q50 + Q32 + Q40 - Q35 ;               (ending y position)
18 Q55 = Q54 - Q53 ;                        (total y feed)
19 Q56 = Q55 / Q38 ;                          (number of loops)
20 Q200 = Q53 ;             (y position)
21 M19 ;
22 FN 15: PRINT 100 /Q30 /Q31 /Q32 /Q33 ;
23 FN 15: PRINT 100 /Q34 /Q35 /Q36 /Q37 /Q38 ;
24 FN 15: PRINT 100 /Q39 /Q40 /Q41 ;
25 FN 15: PRINT 100 /Q50 /Q51 /Q52 ;
26 FN 15: PRINT 100 /Q53 /Q54 /Q55 ;
27 FN 15: PRINT 100 /Q56 ;
28 FN 15: PRINT 100 /Q200 ;
29 FN 15: PRINT 100 /Q200 ;
30 FN 15: PRINT 100 /Q200 ;
31 FN 15: PRINT 100 /Q200 ;
32 L  X+0  Y+Q200 FQ41 ;             (move to zero X and starting Y)
33 L  Z+Q36 R0 FQ41 ;                  (move Z to top of stroke)
34 CALL LBL 1 REPQ106 ;
35 LBL 1
36 L  Y+Q200 ;                (move to Y position)
37 L  Z+Q37 FQ41 ;             (plunge)
38 L  Z+Q36 ;                  (retract)
39 Q301 = Q52 - Q39
40 L  X+Q301 R0 F500
41 L  Z+Q37 FQ41 ;             (plunge)
42 L  Z+Q36 ;                  (retract)
43 Q200 = Q200 + Q38 ;      (increment Y position)
44 END PGM j3 MM 
