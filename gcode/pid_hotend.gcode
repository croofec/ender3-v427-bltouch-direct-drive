; Hotend PID autotune - takes ~5-8 min, DO NOT leave the printer unattended
M117 PID autotune...
M106 S255          ; part cooling fan 100% (same as while printing)
M303 E0 S210 C8 U1 ; autotune: hotend, 210C, 8 cycles, apply result
M107               ; fan off
M104 S0            ; heater off
M500               ; save
M117 PID saved
