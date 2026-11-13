# Ender 3 (płyta 4.2.7) + BLTouch + direct drive: Marlin 2.1.2.5

Gotowy firmware Marlin dla **Creality Ender 3** z cichą płytą **4.2.7**, czujnikiem **BLTouch**
(5-pinowe złącze na płycie) i przeróbką na **direct drive** z bumperem
([Thingiverse 3816051](https://www.thingiverse.com/thing:3816051)).

*English: Marlin 2.1.2.5 build for Ender 3 / Creality 4.2.7 board / BLTouch on the 5-pin port,
with X travel reduced to 204 mm and Z to 210 mm after a direct-drive conversion with a carriage bumper.*

## Problem, który to rozwiązuje

Po przeróbce na direct drive i zamontowaniu bumpera:

- karetka X kończy ruch wcześniej, w tym przypadku dotyka przy **X 206** zamiast przy 235,
- zasięg Z spadł o około 40 mm,
- stockowy firmware Creality (Marlin 2.0.6) nadal myśli, że ma pełny zakres. Podczas `G29` głowica
  wjeżdża w bumper, silnik terkocze i gubi kroki, a kolejne punkty pomiaru i cała siatka są
  bez sensu.

## Co zmieniono względem przykładowej konfiguracji

Baza: [MarlinFirmware/Configurations `release-2.1.2.5`](https://github.com/MarlinFirmware/Configurations/tree/release-2.1.2.5/config/examples/Creality/Ender-3/CrealityV427)
→ `Creality/Ender-3/CrealityV427`.

| Ustawienie | Wartość | Po co |
|---|---|---|
| `X_BED_SIZE` / `X_MAX_POS` | **204** (było 235) | bumper: dotyk przy 206, 2 mm zapasu |
| `Z_MAX_POS` | **210** (było 250) | mniejszy zasięg Z po przeróbce |
| `BLTOUCH` | włączone | sonda na 5-pinowym złączu (pin PB1) |
| `Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN` | wyłączone | sonda nie siedzi w gnieździe krańcówki Z |
| `USE_PROBE_FOR_Z_HOMING` + `Z_SAFE_HOMING` | włączone | homing Z sondą na środku stołu |
| `NOZZLE_TO_PROBE_OFFSET` | `{ -45, 0, 0 }` | sonda 45 mm na lewo od dyszy |
| `AUTO_BED_LEVELING_BILINEAR` | siatka **5×5** | |
| `LCD_BED_LEVELING` | włączone | poziomowanie z menu |
| `PROBE_OFFSET_WIZARD` | włączone | kreator Z-offsetu w menu |
| `BABYSTEP_ZPROBE_OFFSET` | włączone | babystep od razu zmienia Z-offset |
| `Z_MIN_PROBE_REPEATABILITY_TEST` | włączone | `M48` |
| `DEFAULT_AXIS_STEPS_PER_UNIT` E | 92.6 | |

Dokładne zmiany są w [`config/Configuration.h.diff`](config/Configuration.h.diff) i
[`config/Configuration_adv.h.diff`](config/Configuration_adv.h.diff). Pełne pliki leżą w [`config/`](config/).

> **Twoja drukarka może mieć inne wymiary.** Sprawdź, gdzie *twoja* karetka dotyka bumpera:
> *Motion → Move Axis → X*, przesuwaj po 1 mm. Jeśli wychodzi inaczej niż 206, przekompiluj
> firmware ze swoją wartością (niżej jest instrukcja). Za duży `X_BED_SIZE` = znowu uderzanie w bumper.

## Wgrywanie

1. Karta SD w FAT32, w głównym katalogu **tylko** plik `firmware/firmware-*.bin`.
   Płyta 4.2.7 wymaga innej nazwy pliku przy każdym flashu, a data w nazwie to załatwia.
2. Wyłącz drukarkę, włóż kartę, włącz. Ekran jest czarny przez 10–30 s.
3. Na pytanie o EEPROM wybierz **Reset**.
4. Wgraj swoje ustawienia, na przykład [`gcode/po_flashu.gcode`](gcode/po_flashu.gcode)
   z **twoimi** E-steps (odczytaj je `M503` przed flashem).
5. **Zrób kalibrację PID hotendu**: [`gcode/pid_hotend.gcode`](gcode/pid_hotend.gcode) (5–8 min).
6. Ustaw Z-offset: *Configuration → Probe Offsets → Z Probe Wizard* → *Store Settings*.
7. Cura → ustawienia maszyny: **szerokość 204, wysokość 210**.

Start G-code dla Cury:
- [`gcode/start_gcode_cura.gcode`](gcode/start_gcode_cura.gcode): `G29` przed każdym wydrukiem (+1,5–2 min),
- [`gcode/start_gcode_cura_fast.gcode`](gcode/start_gcode_cura_fast.gcode): `M420 S1`, wczytuje zapisaną siatkę
  bez pomiaru. Nową siatkę rób (`G29` + `M500`) po kręceniu pokrętłami stołu albo raz na kilka tygodni.

## Ustawienia Cury po przejściu na direct drive

**Preferences → Printers → Machine Settings:** Width (X) **204**, Depth (Y) **235**, Height (Z) **210**.

Retrakcja z bowdena (5–6 mm) jest dla direct drive za duża:

| Ustawienie | PLA / PETG | TPU 93A |
|---|---|---|
| Printing Temperature | wg producenta | 225–235°C |
| Build Plate Temperature | 60 / 75°C | 50°C |
| Print Speed | 50–60 mm/s | 20–30 mm/s |
| Initial Layer Speed | 20 mm/s | 15 mm/s |
| Retraction Distance | ~1 mm | 0,8–1 mm |
| Retraction Speed | 35–40 mm/s | 20–25 mm/s |
| Combing Mode | Not on Outer Surface | Not on Outer Surface |
| Fan Speed | 100% / 50% | 30–50% |

TPU: poluzuj trochę docisk ekstrudera, susz filament (50°C, 4–6 h), na PEI nie używaj kleju.

## Uwagi z uruchamiania

- **`Error:Probing Failed` zaraz po uderzeniu w bumper:** BLTouch był w alarmie (miga na czerwono).
  Pomaga `M280 P0 S160` (reset alarmu) albo restart drukarki.
- **`Heating Failed E1`, dysza staje na ~220°C:** to przez PID przeniesiony ze starego firmware
  Creality (`M301 P10.30 I0.53 D49.80`). Na Marlinie 2.1 jest za słaby: blisko celu grzałka
  dostaje ~30% mocy. Po `M303 E0 S210 C8 U1` (z wentylatorem na 100%) wyszło `P27.80 I2.59 D74.51`
  i dysza trzyma 228°C ±1°C.
- **Duży przechył lewo–prawo** (u mnie ~3,5 mm przy prawie płaskim przód–tył): cięższa głowica
  direct drive potrafi przechylić belkę X, bo śruba Z jest tylko po lewej. Zgrubnie popraw to
  pokrętłami stołu albo mimośrodem prawego wózka belki X. Resztę skompensuje siatka. Przy dużym
  przechyle warto wyłączyć fade: `M420 S1 Z0` + `M500`.
- Najdalszy punkt pomiaru po prawej to X 159 (204 − 45 offsetu sondy). Dalej siatka jest ekstrapolowana.
- `M304` (PID stołu) i `M413` (wznawianie po zaniku prądu) są w tej konfiguracji wyłączone.

## Samodzielna kompilacja

```bash
git clone -b 2.1.2.5 https://github.com/MarlinFirmware/Marlin.git
cp config/Configuration.h config/Configuration_adv.h Marlin/Marlin/
cd Marlin
# opcjonalnie: popraw X_BED_SIZE / Z_MAX_POS / NOZZLE_TO_PROBE_OFFSET
pio run -e STM32F103RE_creality
# wynik: .pio/build/STM32F103RE_creality/firmware-*.bin
```

## Licencja

Marlin jest na licencji GPL-3.0 (plik [LICENSE](LICENSE)). Kod źródłowy Marlina:
<https://github.com/MarlinFirmware/Marlin/tree/2.1.2.5>.
Konfiguracja w tym repo to pochodna przykładów z MarlinFirmware/Configurations.

Używasz na własne ryzyko. Przed pierwszym `G29` stój przy drukarce.
