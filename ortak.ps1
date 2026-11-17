# HBYS Protokol No yardımcısı - ortak fonksiyonlar
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class W32 {
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
    [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT p);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
    [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
    [DllImport("user32.dll")] public static extern void mouse_event(uint flags, int dx, int dy, uint data, UIntPtr extra);
}
"@
[void][W32]::SetProcessDPIAware()

# ---------------------------------------------------------------------------
# AYARLAR: kendi HBYS programınıza göre değiştirin
#   PencereBasligi : HBYS ana penceresinin başlığında geçen kelime
#   EkranBasligi   : protokol no kutusunun bulunduğu ekranın pencere başlığında geçen kelime
# ---------------------------------------------------------------------------
$Script:PencereBasligi = 'HBYS'
$Script:EkranBasligi   = 'Hasta dosyas'

$Script:Klasor  = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:AyarYol = Join-Path $Script:Klasor 'ayar.json'

function Mesaj([string]$metin, [string]$tur = 'Information') {
    [void][System.Windows.Forms.MessageBox]::Show($metin, 'HBYS P.No Yardımcısı', 'OK', $tur)
}

# HBYS ana penceresini bulur. Birden fazla varsa "Hasta dosyası" açık olanı seçer.
function HBYSPenceresi([string]$baslik) {
    $adaylar = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -like "*$baslik*" }
    if (-not $adaylar) { return $null }
    $tercih = $adaylar | Where-Object { $_.MainWindowTitle -like "*$Script:EkranBasligi*" } | Select-Object -First 1
    if ($tercih) { return $tercih }
    return ($adaylar | Select-Object -First 1)
}

function OneGetir([IntPtr]$h) {
    if ([W32]::IsIconic($h)) { [void][W32]::ShowWindow($h, 9) }   # simge durumundaysa geri getir
    # Windows'un öne getirme kısıtını aşmak için ALT tuşuna kısa bir basış
    [W32]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero)
    [void][W32]::SetForegroundWindow($h)
    [W32]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 250
}
