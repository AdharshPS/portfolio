import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/core/constants/app_styles.dart';
import 'package:portfolio/shared/custom_inkwell.dart';
import 'package:portfolio/core/services/navigation_services.dart';
import 'package:portfolio/core/router/app_routes.dart';

class HomeDesktopScreen extends StatefulWidget {
  const HomeDesktopScreen({super.key, required this.homeKey});

  final GlobalKey homeKey;

  @override
  State<HomeDesktopScreen> createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen>
    with SingleTickerProviderStateMixin {
  bool _hovering = false;

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppDimensions.screenWidth(context);

    return Material(
      // Wrap entire UI in Material to provide Material context required by buttons, ink effects, etc.
      child: SingleChildScrollView(
        // Allow vertical scrolling to prevent overflow on smaller window heights
        child: Container(
          key: widget.homeKey,
          width: width,
          padding: AppDimensions.overAllDesktopPadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.scaffoldColor,
                AppColors.primary.withOpacity(0.2),
                Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hovering = true),
                  onExit: (_) => setState(() => _hovering = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: width * 0.5,
                    padding: AppDimensions.containerButtonPadding,
                    decoration: BoxDecoration(
                      color: _hovering
                          ? AppColors.halfTransparentContainer.withOpacity(0.6)
                          : AppColors.halfTransparentContainer,
                      borderRadius: AppDimensions.homeBorderRadius,
                      boxShadow: _hovering
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // Prevent unbounded height overflow
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: _hovering
                              ? AppStyles.largeHeading(
                                  context,
                                ).copyWith(color: AppColors.primary)
                              : AppStyles.largeHeading(context),
                          child: Text(AppStrings.welcome),
                        ),
                        const SizedBox(height: 10),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: AppStyles.mediumHeading(context).copyWith(
                            color: _hovering
                                ? AppColors.buttonTextColor
                                : AppColors.primaryTextColor,
                          ),
                          child: Text(AppStrings.myName),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            AnimatedRotation(
                              turns: _hovering ? 1 : 0,
                              duration: const Duration(seconds: 1),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.primaryIconColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 400),
                                style: AppStyles.smallHeading(context).copyWith(
                                  color: _hovering
                                      ? AppColors.primary
                                      : AppColors.primaryTextColor,
                                ),
                                child: Text(AppStrings.profession),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomInkwell(
                          splash: false,
                          onPressed: () {
                            NavigationServices.push(
                              context: context,
                              path: AppRoutes.dashboard,
                              queryParameters: {'section': 'about'},
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _hovering
                                  ? AppColors.buttonFillColor
                                  : Colors.transparent,
                              borderRadius: AppDimensions.containerButtonRadius,
                              border: Border.all(
                                color: AppColors.buttonBorderColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Explore More',
                              style: AppStyles.buttonTextStyle.copyWith(
                                color: _hovering
                                    ? Colors.white
                                    : AppColors.primaryTextColor.withOpacity(
                                        0.8,
                                      ),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
