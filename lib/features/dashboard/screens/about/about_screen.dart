import 'package:flutter/widgets.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/dashboard/screens/about/responsive/about_desktop_screen.dart';
import 'package:portfolio/features/dashboard/screens/about/responsive/about_mobile_screen.dart';
import 'package:portfolio/features/dashboard/screens/about/responsive/about_tab_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.aboutKey});

  final GlobalKey aboutKey;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: AboutMobileScreen(aboutKey: aboutKey),
      tabletLayout: AboutTabScreen(aboutKey: aboutKey),
      desktopLayout: AboutDesktopScreen(aboutKey: aboutKey),
    );
  }
}
