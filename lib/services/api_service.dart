import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/weather.dart';

/// Open-Meteo API ile iletişim kuran servis sınıfı
/// Şehir arama (Geocoding) ve hava durumu verisi çekme işlemlerini yönetir
class ApiService {
  // Open-Meteo API temel URL adresleri
  static const String _geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String _weatherBaseUrl =
      'https://api.open-meteo.com/v1/forecast';


  static Future<List<City>> searchCities(String query) async {
    try {
      // Geocoding API'ye istek gönder
      final uri = Uri.parse(
          '$_geocodingBaseUrl?name=$query&count=5&language=tr&format=json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // API sonuç bulamazsa boş liste döner
        if (data['results'] == null) return [];

        return (data['results'] as List)
            .map((item) => City.fromJson(item))
            .toList();
      } else {
        throw Exception('Şehir arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Şehir arama hatası: $e');
    }
  }

  /// Belirtilen koordinatlara göre hava durumu verisini çeker

  /// Güncel hava durumu + 7 günlük tahmin verisini tek seferde alır
  static Future<Weather> getWeather(double latitude, double longitude) async {
    try {
      // Forecast API'ye istek gönder (güncel + 7 günlük tahmin)
      final uri = Uri.parse(
        '$_weatherBaseUrl?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min'
        '&timezone=auto&forecast_days=7',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception(
            'Hava durumu verisi alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hava durumu hatası: $e');
    }
  }
}
