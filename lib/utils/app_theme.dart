import 'package:flutter/material.dart';

/// Application color scheme
class AppColors {
  // Brand colors
  static Color primary = const Color(0xFF1F6E8C);
  static Color secondary = const Color(0xFF84A7A1);
  static Color accent = const Color(0xFF2E8A99);
  
  // Status colors
  static Color success = const Color(0xFF4CAF50);
  static Color warning = const Color(0xFFFF9800);
  static Color error = const Color(0xFFE53935);
  static Color info = const Color(0xFF2196F3);
  
  // Background colors
  static Color background = const Color(0xFFF5F5F5);
  static Color surfaceLight = const Color(0xFFFFFFFF);
  static Color surfaceDark = const Color(0xFF1E1E1E);
  
  // Text colors
  static Color textPrimary = const Color(0xFF212121);
  static Color textSecondary = const Color(0xFF757575);
  static Color textDisabled = const Color(0xFFBDBDBD);
  static Color textLight = const Color(0xFFFFFFFF);
  
  // Prayer colors
  static Color fajr = const Color(0xFF5B8FB9);
  static Color sunrise = const Color(0xFFFF9D5C);
  static Color dhuhr = const Color(0xFFFFBE0B);
  static Color asr = const Color(0xFF8CB369);
  static Color maghrib = const Color(0xFFEF7B45);
  static Color isha = const Color(0xFF4059AD);
  
  // Azkar colors
  static Color morning = const Color(0xFF64B6AC);
  static Color evening = const Color(0xFF9D8189);
  static Color ruqyah = const Color(0xFF5D576B);
}

/// Application text styles
class AppTextStyles {
  // Headings
  static TextStyle h1 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static TextStyle h2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static TextStyle h3 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static TextStyle h4 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  // Body text
  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    height: 1.5,
  );
  
  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    height: 1.5,
  );
  
  static TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    height: 1.5,
  );
  
  // Special styles
  static TextStyle caption = const TextStyle(
    fontSize: 12,
    color: Colors.grey,
    height: 1.4,
  );
  
  static TextStyle button = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  
  // Arabic text
  static TextStyle arabic = const TextStyle(
    fontFamily: 'ScheherazadeNew',
    fontSize: 22,
    height: 1.5,
  );
  
  static TextStyle arabicLarge = const TextStyle(
    fontFamily: 'ScheherazadeNew',
    fontSize: 28,
    height: 1.5,
  );
}

/// Application padding constants
class AppPadding {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  
  // Predefined paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

/// Application decorations for common UI elements
class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration prayerCard(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          color.withOpacity(0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
  
  static InputDecoration inputDecoration(
    String label, {
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: AppPadding.inputPadding,
    );
  }
}

/// Theme provider for managing light/dark mode
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  // Light theme
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        background: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: AppPadding.inputPadding,
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
  
  // Dark theme
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        background: const Color(0xFF121212),
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF262626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.md,
            vertical: AppPadding.sm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: AppPadding.inputPadding,
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}

/// Helper class for Hijri month names in Arabic
class HijriMonths {
  static String getArabicName(String englishMonth) {
    switch (englishMonth.toLowerCase()) {
      case 'muharram':
        return 'محرّم';
      case 'safar':
        return 'صفر';
      case 'rabi al-awwal':
      case 'rabi al-awal':
      case 'rabi i':
        return 'ربيع الأول';
      case 'rabi al-thani':
      case 'rabi al-akhir':
      case 'rabi ii':
        return 'ربيع الثاني';
      case 'jumada al-awwal':
      case 'jumada al-ula':
      case 'jumada i':
        return 'جمادى الأولى';
      case 'jumada al-thani':
      case 'jumada al-akhira':
      case 'jumada ii':
        return 'جمادى الآخرة';
      case 'rajab':
        return 'رجب';
      case 'shaban':
        return 'شعبان';
      case 'ramadan':
        return 'رمضان';
      case 'shawwal':
        return 'شوّال';
      case 'dhu al-qadah':
      case 'dhul qadah':
        return 'ذو القعدة';
      case 'dhu al-hijjah':
      case 'dhul hijjah':
        return 'ذو الحجة';
      default:
        return '';
    }
  }
}