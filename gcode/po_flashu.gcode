; Uruchom RAZ po wgraniu firmware (po "Reset" EEPROM)
; E-steps sa z mojej drukarki - podmien na swoje (M503 przed flashem)
M502                       ; ustawienia domyslne z firmware
M92 E92.60                 ; E-steps
; NIE przenos PID ze starego firmware Creality - uruchom gcode/pid_hotend.gcode
M851 X-45 Y0 Z-0.41        ; offset sondy - Z ustaw sam (Z Probe Wizard)
M500                       ; zapis
M117 Ustawienia zapisane
