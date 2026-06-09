/// WMO hava durumu kodlarını emoji ve açıklamaya dönüştürür
class WeatherUtils {

  static String getWeatherIcon(int code) {
    if (code == 0) return '☀️'; // Açık hava
    if (code <= 3) return '⛅'; // Parçalı bulutlu
    if (code <= 48) return '🌫️'; // Sisli
    if (code <= 55) return '🌦️'; // Çisenti
    if (code <= 65) return '🌧️'; // Yağmurlu
    if (code <= 77) return '❄️'; // Karlı
    if (code <= 82) return '🌧️'; // Sağanak yağışlı
    return '⛈️'; // Fırtınalı
  }

  /// WMO hava durumu kodunu Türkçe açıklamaya dönüştürür
  static String getWeatherDescription(int code) {
    if (code == 0) return 'Açık';
    if (code <= 3) return 'Parçalı Bulutlu';
    if (code <= 48) return 'Sisli';
    if (code <= 55) return 'Çisenti';
    if (code <= 65) return 'Yağmurlu';
    if (code <= 77) return 'Karlı';
    if (code <= 82) return 'Sağanak Yağışlı';
    return 'Fırtınalı';
  }

  /// DateTime nesnesinden Türkçe kısa gün adını döner
  static String getDayName(DateTime date) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[date.weekday - 1];
  }

  /// Bugünün tarihini kontrol eder, bugünse "Bugün" yazar
  static String getDayLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Bugün';
    }
    return getDayName(date);
  }
}
