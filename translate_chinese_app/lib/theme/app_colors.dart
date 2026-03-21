import 'package:flutter/material.dart';

/// Central color palette — change values here to restyle the whole app.
abstract final class AppColors {
  AppColors._();

  // --- Brand (also used as [ColorScheme] seed in [main.dart]) ---
  static const Color seed = Color(0xFFA86560);
  static const Color primary = seed;

  /// Darker brand (e.g. button gradients).
  static const Color primaryDark = Color(0xFF6F3A33);

  // --- Screen & surfaces ---
  static const Color scaffoldBackground = Color(0xFFFFF8F7);
  static const Color surface = Color(0xFFFFFFFF);

  /// Soft pink cards / panels.
  static const Color cardPink = Color(0xFFFBEAE6);
  static const Color cardPinkAccent = Color(0xFFF2D8D0);

  /// Small chips / badges.
  static const Color chipRose = Color(0xFFFFE4E0);
  static const Color chipBlush = Color(0xFFFDACA6);

  /// Learn page feature tiles.
  static const Color tileCream = Color(0xFFFFF0EF);

  /// Field input
  static const Color fieldInput = Color(0xFFFFF0EF);

  /// Box shadow lấy từ Figma: X=0, Y=12, Blur=32, color=#8C4D49, alpha=8%.
  static const BoxShadow shadowFieldInput = BoxShadow(
    offset: Offset(0, 12),
    blurRadius: 32,
    color: Color(0xFFFFF0EF),
  );

  // --- Typography (brown-tinted neutrals) ---
  static const Color textPrimary = Color(0xFF3B2B27);
  static const Color textSecondary = Color(0xFFB0907F);
  static const Color textOnTint = Color(0xFF6B4A43);

  /// Replaces typical `Colors.brown.shade700` for labels on light fields.
  static const Color textFieldLabel = Color(0xFF5D4037);

  static const Color textHint = Color(0x666D5B59); // ~Colors.black26
  static const Color captionMuted = Color(0xFF9E9E9E);

  // --- Navigation FAB / selected icon gradient ---
  static const Color accentGradientA = Color(0xFFB64A3B);
  static const Color accentGradientB = Color(0xFFFF6B5A);

  static const LinearGradient accentLinearGradient = LinearGradient(
    colors: [accentGradientA, accentGradientB],
  );

  // --- Nav & icons (fixed neutrals; tweak if you want a warmer chrome) ---
  static const Color navIconUnselected = Color(0x61000000); // ~black38
  static const Color navLabelUnselected = Color(0x8A000000); // ~black54

  static Color get navBarSurface => surface.withValues(alpha: 0.92);
}
