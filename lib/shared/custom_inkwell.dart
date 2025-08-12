import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';

class CustomInkwell extends StatelessWidget {
  const CustomInkwell({
    super.key,
    required this.onPressed,
    required this.child,
    this.splash = true,
    this.radius,
  });
  final VoidCallback onPressed;
  final Widget child;
  final bool splash;
  final BorderRadius? radius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: radius,
      splashColor: splash ? AppColors.buttonSplashColor : AppColors.transparent,
      highlightColor:
          splash ? AppColors.buttonHighlightColor : AppColors.transparent,
      hoverColor: AppColors.buttonHoverColor,
      child: child,
    );
  }
}
