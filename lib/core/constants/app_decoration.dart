import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';

class AppDecoration {
  static BoxDecoration homeBackgroundContainer = BoxDecoration(
    border: Border.all(color: AppColors.primary, width: 2),
    borderRadius: AppDimensions.homeBorderRadius,
  );

  static BoxDecoration outlinedButtonDecoration = BoxDecoration(
    border: Border.all(color: AppColors.buttonBorderColor),
    borderRadius: AppDimensions.containerButtonRadius,
  );

  static BoxDecoration filledButtonDecoration = BoxDecoration(
    color: AppColors.buttonFillColor,
    borderRadius: AppDimensions.containerButtonRadius,
  );

  static BoxDecoration appBarDecoration = BoxDecoration(
    color: AppColors.appbarSplash,
  );

  static BoxDecoration halfTransparentContainer = BoxDecoration(
    color: AppColors.halfTransparentContainer,
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppColors.buttonFillColor),
    overlayColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.hovered)) {
        return AppColors.buttonHoverColor;
      }
      if (states.contains(WidgetState.pressed)) {
        return AppColors.buttonHighlightColor;
      }
      return null;
    }),
  );
}
