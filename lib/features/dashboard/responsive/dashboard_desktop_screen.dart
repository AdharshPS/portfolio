import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_decoration.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/core/constants/app_styles.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/router/app_routes.dart';
import 'package:portfolio/core/services/navigation_services.dart';
import 'package:portfolio/features/dashboard/screens/about/about_screen.dart';
import 'package:portfolio/features/dashboard/screens/contact/contact_screen.dart';
import 'package:portfolio/features/dashboard/screens/home/home_screen.dart';
import 'package:portfolio/shared/custom_inkwell.dart';

class DashboardDesktopScreen extends StatefulWidget {
  const DashboardDesktopScreen({
    super.key,
    required this.scrollController,
    required this.aboutKey,
    required this.homeKey,
    required this.contactKey,
    this.section,
  });

  final ScrollController scrollController;
  final GlobalKey aboutKey;
  final GlobalKey homeKey;
  final GlobalKey contactKey;
  final String? section;

  @override
  State<DashboardDesktopScreen> createState() => _DashboardDesktopScreenState();
}

class _DashboardDesktopScreenState extends State<DashboardDesktopScreen>
    with TickerProviderStateMixin {
  bool _isAutoScrolling = false;
  String? _lastSection;
  late AnimationController _appBarAnimController;
  late Animation<double> _appBarFadeAnimation;
  Map<String, bool> _hovering = {
    AppStrings.home: false,
    AppStrings.about: false,
    AppStrings.contact: false,
  };

  @override
  void initState() {
    super.initState();

    _appBarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _appBarFadeAnimation = CurvedAnimation(
      parent: _appBarAnimController,
      curve: Curves.easeInOut,
    );
    _appBarAnimController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.addListener(_onScroll);
      _scrollTo(widget.section);
    });
  }

  @override
  void dispose() {
    _appBarAnimController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(String? section) async {
    if (_isAutoScrolling || section == null) return;

    final key = _getKeyForSection(section);
    if (key?.currentContext != null) {
      setState(() => _isAutoScrolling = true);

      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );

      setState(() => _isAutoScrolling = false);
      _updatePath(section);
    }
  }

  GlobalKey? _getKeyForSection(String? section) {
    switch (section) {
      case AppStrings.home:
        return widget.homeKey;
      case AppStrings.about:
        return widget.aboutKey;
      case AppStrings.contact:
        return widget.contactKey;
      default:
        return null;
    }
  }

  void _onScroll() {
    if (_isAutoScrolling) return;

    final sections = {
      AppStrings.home: widget.homeKey,
      AppStrings.about: widget.aboutKey,
      AppStrings.contact: widget.contactKey,
    };

    for (final entry in sections.entries) {
      final ctx = entry.value.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;

        if (position <= 100 && position >= -200) {
          _updatePath(entry.key);
          break;
        }
      }
    }
  }

  void _updatePath(String section) {
    if (_lastSection != section) {
      _lastSection = section;
      NavigationServices.push(
        context: context,
        path: AppRoutes.dashboard,
        queryParameters: {'section': section},
      );
    }
  }

  /// Widget for animated navigation button
  Widget _buildNavButton(String section) {
    bool isActive = _lastSection == section;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering[section] = true),
      onExit: (_) => setState(() => _hovering[section] = false),
      child: AnimatedScale(
        scale: _hovering[section]! || isActive ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: AppStyles.buttonTextStyle.copyWith(
            color: isActive
                ? AppColors.primary
                : AppColors.buttonTextColor.withOpacity(
                    _hovering[section]! ? 1.0 : 0.75,
                  ),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
          child: TextButton(
            onPressed: () => _scrollTo(section),
            style: AppDecoration.textButtonStyle,
            child: Text(section),
          ),
        ),
      ),
    );
  }

  Widget _buildContainerButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return CustomInkwell(
      onPressed: onPressed,
      radius: AppDimensions.containerButtonRadius,
      child: Container(
        padding: AppDimensions.containerButtonPadding,
        decoration: AppDecoration.outlinedButtonDecoration.copyWith(
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: AppStyles.buttonTextStyle.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.red.shade900,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildScreenWithAnimation(Widget screen, GlobalKey key) {
    return AnimatedVisibilityWithSlide(
      key: key,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimensions.screenWidth(context),
        ),
        child: screen,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DashboardDesktopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollTo(widget.section);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          width: AppDimensions.screenWidth(context),
          height: AppDimensions.screenHeight(context),
          padding: AppDimensions.overAllDesktopPadding,
          color: AppColors.scaffoldColor,
          child: Stack(
            children: [
              Scrollbar(
                thumbVisibility: true, // always show scrollbar on desktop/web
                thickness: 8,
                radius: const Radius.circular(16),
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                        ),
                        child: _buildScreenWithAnimation(
                          HomeScreen(homeKey: widget.homeKey),
                          widget.homeKey,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                        ),
                        child: _buildScreenWithAnimation(
                          AboutScreen(aboutKey: widget.aboutKey),
                          widget.aboutKey,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: _buildScreenWithAnimation(
                          ContactScreen(contactKey: widget.contactKey),
                          widget.contactKey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeTransition(
                opacity: _appBarFadeAnimation,
                child: _buildAppBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: AppDimensions.appBarPadding,
      decoration: AppDecoration.appBarDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.myName,
            style: AppStyles.mediumHeading(
              context,
            ).copyWith(color: AppColors.primary),
          ),
          Row(
            children: [
              _buildNavButton(AppStrings.home),
              const SizedBox(width: 20),
              _buildNavButton(AppStrings.about),
              const SizedBox(width: 20),
              _buildNavButton(AppStrings.contact),
              const SizedBox(width: 30),
              _buildContainerButton(onPressed: () {}, text: 'Resume'),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedVisibilityWithSlide extends StatefulWidget {
  final Widget child;

  const AnimatedVisibilityWithSlide({Key? key, required this.child})
    : super(key: key);

  @override
  _AnimatedVisibilityWithSlideState createState() =>
      _AnimatedVisibilityWithSlideState();
}

class _AnimatedVisibilityWithSlideState
    extends State<AnimatedVisibilityWithSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
