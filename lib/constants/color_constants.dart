import 'package:flutter/material.dart';

class AppColors {
  // Common Accents
  static const Color accent = Color(0xFFF97316); // Orange accent

  // Light Palette
  static const Color lightPrimary = Color(0xFF2563EB);
  static const Color lightPrimaryInk = Color(0xFF1D4ED8);
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightMuted = Color(0xFF475569);
  static const Color lightLine = Color(0xFFE2E8F0);

  // Dark Palette
  static const Color darkPrimary = Color(0xFF60A5FA);
  static const Color darkPrimaryInk = Color(0xFF93C5FD);
  static const Color darkBg = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111A2E);
  static const Color darkCard = Color(0xFF152036);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFFA8B3C7);
  static const Color darkLine = Color(0xFF24324D);

  // Backward compatibility aliases
  static const Color background = darkBg;
  static const Color backgroundSecondary = darkSurface;
  static const Color backgroundElevated = darkCard;
  static const Color primary = darkPrimary;
  static const Color primaryLight = Color(0xFF93C5FD);
  static const Color secondary = accent;
  static const Color secondaryLight = Color(0xFFFDBA74);
  static const Color cardBorder = darkLine;
  static const Color cardSurface = darkCard;
  static const Color textPrimary = darkText;
  static const Color textSecondary = darkMuted;
  static const Color textMuted = darkMuted;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [darkBg, Color(0xCC0B1220), Color(0x660B1220)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient sectionGradient1 = LinearGradient(
    colors: [darkBg, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sectionGradient2 = LinearGradient(
    colors: [darkSurface, darkBg],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dynamic Theme Helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) =>
      isDark(context) ? darkBg : lightBg;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color card(BuildContext context) =>
      isDark(context) ? darkCard : lightCard;

  static Color text(BuildContext context) =>
      isDark(context) ? darkText : lightText;

  static Color muted(BuildContext context) =>
      isDark(context) ? darkMuted : lightMuted;

  static Color line(BuildContext context) =>
      isDark(context) ? darkLine : lightLine;

  static Color primaryColor(BuildContext context) =>
      isDark(context) ? darkPrimary : lightPrimary;

  static Color primaryInk(BuildContext context) =>
      isDark(context) ? darkPrimaryInk : lightPrimaryInk;

  static List<BoxShadow> cardShadow(BuildContext context) => [
        BoxShadow(
          color: isDark(context)
              ? const Color(0x59000000)
              : const Color(0x140F172A),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> cardShadowHover(BuildContext context) => [
        BoxShadow(
          color: isDark(context)
              ? const Color(0x3360A5FA)
              : const Color(0x2E2563EB),
          blurRadius: 36,
          offset: const Offset(0, 16),
        ),
      ];
}

