/// Şehir bilgilerini tutan model sınıfı
/// API'den gelen şehir verilerini ve veritabanına kayıt işlemlerini yönetir
class City {
  final String name; // Şehir adı
  final String country; // Ülke adı
  final double latitude; // Enlem koordinatı
  final double longitude; // Boylam koordinatı

  City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  /// Open-Meteo Geocoding API'den gelen JSON verisini City nesnesine dönüştürür
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// City nesnesini Hive veritabanına kaydetmek için Map formatına dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Hive veritabanından okunan Map verisini City nesnesine dönüştürür
  factory City.fromMap(Map<dynamic, dynamic> map) {
    return City(
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  /// İki şehrin aynı olup olmadığını koordinatlarına göre kontrol eder
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
