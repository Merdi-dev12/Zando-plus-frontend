import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// STRING EXTENSIONS
// ─────────────────────────────────────────────
extension StringExtensions on String {
  /// Met la première lettre en majuscule
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Tronque à [maxLength] caractères et ajoute "…"
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }

  /// Vérifie si la chaîne est une URL valide
  bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}

// ─────────────────────────────────────────────
// NUM / DOUBLE EXTENSIONS
// ─────────────────────────────────────────────
extension DoubleExtensions on double {
  /// Formate un montant en "1 200 000 Fc"
  String get toFc {
    final formatted = toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]} ',
    );
    return '$formatted Fc';
  }
}

extension IntExtensions on int {
  String get toFc => toDouble().toFc;
}

// ─────────────────────────────────────────────
// BUILD CONTEXT EXTENSIONS
// ─────────────────────────────────────────────
extension ContextExtensions on BuildContext {
  /// Taille de l'écran
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Padding système (notch, home indicator…)
  EdgeInsets get systemPadding => MediaQuery.paddingOf(this);

  /// Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Affiche un SnackBar rapidement
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colors.error : colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET EXTENSIONS
// ─────────────────────────────────────────────
extension WidgetExtensions on Widget {
  /// Ajoute un padding uniforme
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Ajoute un padding horizontal
  Widget paddingH(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );

  /// Ajoute un padding vertical
  Widget paddingV(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );
}