import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/api_service.dart';
import '../services/db_helper.dart';

/// Uygulama genelinde durum yönetimini (State Management) sağlayan Provider sınıfı

/// ChangeNotifier ile tüm dinleyen widget'ları otomatik olarak günceller

class WeatherProvider extends ChangeNotifier {
  Weather? _currentWeather; // Güncel hava durumu verisi
  City? _selectedCity; // Şu an seçili olan şehir
  List<City> _searchResults = []; // Şehir arama sonuçları
  List<City> _favorites = []; // Favori şehirler listesi
  bool _isLoading = false;
  String? _errorMessage;


  Weather? get currentWeather => _currentWeather;
  City? get selectedCity => _selectedCity;
  List<City> get searchResults => _searchResults;
  List<City> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  Future<void> loadFavorites() async {
    _favorites = DbHelper.getFavorites();
    notifyListeners();


    // otomatik olarak ilk favori şehrin verisini getir
    if (_favorites.isNotEmpty && _currentWeather == null) {
      await fetchWeather(_favorites.first);
    }
  }

  /// Belirtilen şehir için hava durumu verisini API'den çeker
  /// [city] parametresi: Hava durumu istenen şehir nesnesi
  Future<void> fetchWeather(City city) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCity = city;
    notifyListeners(); // Yükleniyor durumunu ekrana bildir

    try {
      // API'den hava durumu verisini al
      _currentWeather =
          await ApiService.getWeather(city.latitude, city.longitude);
    } catch (e) {
      _errorMessage = 'Hava durumu yüklenemedi. Lütfen tekrar deneyin.';
    }

    _isLoading = false;
    notifyListeners(); // Sonucu ekrana bildir
  }

  /// Girilen sorguya göre şehir arama işlemi yapar

  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // API'den şehir arama sonuçlarını al
      _searchResults = await ApiService.searchCities(query);
    } catch (e) {
      _errorMessage = 'Arama yapılamadı. İnternet bağlantınızı kontrol edin.';
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  ///  şehri favori listesine ekler ve UI'ı günceller
  Future<void> addToFavorites(City city) async {
    await DbHelper.addFavorite(city);
    _favorites = DbHelper.getFavorites(); // Güncel listeyi veritabanından al
    notifyListeners();
  }

  ///şehri favori listesinden siler ve UI'ı günceller
  Future<void> removeFromFavorites(City city) async {
    await DbHelper.removeFavorite(city);
    _favorites = DbHelper.getFavorites();
    notifyListeners();
  }

  ///  şehrin favori listesinde olup olmadığını kontrol eder
  bool isFavorite(City city) {
    return DbHelper.isFavorite(city);
  }


  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
