; Ender 3 Custom Start G-code (Cura)
G92 E0 ; Reset Extruder
G28 ; Home all axes (Z homing przez BLTouch na srodku stolu)
G29 ; Nowa siatka 5x5
G1 Z2.0 F3000 ; Podniesienie Z
G1 X0.1 Y20 Z0.3 F5000.0 ; Pozycja startowa
G1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Pierwsza linia
G1 X0.4 Y200.0 Z0.3 F5000.0 ; Przesuniecie w bok
G1 X0.4 Y20 Z0.3 F1500.0 E30 ; Druga linia
G92 E0 ; Reset Extruder
G1 Z2.0 F3000 ; Podniesienie Z
G1 X5 Y20 Z0.3 F5000.0 ; Odjazd zeby uniknac kleksa
