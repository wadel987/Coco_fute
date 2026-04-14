// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // ==================== COULEURS FENUA MARKET ====================
  
  static const Color primaryGreen = Color(0xFF4CAF50); // Vert principal
  static const Color primaryBlue = Color(0xFF1976D2);  // Bleu secondaire
  static const Color accentBlue = Color(0xFF039BE5);   // Bleu plus clair
  
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);
  static const Color warningOrange = Color(0xFFFFA726);
  
  static const Color bgLight = Color(0xFFFAFAFA);
  static const Color bgWhite = Colors.white;
  
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textHint = Color(0xFF9E9E9E);
  
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFEEEEEE);

  // ==================== LIGHT THEME ====================
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Couleur primaire
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: primaryBlue,
      surface: bgWhite,
      background: bgLight,
      error: errorRed,
    ),
    
    // AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: bgWhite,
      foregroundColor: textPrimary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Scaffold
    scaffoldBackgroundColor: bgWhite,
    
    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bgWhite,
      selectedItemColor: primaryGreen,
      unselectedItemColor: textHint,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      headlineSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textHint,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryGreen,
          width: 2,
        ),
      ),
      hintStyle: const TextStyle(
        color: textHint,
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGreen,
        side: const BorderSide(color: primaryGreen),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: bgLight,
      selectedColor: primaryGreen,
      labelStyle: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: const BorderSide(color: borderColor),
    ),
    
    // FAB Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: bgWhite,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderColor),
      ),
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: bgWhite,
    ),
  );

  // ==================== DARK THEME (Futur) ====================
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
    ),
  );
}

// ==================== COULEURS UTILITAIRES ====================

class AppColors {
  // Principaux
  static const Color primary = AppTheme.primaryGreen;
  static const Color secondary = AppTheme.primaryBlue;
  
  // Status
  static const Color success = AppTheme.successGreen;
  static const Color error = AppTheme.errorRed;
  static const Color warning = AppTheme.warningOrange;
  
  // Neutres
  static const Color background = AppTheme.bgWhite;
  static const Color surface = AppTheme.bgWhite;
  static const Color surfaceVariant = AppTheme.bgLight;
  
  // Text
  static const Color textPrimary = AppTheme.textPrimary;
  static const Color textSecondary = AppTheme.textSecondary;
  static const Color textHint = AppTheme.textHint;
  
  // Borders
  static const Color border = AppTheme.borderColor;
  static const Color divider = AppTheme.dividerColor;
  
  // Badges
  static Color getBadgeColor(String type) {
    switch (type.toUpperCase()) {
      case 'EPICERIE':
        return const Color(0xFF4CAF50);
      case 'FRAIS':
        return const Color(0xFF2196F3);
      case 'SURGELÉS':
        return const Color(0xFF00BCD4);
      case 'BOISSONS':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
  
  // Discount colors
  static Color getDiscountColor(double discount) {
    if (discount <= 25) return const Color(0xFF4CAF50); // Vert
    if (discount <= 50) return const Color(0xFFFFA726); // Orange
    return const Color(0xFFE53935); // Rouge
  }
}

// ==================== TEXT STYLES ====================

class AppTextStyles {
  // Titres
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle headline4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );
  
  // Sous-titres
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
  );
  
  // Body
  static const TextStyle body1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppTheme.textSecondary,
  );
  
  // Petit texte
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.textHint,
  );
  
  // Badges
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  // Prix
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryGreen,
  );
  
  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryGreen,
  );
}
