import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _favoritesKey = 'favorite_countries';
  final Set<String> _favoriteCountryCodes = {};

  Set<String> get favoriteCountryCodes =>
      Set.unmodifiable(_favoriteCountryCodes);

  // Load favorites from local storage
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList(_favoritesKey);

      if (savedFavorites != null) {
        _favoriteCountryCodes.clear();
        _favoriteCountryCodes.addAll(savedFavorites);
        debugPrint(
            'Loaded ${_favoriteCountryCodes.length} favorites: $_favoriteCountryCodes');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
    }
  }

  // Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteCountryCodes.toList());
      debugPrint('Saved favorites: $_favoriteCountryCodes');
    } catch (e) {
      debugPrint('Failed to save favorites: $e');
    }
  }

  // Check if a country is favorite
  bool isFavorite(String countryCode) {
    return _favoriteCountryCodes.contains(countryCode);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Country country) async {
    final countryCode = country.cca3;

    if (_favoriteCountryCodes.contains(countryCode)) {
      // Remove from favorites
      _favoriteCountryCodes.remove(countryCode);
      debugPrint(
          '❌ Removed ${country.name} ($countryCode) from favorites. Total: ${_favoriteCountryCodes.length}');
    } else {
      // Add to favorites
      _favoriteCountryCodes.add(countryCode);
      debugPrint(
          '✅ Added ${country.name} ($countryCode) to favorites. Total: ${_favoriteCountryCodes.length}');
    }

    debugPrint('Current favorites: $_favoriteCountryCodes');

    await _saveFavorites();
    notifyListeners();
  }

  // Get list of favorite countries from all countries
  List<Country> getFavoriteCountries(List<Country> allCountries) {
    return allCountries
        .where((country) => _favoriteCountryCodes.contains(country.cca3))
        .toList();
  }

  // Remove favorite
  Future<void> removeFavorite(String countryCode) async {
    _favoriteCountryCodes.remove(countryCode);
    await _saveFavorites();
    notifyListeners();
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    _favoriteCountryCodes.clear();
    await _saveFavorites();
    notifyListeners();
  }
}
