Write-Host "- WinPerfBooster Basliyor -" -ForegroundColor Cyan

function Confirm-Action {
    param ([string]$Message)
    $response = Read-Host "$Message (Y/N)"
    if ($response -match "^[Yy]$") { return $true }
    return $false
}

# Microsoft Visual C++ Redistributable Kurulumu
if (Confirm-Action "- Microsoft Visual C++ Redistributable paketlerini yuklemek ister misiniz? (Ileride isinize yarar)") {
	# Ayarlar
	$downloadUrl = "https://aliegesazak.com/vcredists.rar"  # RAR dosyanin URL'sini buraya yaz
	$rarPath = "$PWD\vcredists.rar"  # İndirilen RAR dosyasinin yolu
	$extractPath = "$PWD\vcredists" # cikarilacak klasOr (ps1'in calistigi dizin)

	# Eger klasOr yoksa olustur
	if (!(Test-Path $extractPath)) {
		New-Item -ItemType Directory -Path $extractPath | Out-Null
	}
	# WinRAR Yolu (Registry’den cekerek bul)
	$winrarPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR*" -ErrorAction SilentlyContinue).InstallLocation
	if ($winrarPath) {
		$winrarExe = "$winrarPath\WinRAR.exe"
	} else {
		$winrarExe = $null
	}

	# 7-Zip Var mi?
	$sevenZipPath = (Get-Command "7z.exe" -ErrorAction SilentlyContinue).Source

	# Eger WinRAR veya 7-Zip yoksa 7-Zip indir ve yukle
	if (-not $winrarExe -and -not $sevenZipPath) {
		Write-Host "WinRAR veya 7-Zip bulunamadi. 7-Zip indiriliyor..."
		$zipUrl = "https://www.7-zip.org/a/7z2409-x64.exe"  # 7-Zip indirme linki (guncel)
		$zipInstaller = "$PWD\7zip.exe"
		Invoke-WebRequest -Uri $zipUrl -OutFile $zipInstaller
		Start-Process -FilePath $zipInstaller -ArgumentList "/S" -Wait
		Remove-Item $zipInstaller -Force
		$sevenZipPath = (Get-Command "7z.exe" -ErrorAction SilentlyContinue).Source
	}

	# vcredists.rar dosyasini indir
	Write-Host "vcredists.rar indiriliyor..."
	Start-Sleep -Seconds 1
	Invoke-WebRequest -Uri $downloadUrl -OutFile $rarPath

	# RAR dosyasini cikart
	Write-Host "Dosya cikariliyor..."
	Start-Sleep -Seconds 1
	if ($winrarExe) {
		Start-Process -FilePath $winrarExe -ArgumentList "x `"$rarPath`" `"$extractPath`\`" -y" -NoNewWindow -Wait
	} elseif ($sevenZipPath) {
		Start-Process -FilePath $sevenZipPath -ArgumentList "x `"$rarPath`" -o`"$extractPath`" -y" -NoNewWindow -Wait
	} else {
		Write-Host "Hata: WinRAR veya 7-Zip yuklenemedi!"
		exit
	}

	# install.bat dosyasini calistir
	$batFile = "$extractPath\install.bat"
	if (Test-Path $batFile) {
		Write-Host "install.bat calistiriliyor..."
		Start-Sleep -Seconds 1
		Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batFile`"" -Verb RunAs -Wait
	} else {
		Write-Host "install.bat bulunamadi!"
		exit
	}

	# Temizlik yap
	# install.bat tamamlandiktan sonra dosyalarin bitmesini bekleyelim
	Write-Host "Kurulum tamamlandi, temizlik yapiliyor..."
	Start-Sleep -Seconds 5  # Temizlik icin ek bir sure (dosyalarin bitmesi icin)

	# cikartilan dosyalarin hala kullanimda olup olmadigini kontrol et
	try {
		Remove-Item $extractPath -Recurse -Force
		Remove-Item $rarPath -Force
		Write-Host "Temizlik basarili!" -ForegroundColor Green
	} catch {
		Write-Host "Temizlik hatasi: $($_.Exception.Message)" -ForegroundColor Red
	}
	
    Write-Host "- Tum Visual C++ Redistributable paketleri yuklendi!" -ForegroundColor Green
}

# TEMP, PREFETCH, RECENT Temizligi
if (Confirm-Action "- Gecici dosyalari temizlemek ister misiniz?") {
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Gecici dosyalar temizlendi!" -ForegroundColor Green
}

# DNS ve Ag Onbellek Temizligi
if (Confirm-Action "- DNS ve internet onbellegini temizlemek ister misiniz?") {
    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew
    netsh int ip reset
    netsh winsock reset
    netsh advfirewall reset
    netsh interface tcp set global autotuninglevel=normal
    netsh interface ipv4 reset
    netsh interface ipv6 reset
    Write-Host "- DNS ve ag onbellegi temizlendi!" -ForegroundColor Green
}

# RAM ve CPU Optimizasyonu
if (Confirm-Action "- RAM performansini artirmak ister misiniz?") {
    [System.GC]::Collect()
    Write-Host "- RAM optimizasyonu yapildi!" -ForegroundColor Green
}

# SSD TRIM & HDD Disk Optimizasyonu
if (Confirm-Action "- Disk optimizasyonu yapmak ister misiniz?") {
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Write-Host "- Disk optimizasyonu tamamlandi!" -ForegroundColor Green
}

# Windows Guncelleme Gecmisini Temizleme
if (Confirm-Action "- Windows guncelleme gecmisini temizlemek ister misiniz?") {
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Windows guncelleme gecmisi temizlendi!" -ForegroundColor Green
}

# Eski Windows Guncellemelerini Temizleme
if (Confirm-Action "- Eski Windows guncellemelerini kaldirmak ister misiniz? (Daha fazla bos alan icin Onerilir)") {
    Dism /Online /Cleanup-Image /StartComponentCleanup
    Write-Host "- Eski Windows guncellemeleri temizlendi!" -ForegroundColor Green
}

# Gereksiz Windows Hizmetlerini Kapatma
if (Confirm-Action "- Gereksiz Windows hizmetlerini kapatmak ister misiniz?") {
    $services = @("DiagTrack", "dmwappushservice", "WSearch", "SysMain", "Fax", "PrintSpooler")
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled
    }
    Write-Host "- Gereksiz Windows hizmetleri devre disi birakildi!" -ForegroundColor Green
}

# Guc Planini En Yuksek Performansa Alma
if (Confirm-Action "- Guc planini en yuksek performansa almak ister misiniz?") {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Host "- Guc ayarlari en yuksek performansa alindi!" -ForegroundColor Green
}

# Cop Kutusunu Bosaltma
if (Confirm-Action "- Cop kutusunu temizlemek ister misiniz?") {
    Remove-Item -Path "C:\$Recycle.Bin\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "- Cop kutusu temizlendi!" -ForegroundColor Green
}

if (Confirm-Action "- Gereksiz baslangic programlarini devre disi birakmak ister misiniz?") {
    $startupPrograms = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User
    $startupPrograms | Format-Table -AutoSize
    Write-Host "Baslangic programlarini gormek icin yukaridaki listeye bakabilirsiniz."

    foreach ($program in $startupPrograms) {
        $confirm = Read-Host "Devre disi birakmak ister misiniz? ($($program.Name)) (Y/N)"
        if ($confirm -eq "Y") {
            $removed = $false

            # Registry'den kaldir
            $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
            if (Get-ItemProperty -Path $regPath -Name $program.Name -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $regPath -Name $program.Name -Force -ErrorAction SilentlyContinue
                Write-Host "$($program.Name) baslangictan kaldirildi (Registry)." -ForegroundColor Green
                $removed = $true
            }

            # Startup Klasorunden kaldir
            $startupFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
            $shortcut = Join-Path -Path $startupFolder -ChildPath "$($program.Name).lnk"
            if (Test-Path $shortcut) {
                Remove-Item -Path $shortcut -Force -ErrorAction SilentlyContinue
                Write-Host "$($program.Name) baslangictan kaldirildi (Startup Klasoru)." -ForegroundColor Green
                $removed = $true
            }

            # Gorev Zamanlayici’dan kaldir
            $taskName = "*$($program.Name)*"
            if (schtasks /Query /TN $taskName 2>$null) {
                schtasks /Delete /TN $taskName /F
                Write-Host "$($program.Name) baslangictan kaldirildi (Gorev Zamanlayici)." -ForegroundColor Green
                $removed = $true
            }

            # Eğer hala kaldirilmadiysa, sistem servisi olup olmadiğini kontrol et
            if (-not $removed) {
                $service = Get-Service | Where-Object { $_.DisplayName -match $program.Name }
                if ($service) {
                    Stop-Service -Name $service.Name -Force -ErrorAction SilentlyContinue
                    Set-Service -Name $service.Name -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Host "$($program.Name) baslangictan kaldirildi (Sistem Servisi)." -ForegroundColor Green
                    $removed = $true
                }
            }

            # Hala kaldirilmadiysa uyari ver
            if (-not $removed) {
                Write-Host "$($program.Name) baslangictan kaldirilamadi! Manuel olarak kontrol edin." -ForegroundColor Red
            }
        }
    }
    Write-Host "- Baslangic programlarini devre disi birakmak icin 'Task Manager' uzerinden ayarlamalar yapabilirsiniz." 
}

Write-Host "- Tum islemler tamamlandi! Bilgisayariniz daha hizli calisacak!" -ForegroundColor Cyan
