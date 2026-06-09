import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/weather_provider.dart';
import 'services/db_helper.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';

/// Uygulama giriş noktası
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive veritabanını başlat
  await DbHelper.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider()..loadFavorites(),
      child: const MyApp(),
    ),
  );
}

/// Tema, renk paleti ve navigasyon ayarları
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      debugShowCheckedModeBanner: false, // Debug bandını gizle
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFF9800),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: Color(0xFFFFF8F0),

        textTheme: GoogleFonts.poppinsTextTheme(),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF9800),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

/// Ana sayfa:Navigasyon çubuğu ile 3 ekran arasında geçiş sağlar
/// 1. Hava Durumu (Ana Ekran)
/// 2. Şehir Ara (Arama Ekranı)
/// 3. Favoriler (Favori Şehirler Ekranı)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Şu an seçili olan sekme indeksi

  /// Başka bir sekmeden ana ekrana geçiş yapmak için kullanılan fonksiyon
  void _goToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screens = [
      HomeScreen(),
      SearchScreen(onCitySelected: _goToHome),
      FavoritesScreen(onCitySelected: _goToHome),
    ];

    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      // Navigasyon Çubuğu - 3 sekme arasında geçiş sağlar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF9800),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined),
              activeIcon: Icon(Icons.cloud),
              label: 'Hava Durumu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Ara',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
          ],
        ),
      ),
    );
  }
}
