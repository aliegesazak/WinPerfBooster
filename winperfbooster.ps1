# WinPerfBooster Script
Write-Host "- WinPerfBooster Başlıyor -" -ForegroundColor Cyan

function Confirm-Action {
    param ([string]$Message)
    $response = Read-Host "$Message (Y/N)"
    if ($response -match "^[Yy]$") { return $true }
    return $false
}

# TEMP, PREFETCH, RECENT Temizliği
if (Confirm-Action "🗑️ Geçici dosyaları temizlemek ister misiniz?") {
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Geçici dosyalar temizlendi!" -ForegroundColor Green
}

# DNS ve Ağ Önbellek Temizliği
if (Confirm-Action "🌐 DNS ve internet önbelleğini temizlemek ister misiniz?") {
    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew
    netsh int ip reset
    netsh winsock reset
    netsh advfirewall reset
    Write-Host "- DNS ve ağ önbelleği temizlendi!" -ForegroundColor Green
}

# RAM Optimizasyonu
if (Confirm-Action "🧠 RAM temizlemek ister misiniz?") {
    Write-Host "RAM temizleniyor..." -ForegroundColor Green
    [System.GC]::Collect()
    Write-Host "- RAM temizlendi!" -ForegroundColor Green
}

# SSD TRIM & HDD Disk Optimizasyonu
if (Confirm-Action "💾 Disk optimizasyonu yapmak ister misiniz?") {
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Write-Host "- Disk optimizasyonu tamamlandı!" -ForegroundColor Green
}

# Windows Güncelleme Geçmişini Temizleme
if (Confirm-Action "🔄 Windows güncelleme geçmişini temizlemek ister misiniz?") {
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Windows güncelleme geçmişi temizlendi!" -ForegroundColor Green
}

# Eski Windows Güncellemelerini Temizleme
if (Confirm-Action "🧹 Eski Windows güncellemelerini kaldırmak ister misiniz? (Daha fazla boş alan için önerilir)") {
    Dism /Online /Cleanup-Image /StartComponentCleanup
    Write-Host "- Eski Windows güncellemeleri temizlendi!" -ForegroundColor Green
}

# Gereksiz Windows Hizmetlerini Kapatma
if (Confirm-Action "⚙️ Gereksiz Windows hizmetlerini kapatmak ister misiniz?") {
    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled
    Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "dmwappushservice" -StartupType Disabled
    Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "WSearch" -StartupType Disabled
    Write-Host "- Gereksiz Windows hizmetleri devre dışı bırakıldı!" -ForegroundColor Green
}

# Güç Planını En Yüksek Performansa Alma
if (Confirm-Action "⚡ Güç planını en yüksek performansa almak ister misiniz?") {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Host "- Güç ayarları en yüksek performansa alındı!" -ForegroundColor Green
}

# Çöp Kutusunu Boşaltma
if (Confirm-Action "🚮 Çöp kutusunu temizlemek ister misiniz?") {
    Remove-Item -Path "C:\$Recycle.Bin\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Çöp kutusu temizlendi!" -ForegroundColor Green
}

# Gereksiz Başlangıç Programlarını Kapatma
if (Confirm-Action "🛑 Gereksiz başlangıç programlarını devre dışı bırakmak ister misiniz?") {
    Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-Table -AutoSize
    Write-Host "Başlangıç programlarını görmek için yukarıdaki listeye bakabilirsiniz."
    Write-Host "- Lütfen 'Task Manager' üzerinden devre dışı bırakın."
}

Write-Host "- Tüm işlemler tamamlandı! Bilgisayarınız daha hızlı çalışacak!" -ForegroundColor Cyan
