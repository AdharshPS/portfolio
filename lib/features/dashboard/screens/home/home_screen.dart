import 'package:flutter/widgets.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/dashboard/screens/home/responsive/home_desktop_screen.dart';
import 'package:portfolio/features/dashboard/screens/home/responsive/home_mobile_screen.dart';
import 'package:portfolio/features/dashboard/screens/home/responsive/home_tablet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.homeKey});

  final GlobalKey homeKey;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: HomeMobileScreen(homeKey: homeKey),
      tabletLayout: HomeTabletScreen(homeKey: homeKey),
      desktopLayout: HomeDesktopScreen(homeKey: homeKey),
    );
  }
}
