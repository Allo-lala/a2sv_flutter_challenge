import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/country_card.dart';
import '../utils/constrants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: Consumer2<CountryProvider, FavoritesProvider>(
        builder: (context, countryProvider, favoritesProvider, child) {
          // Get all countries (not filtered) for favorites
          final favoriteCountries = favoritesProvider.getFavoriteCountries(
            countryProvider.allCountries,
          );

          if (favoriteCountries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 80,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(height: AppPadding.lg),
                    Text(
                      'No Favorites Yet',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppPadding.sm),
                    Text(
                      'Start adding countries to your favorites by tapping the heart icon',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppPadding.md),
            itemCount: favoriteCountries.length,
            itemBuilder: (context, index) {
              final country = favoriteCountries[index];
              return CountryCard(
                country: country,
                isFavoritesScreen: true,
              );
            },
          );
        },
      ),
    );
  }
}
