import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/country_model.dart';
import '../providers/country_provider.dart';
import '../utils/constrants.dart';

class DetailScreen extends StatelessWidget {
  final Country country;

  const DetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag Image
            Hero(
              tag: 'flag_${country.cca3}',
              child: Container(
                width: double.infinity,
                height: 240,
                color: Theme.of(context).colorScheme.surface,
                child: CachedNetworkImage(
                  imageUrl: country.flagUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.flag_outlined, size: 80),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppPadding.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country Name
                  Text(
                    country.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppPadding.lg),

                  // Official Name
                  _buildInfoSection(
                    context,
                    AppStrings.officialName,
                    country.officialName,
                  ),

                  // Capital
                  _buildInfoSection(
                    context,
                    AppStrings.capital,
                    country.capital,
                  ),

                  // Population
                  _buildInfoSection(
                    context,
                    AppStrings.population,
                    country.formattedPopulation,
                  ),

                  // Region
                  _buildInfoSection(
                    context,
                    AppStrings.region,
                    country.region,
                  ),

                  // Subregion
                  _buildInfoSection(
                    context,
                    AppStrings.subregion,
                    country.subregion,
                  ),

                  // Area
                  _buildInfoSection(
                    context,
                    AppStrings.area,
                    '${country.formattedArea} km²',
                  ),

                  // Languages
                  if (country.languages.isNotEmpty) ...[
                    _buildInfoSection(
                      context,
                      AppStrings.languages,
                      country.languages.join(', '),
                    ),
                  ],

                  // Currencies
                  if (country.currencies.isNotEmpty) ...[
                    _buildInfoSection(
                      context,
                      AppStrings.currencies,
                      country.currencies.join(', '),
                    ),
                  ],

                  // Timezones
                  if (country.timezones.isNotEmpty) ...[
                    const SizedBox(height: AppPadding.md),
                    Text(
                      AppStrings.timezones,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppPadding.sm),
                    Wrap(
                      spacing: AppPadding.sm,
                      runSpacing: AppPadding.sm,
                      children: country.timezones.map((timezone) {
                        return Chip(
                          label: Text(timezone),
                        );
                      }).toList(),
                    ),
                  ],

                  // Border Countries
                  if (country.borders.isNotEmpty) ...[
                    const SizedBox(height: AppPadding.lg),
                    Text(
                      AppStrings.borderCountries,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppPadding.md),
                    _buildBorderCountries(context),
                  ] else ...[
                    const SizedBox(height: AppPadding.lg),
                    Text(
                      AppStrings.borderCountries,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppPadding.sm),
                    Text(
                      AppStrings.noBorders,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],

                  const SizedBox(height: AppPadding.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppPadding.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBorderCountries(BuildContext context) {
    return Wrap(
      spacing: AppPadding.sm,
      runSpacing: AppPadding.sm,
      children: country.borders.map((borderCode) {
        return _BorderCountryChip(borderCode: borderCode);
      }).toList(),
    );
  }
}

class _BorderCountryChip extends StatelessWidget {
  final String borderCode;

  const _BorderCountryChip({required this.borderCode});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Country?>(
      future: context.read<CountryProvider>().getCountryByCode(borderCode),
      builder: (context, snapshot) {
        final countryName = snapshot.data?.name ?? borderCode;

        return ActionChip(
          label: Text(countryName),
          onPressed: snapshot.data != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        country: snapshot.data!,
                      ),
                    ),
                  );
                }
              : null,
        );
      },
    );
  }
}
