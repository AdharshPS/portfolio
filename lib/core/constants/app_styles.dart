import 'package:flutter/widgets.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/responsive/responsive_font.dart';

class AppStyles {
  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: 16,
    color: AppColors.buttonTextColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle largeHeading(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 32),
    color: AppColors.primaryTextColor,
    fontWeight: FontWeight.w700,
  );

  static TextStyle mediumHeading(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 24),
    color: AppColors.primaryTextColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle smallHeading(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 18),
    color: AppColors.primaryTextColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle hintString(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 14),
    color: AppColors.primaryTextColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle messageString(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 16),
    color: AppColors.primaryTextColor,
    fontWeight: FontWeight.w400,
    wordSpacing: 2,
    letterSpacing: 1.2,
    height: 1.5,
  );
}
