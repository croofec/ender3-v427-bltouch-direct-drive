; Run ONCE after flashing (after choosing "Reset" on the EEPROM prompt)
; E-steps are from my printer - replace with yours (run M503 before flashing)
M502                       ; load firmware defaults
M92 E92.60                 ; E-steps
; Do NOT carry over PID values from stock Creality firmware - run gcode/pid_hotend.gcode instead
M851 X-45 Y0 Z-0.41        ; probe offset - set Z yourself (Z Probe Wizard)
M500                       ; save
M117 Settings saved
