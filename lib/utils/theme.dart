import 'package:flutter/material.dart';

class AppTheme {
  // Modern Colors matching the design
  static const Color primaryColor = Color(0xFF1A1A1A); // Dark grey for buttons and accents
  static const Color secondaryColor = Color(0xFFF8BBD9);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color uberPurple = Color(0xFF6B73FF);
  static const Color amazonOrange = Color(0xFFFF9500);
  static const Color microsoftBlue = Color(0xFF000000); // Microsoft is black in the design
  static const Color googleGreen = Color(0xFF34A853);
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure white background
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFE57373);
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color shadowColor = Color(0x0F000000);
  
  // Interview stage colors - matching the design exactly
  static const Color resumeScreenColor = Color(0xFF6B73FF); // Purple
  static const Color recruiterCallColor = Color(0xFFEF4444); // Red
  static const Color assessmentColor = Color(0xFFFF9500); // Yellow/Orange

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    fontFamily: 'Lexend', // Set Lexend as default font for normal text
    
    // App Bar Theme - Clean and minimal
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for app bar titles
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
    ),

    // Card Theme - Clean white cards with subtle shadows
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Elevated Button Theme - Dark grey buttons like in the design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Lexend', // Use Lexend for button text
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Lexend', // Use Lexend for button text
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontFamily: 'Lexend', // Use Lexend for button text
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        fontFamily: 'Lexend', // Use Lexend for form labels
        color: textSecondaryColor,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Lexend', // Use Lexend for form hints
        color: textSecondaryColor,
      ),
    ),

    // Bottom Navigation Bar Theme - Dark grey like in the design
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1A1A), // Dark grey background
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[100],
      selectedColor: AppTheme.secondaryColor,
      labelStyle: const TextStyle(
        fontFamily: 'Lexend', // Use Lexend for chip labels
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Text Theme - Updated to match the design typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for large display text
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for medium display text
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for small display text
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for large headlines
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for medium headlines
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Bungee', // Use Bungee for small headlines
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for large titles
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for medium titles
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for small titles
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for large body text
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for medium body text
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Lexend', // Use Lexend for small body text
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryColor,
      ),
    ),
  );
}
