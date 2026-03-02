import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COULEURS
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF00BFA5);
  static const Color primaryLight = Color(0xFFE0F7F4);

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Product card — zone image PNG sans fond
  static const Color productImageBg = Color(0xFFE1E1E1);

  // Textes
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBBBBBB);

  // Bottom nav
  static const Color navActiveIcon = Color(0xFF1A1A1A);   // cercle sombre
  static const Color navInactiveIcon = Color(0xFF9E9E9E);
  static const Color navLabel = Color(0xFF1A1A1A);

  // Divers
  static const Color divider = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFE53935);
  static const Color star = Color(0xFFFFC107);
}

// ─────────────────────────────────────────────
// TYPOGRAPHIE
// ─────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Poppins';

  // Titres de section  ex: "Catégorie", "Produits populaires"
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  // Lien "voir tout"
  static const TextStyle seeAll = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  // Nom produit dans la card
  static const TextStyle productName = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Prix produit
  static const TextStyle productPrice = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Label catégorie sous le cercle
  static const TextStyle categoryLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Hint barre de recherche
  static const TextStyle searchHint = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  // Label bottom nav actif
  static const TextStyle navLabelActive = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.navLabel,
  );

  // Label bottom nav inactif
  static const TextStyle navLabelInactive = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.navInactiveIcon,
  );

  // Body générique
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Splash — nom de l'app
  static const TextStyle splashTitle = TextStyle(
    fontFamily: _font,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
}

// ─────────────────────────────────────────────
// THÈME GLOBAL
// ─────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.surface,
        primary: AppColors.primary,
        error: AppColors.error,
      ),

      // AppBar transparent par défaut
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      // Ripple discret
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: Colors.transparent,
    );
  }
}