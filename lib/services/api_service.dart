import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';
// import '../utils/constrants.dart';

class ApiService {
  /// Fetch all countries from the REST Countries API
  static Future<List<Country>> fetchCountries() async {
    try {
      // Construct URI with query parameters to avoid 400 errors
      final uri = Uri.https(
        'restcountries.com',
        '/v3.1/all',
        {
          'fields':
              'name,capital,region,subregion,population,area,flags,languages,currencies,borders,timezones,cca3'
        },
      );

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Connection timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Country.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Countries data not found.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception(
            'Failed to load countries. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  /// Fetch a single country by its alpha-3 code (for border countries)
  static Future<Country?> fetchCountryByCode(String code) async {
    try {
      final uri = Uri.https(
        'restcountries.com',
        '/v3.1/alpha/$code',
        {
          'fields':
              'name,capital,region,subregion,population,area,flags,languages,currencies,borders,timezones,cca3'
        },
      );

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Country.fromJson(data[0]);
        }
      }
      return null;
    } catch (e) {
      // Silently fail for border countries
      return null;
    }
  }
}
