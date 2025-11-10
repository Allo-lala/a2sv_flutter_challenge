import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/country_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/region_filter.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../utils/constrants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch countries when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountryProvider>().fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
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
      body: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading && countryProvider.countries.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (countryProvider.errorMessage != null) {
            return ErrorStateWidget(
              message: countryProvider.errorMessage!,
              onRetry: () => countryProvider.fetchCountries(),
            );
          }

          return Column(
            children: [
              // Search and Filter Section
              Container(
                padding: const EdgeInsets.all(AppPadding.md),
                child: Column(
                  children: [
                    SearchBarWidget(
                      searchQuery: countryProvider.searchQuery,
                      onSearchChanged: (query) {
                        countryProvider.updateSearchQuery(query);
                      },
                    ),
                    const SizedBox(height: AppPadding.md),
                    RegionFilter(
                      selectedRegion: countryProvider.selectedRegion,
                      regions: countryProvider.regions,
                      onRegionChanged: (region) {
                        countryProvider.updateRegion(region);
                      },
                    ),
                  ],
                ),
              ),

              // Countries List
              Expanded(
                child: countryProvider.countries.isEmpty
                    ? const EmptyStateWidget()
                    : RefreshIndicator(
                        onRefresh: () => countryProvider.refreshCountries(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.md,
                            vertical: AppPadding.sm,
                          ),
                          itemCount: countryProvider.countries.length,
                          itemBuilder: (context, index) {
                            final country = countryProvider.countries[index];
                            return CountryCard(
                                key: ValueKey(country
                                    .cca3), //  Add a unique key to each CountryCard
                                country: country,
                                isFavoritesScreen: false);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
