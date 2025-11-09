// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'https://restcountries.com/v3.1/all?fields=name,capital,region,subregion,population,area,flags';

  Future<List<dynamic>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        print("✅ Countries loaded successfully");
        return json.decode(response.body);
      } else {
        print("❌ Error ${response.statusCode}: ${response.body}");
        throw Exception('Failed to load countries (${response.statusCode})');
      }
    } catch (e) {
      print('⚠️ Exception in fetchCountries: $e');
      rethrow;
    }
  }
}
