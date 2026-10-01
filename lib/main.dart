import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/screens/portfolio_screen.dart';
import 'package:web/web.dart' as web;

const env = String.fromEnvironment('ENV', defaultValue: 'dev');
const buildVersion = String.fromEnvironment('BUILD_VERSION', defaultValue: '0');
String get appTitle {
  return env == 'prod' ? 'Adharsh PS Portfolio' : 'Adharsh PS Portfolio (DEV)';
}

void setBrowserTitle() {
  web.document.title = appTitle;
}

void handleBuildVersionChange() {
  try {
    final storage = web.window.localStorage;
    final stored = storage.getItem('build_version');

    if (stored != buildVersion) {
      storage.setItem('build_version', buildVersion);
      web.window.location.reload();
    }
  } catch (_) {
    // Ignore storage errors (private mode, etc.)
  }
}

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.dark);

void toggleTheme() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

void main() {
  setBrowserTitle();
  runApp(const PortfolioApp());
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
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          themeMode: currentThemeMode,
          scrollBehavior: AppScrollBehavior(),
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
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
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
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
    );
  }
}


