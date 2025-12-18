import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/features/dashboard/screens/home/home_screen.dart';
import 'package:portfolio/features/dashboard/screens/contact/contact_screen.dart';
import 'package:portfolio/features/dashboard/screens/about/about_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            HomeScreen(homeKey: GlobalKey(debugLabel: 'homeKey')),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) =>
            ContactScreen(contactKey: GlobalKey(debugLabel: 'contactKey')),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) =>
            AboutScreen(aboutKey: GlobalKey(debugLabel: 'aboutKey')),
      ),
    ],
  );
}
