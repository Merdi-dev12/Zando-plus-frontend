import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ─────────────────────────────────────────────
  static const Color primary      = Color(0xFF00BFA5); // teal — boutons wishlist, "voir tout", dots
  static const Color primaryLight = Color(0xFFE0F7F4); // teal très clair — backgrounds légers

  // ── Backgrounds ───────────────────────────────────────
  static const Color background   = Color(0xFFF7F7F6); // fond global — gris très léger Figma
  static const Color surface      = Color(0xFFFFFFFF); // cards, search bar, bottom nav

  // ── Product card ──────────────────────────────────────
  static const Color productImageBg = Color(0xFFE1E1E1); // zone image PNG transparent

  // ── Textes ────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint      = Color(0xFFBBBBBB);

  // ── Bottom nav ────────────────────────────────────────
  static const Color navActiveCircle  = Color(0xFF1A1A1A); // cercle sombre icône active
  static const Color navInactiveIcon  = Color(0xFF9E9E9E);

  // ── Divers ────────────────────────────────────────────
  static const Color divider  = Color(0xFFEEEEEE);
  static const Color error    = Color(0xFFE53935);
  static const Color star     = Color(0xFFFFC107);
  static const Color shimmerBase      = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}