import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/screens/portfolio_screen.dart';
import 'package:portfolio_new/screens/widgets/contact_me_screen.dart';
import 'package:portfolio_new/screens/widgets/experience_screen.dart';
import 'package:portfolio_new/screens/widgets/footer_widget.dart';
import 'package:portfolio_new/screens/widgets/nav_bar.dart';
import 'package:portfolio_new/screens/widgets/testimonials_screen.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

Widget buildTestApp(Widget child) {
  final repo = PortfolioRepository();
  final notifier = PortfolioNotifier(repository: repo);
  return MaterialApp(
    home: Scaffold(
      body: PortfolioScope(
        notifier: notifier,
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final widths = [320.0, 360.0, 375.0, 414.0, 600.0, 768.0, 800.0, 900.0, 1024.0, 1200.0];

  for (final width in widths) {
    final size = Size(width, 800);

    testWidgets('Full page at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(const PortfolioScrollablePage()));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on Full page at width $width: $err');
      }
      expect(err, isNull, reason: 'Full page failed at width $width: $err');
    });

    testWidgets('NavBar at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(
        NavBar(
          onHomeTap: () {},
          onAboutTap: () {},
          onSkillsTap: () {},
          onProjectsTap: () {},
          onExperienceTap: () {},
          onContactTap: () {},
          onMenuTap: () {},
          onRefreshTap: () {},
        ),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on NavBar at width $width: $err');
      }
      expect(err, isNull, reason: 'NavBar failed at width $width: $err');
    });

    testWidgets('ExperienceScreen at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(
        const SingleChildScrollView(child: ExperienceScreen()),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on ExperienceScreen at width $width: $err');
      }
      expect(err, isNull, reason: 'ExperienceScreen failed at width $width: $err');
    });

    testWidgets('TestimonialsScreen at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(
        const SingleChildScrollView(child: TestimonialsScreen()),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on TestimonialsScreen at width $width: $err');
      }
      expect(err, isNull, reason: 'TestimonialsScreen failed at width $width: $err');
    });

    testWidgets('ContactMe at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(
        const SingleChildScrollView(child: ContactMe()),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on ContactMe at width $width: $err');
      }
      expect(err, isNull, reason: 'ContactMe failed at width $width: $err');
    });

    testWidgets('FooterWidget at width $width', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(
        FooterWidget(
          onHomeTap: () {},
          onAboutTap: () {},
          onSkillsTap: () {},
          onProjectsTap: () {},
          onExperienceTap: () {},
          onContactTap: () {},
        ),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err != null) {
        debugPrint('OVERFLOW on FooterWidget at width $width: $err');
      }
      expect(err, isNull, reason: 'FooterWidget failed at width $width: $err');
    });
  }
}
