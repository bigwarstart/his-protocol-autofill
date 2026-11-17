@echo off
chcp 65001 >nul
setlocal
set "HEDEF=%LOCALAPPDATA%\HbysPNo"
echo === HBYS P.No Yardimcisi kurulumu ===
echo.
if not exist "%HEDEF%" mkdir "%HEDEF%"
copy /Y "%~dp0ortak.ps1"   "%HEDEF%\" >nul
copy /Y "%~dp0yaz.ps1"     "%HEDEF%\" >nul
copy /Y "%~dp0kalibre.ps1" "%HEDEF%\" >nul

rem --- hbyspno: baglantisini bu bilgisayardaki kullaniciya kaydet (yonetici yetkisi gerekmez)
reg add "HKCU\Software\Classes\hbyspno" /ve /d "URL:HBYS PNo" /f >nul
reg add "HKCU\Software\Classes\hbyspno" /v "URL Protocol" /d "" /f >nul
reg add "HKCU\Software\Classes\hbyspno\shell\open\command" /ve /d "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%HEDEF%\yaz.ps1\" \"%%1\"" /f >nul

rem --- Masaustune ayar kisayolu
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\HBYS P.No Ayar.lnk');$s.TargetPath='powershell.exe';$s.Arguments='-NoProfile -ExecutionPolicy Bypass -File \"%HEDEF%\kalibre.ps1\"';$s.IconLocation='shell32.dll,22';$s.Save()"

echo Kurulum tamam.
echo.
echo Simdi P.No kutusunun yerini ogretecegiz.
echo HBYS'yi acip HASTA DOSYASI ekranina girin, sonra bir tusa basin.
pause >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%HEDEF%\kalibre.ps1"
echo.
echo Bitti. Ayar daha sonra masaustundeki "HBYS P.No Ayar" kisayoluyla tekrarlanabilir.
pause
