import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/screens/portfolio_screen.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:portfolio_new/utils/platform_utils.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');
const buildVersion = String.fromEnvironment('BUILD_VERSION', defaultValue: '0');

String get defaultAppTitle {
  return env == 'prod' ? 'Adharsh PS Portfolio' : 'Adharsh PS Portfolio (DEV)';
}

void setBrowserTitle(String title) {
  setPlatformBrowserTitle(title);
}

void handleBuildVersionChange() {
  try {
    final storage = getPlatformStorage();
    final stored = storage.read('build_version');
    stored.then((val) {
      if (val != null && val != buildVersion) {
        storage.write('build_version', buildVersion);
        storage.delete('portfolio_data_cache');
        storage.delete('portfolio_data_cache_timestamp');
      } else if (val == null) {
        storage.write('build_version', buildVersion);
      }
    });
  } catch (_) {
    // Ignore storage errors (private mode, etc.)
  }
}

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.dark,
);

void toggleTheme() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setBrowserTitle(defaultAppTitle);
  handleBuildVersionChange();

  final portfolioNotifier = PortfolioNotifier();
  portfolioNotifier.initialize();

  runApp(PortfolioApp(notifier: portfolioNotifier));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class PortfolioApp extends StatelessWidget {
  final PortfolioNotifier? notifier;

  const PortfolioApp({super.key, this.notifier});

  @override
  Widget build(BuildContext context) {
    final activeNotifier = notifier ?? PortfolioNotifier();

    return PortfolioScope(
      notifier: activeNotifier,
      child: ListenableBuilder(
        listenable: Listenable.merge([themeModeNotifier, activeNotifier]),
        builder: (context, _) {
          final state = activeNotifier.state;
          final siteTitle = state.data.seoAndMeta.siteTitle.trim();
          final effectiveTitle = siteTitle.isNotEmpty
              ? (env == 'prod' ? siteTitle : '$siteTitle (DEV)')
              : defaultAppTitle;

          // Keep browser title in sync with loaded SEO meta
          setBrowserTitle(effectiveTitle);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: effectiveTitle,
            themeMode: themeModeNotifier.value,
            scrollBehavior: AppScrollBehavior(),
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.lightBg,
              textTheme: AppTypography.primaryTextTheme(
                ThemeData.light().textTheme,
              ),
              colorScheme: const ColorScheme.light(
                primary: AppColors.lightPrimary,
                secondary: AppColors.accent,
                surface: AppColors.lightSurface,
                onSurface: AppColors.lightText,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.darkBg,
              textTheme: AppTypography.primaryTextTheme(ThemeData.dark().textTheme),
              colorScheme: const ColorScheme.dark(
                primary: AppColors.darkPrimary,
                secondary: AppColors.accent,
                surface: AppColors.darkSurface,
                onSurface: AppColors.darkText,
              ),
            ),
            home: const PortfolioScrollablePage(),
          );
        },
      ),
    );
  }
}
