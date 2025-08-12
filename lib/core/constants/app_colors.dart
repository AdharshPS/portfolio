import 'package:flutter/material.dart';

class AppColors {
  // Primary App Colors
  static const Color primary = Colors.red;
  static const Color scaffoldColor = Colors.black;
  static Color appbarSplash = Colors.black.withValues(alpha: 0.2);

  // Styles Colors
  static const Color buttonTextColor = Colors.white;
  static Color buttonBorderColor = Colors.red;
  static Color buttonFillColor = Colors.red;
  static Color halfTransparentContainer = primary.withValues(alpha: 0.4);

  static const Color primaryTextColor = Colors.white;
  static const Color primaryIconColor = Colors.white;

  // Global
  static Color buttonSplashColor = primary.withValues(alpha: .8);
  static Color buttonHoverColor = primary.withValues(alpha: .8);
  static Color buttonHighlightColor = primary.withValues(alpha: .8);

  // Static
  static const Color transparent = Colors.transparent;
}
