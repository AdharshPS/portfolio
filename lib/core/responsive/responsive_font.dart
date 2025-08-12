import 'package:flutter/material.dart';

double getResponsiveFontSize(BuildContext context, double baseFontSize) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 600) {
    return baseFontSize * 0.8;
  } else if (screenWidth < 1200) {
    return baseFontSize;
  } else {
    return baseFontSize * 1.2;
  }
}
