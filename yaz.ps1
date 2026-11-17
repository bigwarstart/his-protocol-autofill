# Tarayıcıdan "hbyspno:1106769" bağlantısıyla çağrılır; numarayı HBYS'deki P.No kutusuna yazar.
param([string]$Adres = '')
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'ortak.ps1')

# Güvenlik: adresten yalnızca rakamlar alınır
$no = ($Adres -replace '[^0-9]', '')
if (-not $no -or $no.Length -gt 12) { exit }

if (-not (Test-Path $Script:AyarYol)) {
    Mesaj "Ayar yapılmamış.`n`nBaşlat menüsündeki / masaüstündeki 'HBYS P.No Ayar' kısayolunu çalıştırıp P.No kutusunun yerini gösterin." 'Warning'
    exit
}
$ayar = Get-Content $Script:AyarYol -Raw -Encoding UTF8 | ConvertFrom-Json

$p = HBYSPenceresi $ayar.pencere
if (-not $p) {
    Mesaj "HBYS açık değil.`n`nHBYS'yi açıp Hasta Dosyası ekranına girin, sonra tekrar deneyin." 'Warning'
    exit
}
if ($p.MainWindowTitle -notlike "*$Script:EkranBasligi*") {
    Mesaj "HBYS'de 'Hasta Dosyası' ekranı açık değil.`n`nÖnce Hasta Dosyası ekranını açın, sonra tekrar deneyin." 'Warning'
    exit
}

$h = $p.MainWindowHandle
OneGetir $h

$r = New-Object W32+RECT
[void][W32]::GetWindowRect($h, [ref]$r)
$eski = New-Object W32+POINT
[void][W32]::GetCursorPos([ref]$eski)

# P.No kutusuna tıkla
[void][W32]::SetCursorPos($r.Left + [int]$ayar.dx, $r.Top + [int]$ayar.dy)
Start-Sleep -Milliseconds 60
[W32]::mouse_event(0x02, 0, 0, 0, [UIntPtr]::Zero)   # sol tuş bas
[W32]::mouse_event(0x04, 0, 0, 0, [UIntPtr]::Zero)   # sol tuş bırak
Start-Sleep -Milliseconds 150

# Kutudaki eski numarayı seç, yenisini yaz
[System.Windows.Forms.SendKeys]::SendWait('{HOME}+{END}')
[System.Windows.Forms.SendKeys]::SendWait($no)
if ($ayar.enter) { [System.Windows.Forms.SendKeys]::SendWait('{ENTER}') }

# Fareyi eski yerine geri koy
[void][W32]::SetCursorPos($eski.X, $eski.Y)
