import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class DashboardMobileScreen extends StatefulWidget {
  const DashboardMobileScreen({
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
  State<DashboardMobileScreen> createState() => _DashboardMobileScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _DashboardMobileScreenState extends State<DashboardMobileScreen> {
  // void scrollToSection(GlobalKey key) {
  //   final context = key.currentContext;
  //   if (context != null) {
  //     Scrollable.ensureVisible(
  //       context,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }
  Future<void> _scrollTo(String? section) async {
    if (_isAutoScrolling) return;
    final contextMap = {
      AppStrings.home: widget.homeKey,
      AppStrings.about: widget.aboutKey,
      AppStrings.contact: widget.contactKey,
    };
    final key = contextMap[section];
    if (key?.currentContext != null) {
      setState(() {
        _isAutoScrolling = true;
      });
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: Duration(milliseconds: 500),
        // alignment: 0,
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isAutoScrolling = false;
      });
      _updatePath(section!);
    }
  }

  String? currentSection;
  bool _isAutoScrolling = false;

  void _onScroll(String? section) {
    if (_isAutoScrolling) return;
    final contextMap = {
      AppStrings.home: widget.homeKey,
      AppStrings.about: widget.aboutKey,
      AppStrings.contact: widget.contactKey,
    };
    contextMap.forEach((section, key) {
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;

        // Change threshold as needed
        if (position < 0 && position > -200) {
          _updatePath(section);
        }
      }
    });
  }

  String? _lastSection;

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

  @override
  void didUpdateWidget(covariant DashboardMobileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollTo(widget.section);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.addListener(() => _onScroll(widget.section));
      _scrollTo(widget.section);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppColors.scaffoldColor,
        child: Padding(
          padding: AppDimensions.overAllMobilePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppStrings.myName, style: AppStyles.mediumHeading(context)),
              Column(
                children: [
                  SizedBox(height: 20),
                  _buildTextButton(
                    text: AppStrings.home,
                    onPressed: () {
                      NavigationServices.push(
                        context: context,
                        path: AppRoutes.dashboard,
                        queryParameters: {'section': AppStrings.home},
                      );
                      _scrollTo(AppStrings.home);
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextButton(
                    text: AppStrings.about,
                    onPressed: () {
                      NavigationServices.push(
                        context: context,
                        path: AppRoutes.dashboard,
                        queryParameters: {'section': AppStrings.about},
                      );
                      _scrollTo(AppStrings.about);
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextButton(
                    text: AppStrings.contact,
                    onPressed: () {
                      NavigationServices.push(
                        context: context,
                        path: AppRoutes.dashboard,
                        queryParameters: {'section': AppStrings.contact},
                      );
                      _scrollTo(AppStrings.contact);
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  SizedBox(height: 10),
                  _buildContainerButton(onPressed: () {}, text: 'Resume'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: AppDimensions.screenWidth(context),
        padding: AppDimensions.overAllMobilePadding,
        child: Container(
          decoration: AppDecoration.homeBackgroundContainer,
          child: Stack(
            children: [
              SizedBox(
                height: AppDimensions.screenHeight(context),
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Column(
                    children: [
                      // --------------------------------------------------------------------------------home
                      HomeScreen(homeKey: widget.homeKey),
                      // --------------------------------------------------------------------------------about me
                      AboutScreen(aboutKey: widget.aboutKey),
                      // --------------------------------------------------------------------------------contact
                      ContactScreen(contactKey: widget.contactKey),
                    ],
                  ),
                ),
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Container(
                  padding: AppDimensions.appBarPadding,
                  decoration: AppDecoration.appBarDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: AppColors.primary),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.9,
          child: TextButton(
            onPressed: onPressed,
            style: AppDecoration.textButtonStyle,
            child: Text(text, style: AppStyles.buttonTextStyle),
          ),
        );
      },
    );
  }

  bool isMenuOpen = false;
  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildContainerButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.9,
          child: CustomInkwell(
            onPressed: onPressed,
            radius: AppDimensions.containerButtonRadius,
            child: Container(
              padding: AppDimensions.containerButtonPadding,
              decoration: AppDecoration.outlinedButtonDecoration,
              alignment: Alignment.center,
              child: Text('Resume', style: AppStyles.buttonTextStyle),
            ),
          ),
        );
      },
    );
  }
}
