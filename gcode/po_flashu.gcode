; Uruchom RAZ po wgraniu firmware (po "Reset" EEPROM)
; Wartosci PID / E-steps sa z mojej drukarki - podmien na swoje (M503 przed flashem)
M502                       ; ustawienia domyslne z firmware
M92 E92.60                 ; E-steps
M301 P10.30 I0.53 D49.80   ; PID hotendu
M851 X-45 Y0 Z-0.41        ; offset sondy - Z ustaw sam (Z Probe Wizard)
M500                       ; zapis
M117 Ustawienia zapisane
