0  BEGIN PGM shaper6 MM 
1  Q1 = 50 ;            (key width - b)
2  Q2 = 10 ;            (keyway depth - t2)
3  Q3 = 35 ;            (shaft diameter - d)
4  Q4 = 3 ;            (cutter width)
5  Q5 = 15 ;            (cutter length +y from spindle center)
6  Q6 = 0.1 ;            (top of stroke)
7  Q7 = - 40 ;           (bottom of stroke)
8  Q8 = 0.2 ;            (depth of cut - per stroke)
9  Q9 = 0.001 ;            (x spring compensation)
10 Q10 = 0.002 ;          (y spring compensation)
11 Q11 = 500 ;             (plunge feedrate)
12 ; [...] !
13 Q100 = Q3 / 2 ;                             (shaft radius)
14 Q101 = Q1 / 2 ;                               (half of key width)
15 Q102 = ( Q1 - Q4 ) / 2 ;                          (x offset - half of key~
 width minus cutter width)
16 Q103 = SQ ( ( Q100 * Q100 ) - ( Q101 * Q101 ) ) - Q5 ; (starting Y position~
 - Pythagorus FTW)
17 Q104 = Q100 + Q2 + Q10 - Q5 ;               (ending y position)
18 Q105 = Q104 - Q103 ;                        (total y feed)
19 Q106 = Q105 / Q8 ;                          (number of loops)
20 ; [...] !
21 Q200 = Q103 ;             (y position)
22 M19 ;
23 L  X+0  Y+Q200 FQ11 ;             (move to zero X and starting Y)
24 L  Z+Q6 R0 FQ11 ;                  (move Z to top of stroke)
25 CALL LBL 1 REPQ106 ;
26 ; [...] !
27 LBL 1
28 L  Y+Q200 ;                (move to Y position)
29 L  Z+Q7 FQ11 ;             (plunge)
30 L  Z+Q6 ;                  (retract)
31 Q301 = Q102 - Q9
32 L  X+Q301 R0 F500
33 L  Z+Q7 FQ11 ;             (plunge)
34 L  Z+Q6 ;                  (retract)
35 Q200 = Q200 + Q8 ;      (increment Y position)
36 ; [...] !
37 END PGM shaper6 MM 
