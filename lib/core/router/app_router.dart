import 'package:go_router/go_router.dart';
import 'package:portfolio/core/router/app_routes.dart';
import 'package:portfolio/features/dashboard/dashboard_screen.dart';

class AppRouter {
  static GoRouter get router => _router;
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder:
            (context, state) =>
                DashboardScreen(section: state.uri.queryParameters['section']),
      ),
    ],
  );
}
