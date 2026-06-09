import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/weather_provider.dart';

/// Favori Şehirler Ekranı
/// Veritabanına kaydedilmiş favori şehirleri listeler
class FavoritesScreen extends StatelessWidget {
  final VoidCallback onCitySelected; // Şehir seçildiğinde ana ekrana geçiş

  const FavoritesScreen({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          'Favori Şehirlerim',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFFF9800),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          // Favori şehir yoksa boş durum ekranı göster
          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          // Favori şehirlerin listesi
          return _buildFavoritesList(context, provider, favorites);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 72, color: Colors.grey[300]),
            SizedBox(height: 20),
            Text(
              'Henüz favori şehir yok',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Arama sekmesinden şehir arayarak\nfavorilerinize ekleyebilirsiniz',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Favori şehirlerin listelendiği widget
  /// Her şehir sola kaydırılarak silinebilir
  Widget _buildFavoritesList(
    BuildContext context,
    WeatherProvider provider,
    List favorites,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final city = favorites[index];

        // Sola kaydırarak silme işlevi
        return Dismissible(
          key: Key('${city.latitude}_${city.longitude}'),
          direction: DismissDirection.endToStart,
          // Silme onaytı
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  'Şehri Sil',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                content: Text(
                  '${city.name} favorilerinizden silinecek. Emin misiniz?',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text('İptal',
                        style: GoogleFonts.poppins(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('Sil',
                        style: GoogleFonts.poppins(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          // Silme işlemi onayı
          onDismissed: (direction) {
            provider.removeFromFavorites(city);
            // Kullanıcıya bildirim göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${city.name} favorilerden silindi',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Color(0xFFFF9800),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },

          background: Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24),
            child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
          // Şehir kartı tasarımı
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // Sol taraftaki turuncu konum ikonu
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_on, color: Colors.white),
              ),
              // Şehir adı
              title: Text(
                city.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              // Ülke adı
              subtitle: Text(
                city.country,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
              // Sağ ok ikonu
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFFF9800),
                size: 18,
              ),
              // Şehre tıklandığında hava durumunu getir ve ana ekrana geç
              onTap: () async {
                await provider.fetchWeather(city);
                onCitySelected(); // Ana ekrana geçiş yap
              },
            ),
          ),
        );
      },
    );
  }
}
