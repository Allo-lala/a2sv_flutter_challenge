/// Represents a country and its related information.
class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double area;
  final String flagUrl;
  final List<String> languages;
  final List<String> currencies;
  final List<String> borders;
  final List<String> timezones;
  final String cca3; // ISO 3166-1 alpha-3 code

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.flagUrl,
    required this.languages,
    required this.currencies,
    required this.borders,
    required this.timezones,
    required this.cca3,
  });

  /// Creates a [Country] object from JSON data.
  factory Country.fromJson(Map<String, dynamic> json) {
    final name = json['name']?['common']?.toString() ?? 'Unknown';
    final officialName = json['name']?['official']?.toString() ?? name;

    final capitalList = json['capital'] as List<dynamic>?;
    final capital = (capitalList != null && capitalList.isNotEmpty)
        ? capitalList.first.toString()
        : 'N/A';

    final region = json['region']?.toString() ?? 'Unknown';
    final subregion = json['subregion']?.toString() ?? 'N/A';

    final population = json['population'] is int
        ? json['population']
        : int.tryParse(json['population']?.toString() ?? '0') ?? 0;
    final area = (json['area'] ?? 0).toDouble();

    final flagUrl = json['flags']?['png'] ?? json['flags']?['svg'] ?? '';

    final languagesMap = json['languages'] as Map<String, dynamic>?;
    final languages =
        languagesMap?.values.map((e) => e.toString()).toList() ?? <String>[];

    final currenciesMap = json['currencies'] as Map<String, dynamic>?;
    final currencies = currenciesMap?.entries
            .map((entry) {
              final data = entry.value as Map<String, dynamic>?;
              final name = data?['name']?.toString() ?? entry.key.toString();
              final symbol = data?['symbol']?.toString() ?? '';
              return symbol.isNotEmpty ? '$name ($symbol)' : name;
            })
            .toList()
            .cast<String>() ??
        <String>[];

    final bordersList = json['borders'] as List<dynamic>?;
    final borders =
        bordersList?.map((e) => e.toString()).toList() ?? <String>[];

    final timezonesList = json['timezones'] as List<dynamic>?;
    final timezones =
        timezonesList?.map((e) => e.toString()).toList() ?? <String>[];

    final cca3 = json['cca3']?.toString() ?? '';

    return Country(
      name: name,
      officialName: officialName,
      capital: capital,
      region: region,
      subregion: subregion,
      population: population,
      area: area,
      flagUrl: flagUrl,
      languages: languages,
      currencies: currencies,
      borders: borders,
      timezones: timezones,
      cca3: cca3,
    );
  }

  String get formattedPopulation {
    return population.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  String get formattedArea {
    return area.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name, 'official': officialName},
      'capital': [capital],
      'region': region,
      'subregion': subregion,
      'population': population,
      'area': area,
      'flags': {'png': flagUrl},
      'languages': {for (var lang in languages) lang: lang},
      'currencies': currencies,
      'borders': borders,
      'timezones': timezones,
      'cca3': cca3,
    };
  }

  @override
  String toString() {
    return 'Country(name: $name, region: $region, population: $population)';
  }
}
