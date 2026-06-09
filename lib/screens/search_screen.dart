import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/weather_provider.dart';

/// Şehir Arama Ekranı (Search Screen)
/// Kullanıcı şehir adı girerek Open-Meteo Geocoding API ile şehir arar
class SearchScreen extends StatefulWidget {
  final VoidCallback onCitySelected;

  const SearchScreen({super.key, required this.onCitySelected});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          'Şehir Ara',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFFF9800),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),

          Expanded(child: _buildSearchResults(context)),
        ],
      ),
    );
  }

  /// Enter tuşuna basıldığında veya arama ikonuna tıklandığında arama yapar
  Widget _buildSearchBar(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) => provider.searchCities(value),
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Şehir adı girin...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Color(0xFFFF9800)),
          // Arama butonu
          suffixIcon: IconButton(
            icon: Icon(Icons.send_rounded, color: Color(0xFFFF9800)),
            onPressed: () {
              provider.searchCities(_searchController.text);
              FocusScope.of(context).unfocus();
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  /// Arama sonuçlarını listeleyen widget
  Widget _buildSearchResults(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFFF9800)),
          );
        }

        // Hata durumu
        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[500],
                ),
              ),
            ),
          );
        }

        if (provider.searchResults.isEmpty &&
            _searchController.text.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city, size: 64, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  'Bir şehir adı yazarak arayın',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  'Sonuç bulunamadı',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        // Sonuç listesi
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.searchResults.length,
          itemBuilder: (context, index) {
            final city = provider.searchResults[index];
            final isFav = provider.isFavorite(city);

            return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                // Konum ikonu
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(Icons.location_on, color: Color(0xFFFF9800)),
                ),
                // Şehir adı ve ülke
                title: Text(
                  city.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  city.country,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                // Favoriler butonu
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red[400] : Colors.grey[400],
                  ),
                  onPressed: () {
                    if (isFav) {
                      provider.removeFromFavorites(city);
                    } else {
                      provider.addToFavorites(city);
                    }
                  },
                ),
                // Şehre tıklandığında hava durumunu getir ve ana ekrana geç
                onTap: () async {
                  await provider.addToFavorites(city);
                  await provider.fetchWeather(city);
                  widget.onCitySelected();
                },
              ),
            );
          },
        );
      },
    );
  }
}
