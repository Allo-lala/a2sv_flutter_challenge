import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/country_model.dart';
import '../screens/detail_screen.dart';
import '../utils/constrants.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppPadding.md),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(country: country),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.md),
          child: Row(
            children: [
              // Flag Image
              Hero(
                tag: 'flag_${country.cca3}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  child: CachedNetworkImage(
                    imageUrl: country.flagUrl,
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 60,
                      color: Theme.of(context).colorScheme.surface,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 60,
                      color: Theme.of(context).colorScheme.surface,
                      child: const Icon(Icons.flag_outlined, size: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppPadding.md),

              // Country Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Name
                    Text(
                      country.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppPadding.xs),

                    // Capital
                    Row(
                      children: [
                        Icon(
                          Icons.location_city_rounded,
                          size: AppIconSize.sm,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: AppPadding.xs),
                        Expanded(
                          child: Text(
                            country.capital,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.xs),

                    // Region
                    Row(
                      children: [
                        Icon(
                          Icons.public_rounded,
                          size: AppIconSize.sm,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: AppPadding.xs),
                        Text(
                          country.region,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Chevron Icon
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
