import 'package:flutter/material.dart';

class AppColors {
  // === Core Brand Colors ===
  static const Color primary = Colors.red;
  static const Color scaffoldColor = Colors.black;

  // === Derived / Dynamic Colors ===
  static final Color appBarSplash = Colors.black.withValues(alpha: 0.2);
  static final Color halfTransparentContainer = primary.withValues(alpha: 0.4);

  // === Text & Icon Colors ===
  static const Color primaryTextColor = Colors.white;
  static const Color primaryIconColor = Colors.white;

  // === Button Colors ===
  static const Color buttonTextColor = Colors.white;
  static final Color buttonBorderColor = primary;
  static final Color buttonFillColor = primary;
  static final Color buttonSplashColor = primary.withValues(alpha: 0.8);
  static final Color buttonHoverColor = primary.withValues(alpha: 0.8);
  static final Color buttonHighlightColor = primary.withValues(alpha: 0.8);

  // === Utilities ===
  static const Color transparent = Colors.transparent;
}
