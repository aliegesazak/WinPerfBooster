# WinPerfBooster - Sistem Optimizasyon Scripti

WinPerfBooster, Windows işletim sistemini optimize etmek için kullanılan bir PowerShell scriptidir. Bu script, bilgisayarınızda bir dizi bakım ve temizlik işlemi yaparak sistem performansını artırır.

## Özellikler

- :computer: **Microsoft C++ Redistribute 2005'ten itibaren kurulumu**
- 🧹 **Temp, Prefetch ve %Temp% klasörlerinin temizliği**
- 🌐 **DNS, Winsock ve ağ önbelleği temizliği**
- 🧠 **RAM temizliği (Boşta çalışan belleklerin temizlenmesi)**
- 💾 **Disk optimizasyonu (SSD TRIM, HDD defrag)**
- 🕒 **Windows güncellemeleri geçmişinin temizliği**
- 🕰️ **Eski Windows güncellemelerinin temizliği**
- ⚙️ **Gereksiz Windows hizmetlerini devre dışı bırakma**
- ⚡ **En yüksek performans gücü planına geçiş**
- 🗑️ **Çöp kutusunun temizlenmesi**
- 🚫 **Gereksiz başlangıç programlarının kapatılması**

## Kullanım

### **Adım 1: Scripti İndirin ve Çalıştırın**

1. PowerShell'i **Yönetici** olarak açın.
2. Aşağıdaki komutu çalıştırın:

   ```powershell
   irm "https://aliegesazak.com/winperfbooster/" | iex
   ```

   - Bu komut, **WinPerfBooster** scriptini **aliegesazak.com** üzerinden çeker ve çalıştırır.

### **Alternatif Yöntem (GitHub)**

Eğer yukarıdaki yöntem çalışmazsa, scripti GitHub üzerinden de indirebilirsiniz. GitHub linkine aşağıdaki komutu kullanarak ulaşabilirsiniz:

```powershell
irm "https://github.com/aliegesazak/WinPerfBooster/raw/main/winperfbooster.ps1" | iex
```

!!! warning
    **Dikkat:** Eğer rar dosyasını indirecek link aktif değilse, linki şu link ile değiştirebilirsiniz:

    [https://web.archive.org/web/20250302151855/https://aliegesazak.com/vcredists.rar](https://web.archive.org/web/20250302151855/https://aliegesazak.com/vcredists.rar)


### **Kullanıcı Onayları**

Her işlem başlamadan önce, script her bir adım için kullanıcıdan onay isteyecektir. Kullanıcı onay verdikçe işlemler devam edecektir.

## Nasıl Çalışır?

WinPerfBooster scripti, kullanıcı bilgisayarındaki gereksiz dosyaları, geçmişi ve geçici verileri temizleyerek sistemin hızını artırmayı amaçlar. Ayrıca, bazı hizmetleri devre dışı bırakır ve bilgisayarın performansını artıran ayarları yapar.

### **Önemli Notlar:**
- Scripti çalıştırmadan önce **önceden yedekleme yapmanız önerilir**.
- Bazı işlemler bilgisayarınızın hızına göre birkaç dakika sürebilir.
- PowerShell'i **Yönetici olarak çalıştırdığınızdan** emin olun.
- Scriptin çalışabilmesi için **İnternet bağlantınız** gereklidir.

## Lisans

Bu proje, **MIT Lisansı** altında lisanslanmıştır. Daha fazla bilgi için [LICENSE](LICENSE) dosyasına bakabilirsiniz.
