import 'package:flutter/material.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/dashboard/responsive/dashboard_desktop_screen.dart';
import 'package:portfolio/features/dashboard/responsive/dashboard_mobile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.section});
  final String? section;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final contactKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: DashboardMobileScreen(
        aboutKey: aboutKey,
        contactKey: contactKey,
        homeKey: homeKey,
        scrollController: _scrollController,
      ),
      tabletLayout: DashboardDesktopScreen(
        aboutKey: aboutKey,
        contactKey: contactKey,
        homeKey: homeKey,
        scrollController: _scrollController,
      ),
      desktopLayout: DashboardDesktopScreen(
        aboutKey: aboutKey,
        contactKey: contactKey,
        homeKey: homeKey,
        scrollController: _scrollController,
        section: widget.section,
      ),
    );
  }
}
