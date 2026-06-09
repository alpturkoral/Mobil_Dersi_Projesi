import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import '../models/city.dart';
import '../models/weather.dart';

/// Ana Ekran
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.currentWeather == null && !provider.isLoading) {
          return _buildEmptyState();
        }
        if (provider.isLoading) {
          return _buildLoadingState();
        }
        if (provider.errorMessage != null) {
          return _buildErrorState(provider.errorMessage!);
        }
        return _buildWeatherContent(context, provider);
      },
    );
  }

  /// Henüz şehir seçilmediğinde gösterilen  ekran
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('☀️', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              'Hoş Geldiniz!',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF8C00),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Arama sekmesinden bir şehir arayarak\nhava durumunu görüntüleyin',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Veri yüklenirken gösterilen  yükleme ekranı
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFFF9800),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Hava durumu yükleniyor...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  /// Hava durumu verilerinin gösterildiği ana ekran
  Widget _buildWeatherContent(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final city = provider.selectedCity!;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWeatherHeader(city, weather),
          SizedBox(height: 24),

          _buildInfoCards(weather),
          SizedBox(height: 28),

          _buildDailyForecast(weather),
          SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildWeatherHeader(City city, Weather weather) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 60, 24, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF9800), // Turuncu
            Color(0xFFFFB74D), // Açık turuncu
            Color(0xFFFFD54F), // Sarımsı
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF9800).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Şehir adı ve ülke
            Text(
              '${city.name}, ${city.country}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            Text(
              WeatherUtils.getWeatherIcon(weather.weatherCode),
              style: TextStyle(fontSize: 72),
            ),
            SizedBox(height: 8),

            Text(
              '${weather.temperature.round()}°',
              style: GoogleFonts.poppins(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),

            Text(
              WeatherUtils.getWeatherDescription(weather.weatherCode),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(Weather weather) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Nem kartı
          Expanded(
            child: _buildInfoCard(
              icon: Icons.water_drop_outlined,
              label: 'Nem',
              value: '%${weather.humidity}',
              color: Color(0xFF42A5F5),
            ),
          ),
          SizedBox(width: 16),
          // Rüzgar kartı
          Expanded(
            child: _buildInfoCard(
              icon: Icons.air,
              label: 'Rüzgar',
              value: '${weather.windSpeed.round()} km/s',
              color: Color(0xFF66BB6A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// 7 günlük hava tahminini yatay kaydırılabilir liste olarak gösterir
  Widget _buildDailyForecast(Weather weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '7 Günlük Tahmin',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        SizedBox(height: 14),

        // Yatay kaydırılabilir tahmin kartları
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: weather.dailyForecast.length,
            itemBuilder: (context, index) {
              return _buildForecastCard(weather.dailyForecast[index]);
            },
          ),
        ),
      ],
    );
  }

  ///  bir günlük tahmin kartı
  Widget _buildForecastCard(DailyForecast forecast) {
    return Container(
      width: 85,
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gün adı
          Text(
            WeatherUtils.getDayLabel(forecast.date),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          // Hava durumu emojisi
          Text(
            WeatherUtils.getWeatherIcon(forecast.weatherCode),
            style: TextStyle(fontSize: 28),
          ),
          // Maksimum sıcaklık
          Text(
            '${forecast.maxTemp.round()}°',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          // Minimum sıcaklık
          Text(
            '${forecast.minTemp.round()}°',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
