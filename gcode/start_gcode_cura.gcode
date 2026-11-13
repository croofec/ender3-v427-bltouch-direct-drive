; Ender 3 Custom Start G-code (Cura) - probes a fresh mesh every print
G92 E0 ; Reset extruder
G28 ; Home all axes (Z homes with BLTouch at bed center)
G29 ; Probe new 5x5 mesh
G1 Z2.0 F3000 ; Lift Z
G1 X0.1 Y20 Z0.3 F5000.0 ; Move to start position
G1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw first line
G1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to the side
G1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw second line
G92 E0 ; Reset extruder
G1 Z2.0 F3000 ; Lift Z
G1 X5 Y20 Z0.3 F5000.0 ; Move over to prevent blob squish
