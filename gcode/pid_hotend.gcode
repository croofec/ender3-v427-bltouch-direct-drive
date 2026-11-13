; Kalibracja PID hotendu - trwa ok. 5-8 min, NIE odchodz od drukarki
M117 PID - chlodzenie...
M106 S255          ; wentylator wydruku na 100% (jak podczas druku)
M303 E0 S210 C8 U1 ; autotune: hotend, 210C, 8 cykli, uzyj wyniku
M107               ; wentylator wylaczony
M104 S0            ; grzanie off
M500               ; zapis
M117 PID zapisany
