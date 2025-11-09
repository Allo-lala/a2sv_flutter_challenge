import 'package:flutter/material.dart';
import '../utils/constrants.dart';

class RegionFilter extends StatelessWidget {
  final String selectedRegion;
  final List<String> regions;
  final ValueChanged<String> onRegionChanged;

  const RegionFilter({
    super.key,
    required this.selectedRegion,
    required this.regions,
    required this.onRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];
          final isSelected = region == selectedRegion;

          return Padding(
            padding: EdgeInsets.only(
              right: index < regions.length - 1 ? AppPadding.sm : 0,
            ),
            child: FilterChip(
              label: Text(region),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onRegionChanged(region);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              checkmarkColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.md,
                vertical: AppPadding.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
