Write-Host "- WinPerfBooster Başlıyor -" -ForegroundColor Cyan

function Confirm-Action {
    param ([string]$Message)
    $response = Read-Host "$Message (Y/N)"
    if ($response -match "^[Yy]$") { return $true }
    return $false
}

if (Confirm-Action "- Geçici dosyaları temizlemek ister misiniz?") {
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Geçici dosyalar temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- DNS ve internet önbelleğini temizlemek ister misiniz?") {
    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew
    netsh int ip reset
    netsh winsock reset
    netsh advfirewall reset
    Write-Host "- DNS ve ağ önbelleği temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- RAM temizlemek ister misiniz?") {
    Write-Host "RAM temizleniyor..." -ForegroundColor Green
    [System.GC]::Collect()
    Write-Host "- RAM temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- Disk optimizasyonu yapmak ister misiniz?") {
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Write-Host "- Disk optimizasyonu tamamlandı!" -ForegroundColor Green
}

if (Confirm-Action "- Windows güncelleme geçmişini temizlemek ister misiniz?") {
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Windows güncelleme geçmişi temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- Eski Windows güncellemelerini kaldırmak ister misiniz? (Daha fazla boş alan için önerilir)") {
    Dism /Online /Cleanup-Image /StartComponentCleanup
    Write-Host "- Eski Windows güncellemeleri temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- Gereksiz Windows hizmetlerini kapatmak ister misiniz?") {
    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled
    Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "dmwappushservice" -StartupType Disabled
    Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "WSearch" -StartupType Disabled
    Write-Host "- Gereksiz Windows hizmetleri devre dışı bırakıldı!" -ForegroundColor Green
}

if (Confirm-Action "- Güç planını en yüksek performansa almak ister misiniz?") {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Host "- Güç ayarları en yüksek performansa alındı!" -ForegroundColor Green
}

if (Confirm-Action "- Çöp kutusunu temizlemek ister misiniz?") {
    Remove-Item -Path "C:\$Recycle.Bin\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Çöp kutusu temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- Gereksiz başlangıç programlarını devre dışı bırakmak ister misiniz?") {
    Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-Table -AutoSize
    Write-Host "Başlangıç programlarını görmek için yukarıdaki listeye bakabilirsiniz."
    Write-Host "- Lütfen 'Task Manager' üzerinden devre dışı bırakın."
}

Write-Host "- Tüm işlemler tamamlandı! Bilgisayarınız daha hızlı çalışacak!" -ForegroundColor Cyan
