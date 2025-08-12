import 'package:flutter/widgets.dart';

class AppDimensions {
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  // Home Screen
  static EdgeInsets overAllDesktopPadding = const EdgeInsets.all(16);
  static EdgeInsets overAllTabPadding = const EdgeInsets.all(12);
  static EdgeInsets overAllMobilePadding = const EdgeInsets.all(8);
  static BorderRadius homeBorderRadius = BorderRadius.circular(12);
  static EdgeInsets containerButtonPadding = const EdgeInsets.all(8);
  static BorderRadius containerButtonRadius = BorderRadius.circular(10);
  static EdgeInsets appBarPadding = const EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 24,
  );
}
