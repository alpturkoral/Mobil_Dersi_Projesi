# 🌤️ Hava Durumu Uygulaması

Mobil Programlama dersi kapsamında **Flutter** ile geliştirilmiş, modern tasarıma sahip bir hava durumu uygulamasıdır.

## 📱 Uygulama Özellikleri

- 🔍 **Şehir Arama** — Dünya genelinde herhangi bir şehri arayabilirsiniz
- 🌡️ **Anlık Hava Durumu** — Sıcaklık, nem oranı ve rüzgar hızı bilgileri
- 📅 **7 Günlük Tahmin** — Haftalık hava durumu tahmini
- ⭐ **Favori Şehirler** — Sık kullandığınız şehirleri kaydedin
- 🎨 **Modern Tasarım** — Sarı/turuncu temalı, kullanıcı dostu arayüz

## 🛠️ Kullanılan Teknolojiler

| Teknoloji | Kullanım Amacı |
|---|---|
| **Flutter** | Cross-platform mobil uygulama geliştirme |
| **Dart** | Programlama dili |
| **Provider** | State Management (Durum Yönetimi) |
| **Hive** | Yerel NoSQL veritabanı (Favori şehirler) |
| **HTTP** | REST API istekleri |
| **Google Fonts** | Modern yazı tipleri (Poppins) |

## 🌐 API

Uygulama, **Open-Meteo API** kullanmaktadır. Tamamen ücretsizdir ve API Key gerektirmez.

- **Geocoding API** — Şehir arama (isimden koordinata dönüşüm)
- **Forecast API** — Anlık hava durumu ve 7 günlük tahmin

## 📂 Proje Yapısı

```
lib/
├── main.dart                  # Uygulama giriş noktası, tema ve navigasyon
├── models/
│   ├── city.dart              # Şehir veri modeli
│   └── weather.dart           # Hava durumu veri modeli
├── utils/
│   └── weather_utils.dart     # Hava kodu → Emoji ve açıklama dönüştürücü
├── services/
│   ├── api_service.dart       # Open-Meteo API bağlantıları
│   └── db_helper.dart         # Hive veritabanı CRUD işlemleri
├── providers/
│   └── weather_provider.dart  # Durum yönetimi (ChangeNotifier)
└── screens/
    ├── home_screen.dart       # Ana Ekran (hava durumu görüntüleme)
    ├── search_screen.dart     # Şehir Arama Ekranı
    └── favorites_screen.dart  # Favori Şehirler Ekranı
```

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK (3.x veya üzeri)
- Android Studio (Android emülatör için) veya Chrome (web için)

### Adımlar

```bash
# 1. Projeyi klonlayın
git clone https://github.com/alpturkoral/Mobil_Dersi_Projesi.git

# 2. Proje dizinine gidin
cd Mobil_Dersi_Projesi

# 3. Bağımlılıkları yükleyin
flutter pub get

# 4a. Chrome'da çalıştırın
flutter run -d chrome

# 4b. Android emülatörde çalıştırın
flutter run
```

## 📋 Ders Gereksinimleri Karşılama

| Gereksinim | Durum |
|---|---|
| En az 3 farklı ekran | ✅ Ana Ekran, Arama Ekranı, Favoriler Ekranı |
| Veritabanı kullanımı | ✅ Hive NoSQL (favori şehirler CRUD) |
| API / Dış servis entegrasyonu | ✅ Open-Meteo Hava Durumu API |
| Modern UX/UI tasarımı | ✅ Material 3, turuncu/sarı tema, gradyan kartlar |
| Kod açıklamaları | ✅ Tüm fonksiyonlarda Türkçe yorum satırları |
