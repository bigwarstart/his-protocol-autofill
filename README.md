# ⚡ HIS Protocol Autofill

**Click a protocol number in any web page, and it's typed into the hospital information system.**

A tiny Windows helper that connects web-based hospital reports with a desktop hospital information system (HBYS). Staff click a protocol number in the browser; the helper brings the HBYS window to the front, types the number into the right field and presses Enter.

No more copy, switch window, click the box, paste, Enter, dozens of times a day.

> 🇹🇷 Türkçe kurulum ve kullanım aşağıda.

---

## How it works

1. `kurulum.bat` registers a custom URL scheme, **`hbyspno:`**, for the current Windows user. No admin rights are needed.
2. A web page links protocol numbers like this:
   ```html
   <a href="hbyspno:1234567">1234567</a>
   ```
3. On click, Windows runs `yaz.ps1`, which:
   - finds the HBYS window by its title and brings it to the front
   - clicks the protocol number field (its position is learned once during calibration)
   - types the number and optionally presses Enter
   - puts the mouse back where it was

A one-time **calibration** (`kalibre.ps1`) records where the field is, relative to the HBYS window, so it keeps working when the window is moved.

## Security by design

- **Strict input filtering.** Only digits are taken from the link (max. 12). Nothing else from the URL ever reaches the keyboard or the shell.
- **Per-user install.** Writes only to `HKCU` and `%LOCALAPPDATA%`. No admin rights, no system-wide changes.
- **Safety checks.** It does nothing if the HBYS isn't open or the expected screen isn't active.
- **Clean uninstall.** `kaldir.bat` removes the URL scheme, files and desktop shortcut.

## Setup

1. Set your HBYS window titles at the top of `ortak.ps1`:
   ```powershell
   $Script:PencereBasligi = 'HBYS'          # word in the HBYS main window title
   $Script:EkranBasligi   = 'Hasta dosyas'  # word in the patient file screen title
   ```
2. Run `kurulum.bat` and follow the calibration prompt.
3. Open `ornek.html` and click a number to test.

## Tech

`PowerShell` · `Win32 API (user32.dll)` · `Windows URL protocol handlers` · `Batch`

---

## 🇹🇷 Türkçe

**Kurulum (her bilgisayarda bir kez):**
1. `ortak.ps1` dosyasının başındaki pencere başlıklarını kendi HBYS'nize göre düzenleyin.
2. `kurulum.bat` dosyasına çift tıklayın. Yönetici yetkisi gerekmez.
3. İstendiğinde HBYS'yi açıp hasta dosyası ekranına girin. Tamam'a basın ve 5 saniye içinde fareyi Protokol No kutusunun içine getirin.
4. `ornek.html` dosyasını açıp bir numaraya tıklayarak deneyin.

**Kaldırmak için:** `kaldir.bat`

## Related projects

- [surgical-safety-checklist-audit](https://github.com/bigwarstart/surgical-safety-checklist-audit): SKS safe surgery indicator audit
- [lens-stock-expiry-tracker](https://github.com/bigwarstart/lens-stock-expiry-tracker): intraocular lens stock & expiry tracking
- [sks-medical-records-reports](https://github.com/bigwarstart/sks-medical-records-reports): SKS medical records & archive reports
- [clinic-intranet](https://github.com/bigwarstart/clinic-intranet): secure hospital intranet

## Author

**Fatih Koçan**: IT Manager with 25+ years in hospital IT, Web3 developer & ambassador

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fatih_Koçan-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/fatihkocan-3bbb49349/)
[![GitHub](https://img.shields.io/badge/GitHub-bigwarstart-181717?style=for-the-badge&logo=github)](https://github.com/bigwarstart)
