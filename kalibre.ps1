# P.No kutusunun HBYS penceresindeki yerini öğrenir ve ayar.json dosyasına kaydeder.
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'ortak.ps1')

$baslik = $Script:PencereBasligi
Mesaj ("P.No kutusunun yerini öğreneceğim.`n`n" +
       "1) HBYS'yi açın ve HASTA DOSYASI ekranına girin.`n" +
       "2) Bu pencerede Tamam'a basın.`n" +
       "3) 5 saniye içinde fareyi P.No kutusunun İÇİNE getirin ve kıpırdatmayın.`n`n" +
       "Süre dolunca ayar kaydedilecek.")

for ($i = 5; $i -ge 1; $i--) {
    Write-Host "Fareyi P.No kutusunun içinde tutun... $i"
    Start-Sleep -Seconds 1
}

$p = HBYSPenceresi $baslik
if (-not $p) { Mesaj "HBYS penceresi bulunamadı. HBYS'yi açıp tekrar deneyin." 'Error'; exit 1 }

$h = $p.MainWindowHandle
$r = New-Object W32+RECT
[void][W32]::GetWindowRect($h, [ref]$r)
$c = New-Object W32+POINT
[void][W32]::GetCursorPos([ref]$c)

$dx = $c.X - $r.Left
$dy = $c.Y - $r.Top
if ($dx -lt 0 -or $dy -lt 0 -or $c.X -gt $r.Right -or $c.Y -gt $r.Bottom) {
    Mesaj "Fare HBYS penceresinin dışındaydı. Lütfen tekrar deneyin." 'Error'; exit 1
}

$cevap = [System.Windows.Forms.MessageBox]::Show(
    "Numara yazıldıktan sonra ENTER'a da basılsın mı?`n`n(Hasta dosyasının kendiliğinden açılması için genelde EVET seçilir.)",
    'HBYS P.No Yardımcısı', 'YesNo', 'Question')

$ayar = [ordered]@{
    pencere = $baslik
    dx      = $dx
    dy      = $dy
    enter   = ($cevap -eq 'Yes')
}
$ayar | ConvertTo-Json | Set-Content -Path $Script:AyarYol -Encoding UTF8

Mesaj ("Ayar kaydedildi.`n`nP.No kutusu: pencerenin sol üstünden $dx, $dy piksel.`n`n" +
       "Şimdi ornek.html dosyasını açıp bir protokol numarasına tıklayarak deneyebilirsiniz.")
