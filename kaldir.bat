@echo off
reg delete "HKCU\Software\Classes\hbyspno" /f >nul 2>nul
rmdir /S /Q "%LOCALAPPDATA%\HbysPNo" 2>nul
del "%USERPROFILE%\Desktop\HBYS P.No Ayar.lnk" 2>nul
echo HBYS P.No Yardimcisi kaldirildi.
pause
