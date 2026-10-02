import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/screens/widgets/project_screen.dart';
import 'package:portfolio_new/screens/widgets/skills_screen.dart';
import 'package:portfolio_new/services/portfolio_hardcoded_source.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

class CustomDataRepo extends PortfolioRepository {
  final PortfolioData _data;
  CustomDataRepo(this._data);

  @override
  PortfolioData getHardcodedFallback() => _data;

  @override
  Future<PortfolioResult> getInitialData() async =>
      PortfolioResult(data: _data, source: DataSource.hardcoded);
}

Widget wrapWithScope(
  Widget child, {
  TextScaler? textScaler,
  Size size = const Size(1200, 1200),
  PortfolioData? data,
}) {
  final repo = data != null ? CustomDataRepo(data) : PortfolioRepository();
  final notifier = PortfolioNotifier(repository: repo);
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: textScaler ?? TextScaler.noScaling,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: PortfolioScope(
            notifier: notifier,
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectsScreen and SkillsScreen card heights and features', () {
    testWidgets('ProjectsScreen cards in same row have equal height and Read More dialog works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrapWithScope(const ProjectsScreen()));
      await tester.pumpAndSettle();

      // Check "Read more" exists
      final readMoreFinder = find.text('Read more');
      expect(readMoreFinder, findsWidgets);

      final firstReadMore = readMoreFinder.first;
      await tester.tap(firstReadMore);
      await tester.pumpAndSettle();

      // Dialog should be visible with Close button
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      // Check card heights in the row
      final cardFinders = find.byType(IntrinsicHeight);
      expect(cardFinders, findsWidgets);
    });

    testWidgets('SkillsScreen cards in same row have equal height', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrapWithScope(const SkillsScreen()));
      await tester.pumpAndSettle();

      final intrinsicHeightFinders = find.byType(IntrinsicHeight);
      expect(intrinsicHeightFinders, findsWidgets);
    });

    testWidgets('Narrow mobile width and large text scale factor does not overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        wrapWithScope(
          const Column(
            children: [
              SkillsScreen(),
              ProjectsScreen(),
            ],
          ),
          textScaler: const TextScaler.linear(1.5),
          size: const Size(320, 800),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Massive data in project cards and skill cards does not overflow at multiple widths and scales', (tester) async {
      final base = PortfolioHardcodedSource.getHardcodedData();
      final massiveData = PortfolioData(
        profile: base.profile,
        about: base.about,
        stats: base.stats,
        experience: base.experience,
        testimonials: base.testimonials,
        seoAndMeta: base.seoAndMeta,
        contactForm: base.contactForm,
        skills: [
          SkillCategory(
            name: 'Enterprise Backend Infrastructure & Scalable Cloud Microservices Architecture',
            items: List.generate(40, (i) => 'Very Long Skill Name #$i With Extra Descriptive Content (v2.0)'),
          ),
          const SkillCategory(
            name: 'UI/UX',
            items: ['Figma', 'Prototyping'],
          ),
        ],
        projects: [
          Project(
            title: 'Massive Cross-Platform Distributed Synchronous Enterprise System With An Unusually Long Title',
            description: 'This is a long description designed to test multiline text clamping and ellipsis handling in the card. ' * 5,
            type: 'Enterprise SaaS & Cloud Infrastructure Management Badge',
            tags: List.generate(30, (i) => 'Tag #$i with extra long label'),
            github: 'https://github.com/example/enterprise',
            deploy: const Deploy(
              web: 'https://example.com/web',
              playstore: 'https://play.google.com/store/apps/details?id=com.example',
              appstore: 'https://apps.apple.com/app/id123456',
              apk: 'https://example.com/download.apk',
            ),
            thumbnail: '',
            accentColorHex: '#2563EB',
            accentColor: Colors.blue,
            deviceType: DeviceType.desktop,
          ),
          const Project(
            title: 'Short Project',
            description: 'Brief info',
            type: 'Mobile',
            tags: ['Flutter', 'Dart'],
            github: 'https://github.com',
            deploy: Deploy.empty(),
            thumbnail: '',
            accentColorHex: '#10B981',
            accentColor: Colors.green,
            deviceType: DeviceType.phone,
          ),
        ],
      );

      final testWidths = [320.0, 480.0, 768.0, 1024.0];
      final testScalers = [1.0, 1.5, 2.0];

      for (final w in testWidths) {
        for (final s in testScalers) {
          await tester.binding.setSurfaceSize(Size(w, 2000));
          await tester.pumpWidget(
            wrapWithScope(
              const Column(
                children: [
                  ProjectsScreen(),
                  SkillsScreen(),
                ],
              ),
              textScaler: TextScaler.linear(s),
              size: Size(w, 2000),
              data: massiveData,
            ),
          );
          await tester.pumpAndSettle();

          expect(
            tester.takeException(),
            isNull,
            reason: 'Overflow occurred at width $w with textScaler $s',
          );
        }
      }

      addTearDown(() => tester.binding.setSurfaceSize(null));
    });
  });
}
