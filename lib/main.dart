import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/country_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart'; // ADD THIS
import 'screens/main_navigation.dart'; // CHANGE THIS
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize providers and load saved preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  final favoritesProvider = FavoritesProvider(); // ADD THIS
  await favoritesProvider.loadFavorites(); // ADD THIS

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => favoritesProvider), // ADD THIS
      ],
      child: const A2SVFlutterChallengeApp(),
    ),
  );
}

class A2SVFlutterChallengeApp extends StatelessWidget {
  const A2SVFlutterChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'A2SV Flutter Challenge',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MainNavigation(),
        );
      },
    );
  }
}
