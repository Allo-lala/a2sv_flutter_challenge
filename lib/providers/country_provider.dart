// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/foundation.dart';
import '../models/country_model.dart';
import '../services/api_service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedRegion = 'All';

  // Cache for border countries to avoid repeated API calls
  final Map<String, Country?> _borderCountriesCache = {};

  // Getters
  List<Country> get countries => _filteredCountries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedRegion => _selectedRegion;

  List<String> get regions => [
        'All',
        'Africa',
        'Americas',
        'Asia',
        'Europe',
        'Oceania',
      ];

  // Fetch all countries
  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> jsonList = await _apiService.fetchCountries();
      _countries = jsonList.map((json) => Country.fromJson(json)).toList();

      _countries.sort((a, b) => a.name.compareTo(b.name));
      _applyFilters();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Apply search and region filters
  void _applyFilters() {
    _filteredCountries = _countries.where((country) {
      final matchesSearch = _searchQuery.isEmpty ||
          country.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          country.capital.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesRegion =
          _selectedRegion == 'All' || country.region == _selectedRegion;

      return matchesSearch && matchesRegion;
    }).toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Update selected region
  void updateRegion(String region) {
    _selectedRegion = region;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedRegion = 'All';
    _applyFilters();
    notifyListeners();
  }

  // Get country by code (for border countries)
  Future<Country?> getCountryByCode(String code) async {
    // Check cache first
    if (_borderCountriesCache.containsKey(code)) {
      return _borderCountriesCache[code];
    }
  }

  // Refresh countries (for pull-to-refresh)
  Future<void> refreshCountries() async {
    _borderCountriesCache.clear();
    await fetchCountries();
  }
}
