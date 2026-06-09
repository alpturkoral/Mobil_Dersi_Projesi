import 'package:hive_flutter/hive_flutter.dart';
import '../models/city.dart';

/// Hive NoSQL veritabanı yardımcı sınıfı
class DbHelper {
  static const String _boxName = 'favorites'; // Hive kutu (tablo) adı

  /// Hive veritabanını başlatır ve favori şehirler kutusunu açar
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  /// Favori şehirler kutusuna erişim sağlayan getter
  static Box get _box => Hive.box(_boxName);

  /// Yeni bir şehri favori listesine ekleme
  static Future<void> addFavorite(City city) async {
    if (!isFavorite(city)) {
      await _box.add(city.toMap());
    }
  }

  /// Bir şehri favori listesinden silme
  static Future<void> removeFavorite(City city) async {
    final keys = _box.keys.toList();
    for (var key in keys) {
      final map = _box.get(key) as Map;
      final saved = City.fromMap(map);
      // Enlem ve boylam eşleşmesi ile aynı şehri bul
      if (saved.latitude == city.latitude &&
          saved.longitude == city.longitude) {
        await _box.delete(key);
        break;
      }
    }
  }

  /// Veritabanındaki tüm favori şehirleri liste olarak döner
  static List<City> getFavorites() {
    return _box.values
        .map((item) => City.fromMap(item as Map))
        .toList();
  }

  /// Bir şehrin favori listesinde kayıtlı olup olmadığını kontrol eder
  static bool isFavorite(City city) {
    return _box.values.any((item) {
      final saved = City.fromMap(item as Map);
      return saved.latitude == city.latitude &&
          saved.longitude == city.longitude;
    });
  }
}
