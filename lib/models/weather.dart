/// Güncel hava durumu bilgilerini tutan model sınıfı
/// Open-Meteo API'den gelen tüm verileri (sıcaklık, nem, rüzgar, tahmin) içerir
class Weather {
  final double temperature; // Güncel sıcaklık
  final int humidity; // Nem oranı
  final double windSpeed; // Rüzgar hızı
  final int weatherCode; // Hava durumu kodu
  final List<DailyForecast> dailyForecast;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.dailyForecast,
  });

  /// Open-Meteo API'den gelen JSON verisini Weather nesnesine dönüştürür

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final daily = json['daily'];

    // 7 günlük tahmin verilerini ayrıştır
    List<DailyForecast> forecasts = [];
    if (daily != null) {
      final dates = daily['time'] as List;
      final maxTemps = daily['temperature_2m_max'] as List;
      final minTemps = daily['temperature_2m_min'] as List;
      final codes = daily['weather_code'] as List;

      for (int i = 0; i < dates.length; i++) {
        forecasts.add(DailyForecast(
          date: DateTime.parse(dates[i]),
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weatherCode: (codes[i] as num).toInt(),
        ));
      }
    }

    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      dailyForecast: forecasts,
    );
  }
}

/// Günlük hava tahmini bilgilerini tutan model sınıfı

class DailyForecast {
  final DateTime date; // Tarih
  final double maxTemp; // Maksimum sıcaklık (°C)
  final double minTemp; // Minimum sıcaklık (°C)
  final int weatherCode; // Hava durumu kodu (WMO standardı)

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });
}
