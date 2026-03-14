import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/theme_provider.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(
    // Wrap in ProviderScope to use Riverpod for state management
    const ProviderScope(
      child: InstagramCloneApp(),
    ),
  );
}

class InstagramCloneApp extends ConsumerWidget {
  const InstagramCloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Instagram Home Clone',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const SplashScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      primaryColor: isDark ? Colors.black : Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: brightness,
        surface: isDark ? Colors.black : Colors.white,
        onSurface: isDark ? Colors.white : Colors.black,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.black : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: GoogleFonts.grandHotel(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 34,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? Colors.black : Colors.white,
        selectedItemColor: isDark ? Colors.white : Colors.black,
        unselectedItemColor: isDark ? Colors.white70 : Colors.black87,
      ),
      dividerColor: isDark ? Colors.grey.shade900 : const Color(0xFFE0E0E0),
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
    );
  }
}
