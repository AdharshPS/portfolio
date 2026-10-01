import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/screens/widgets/about_me_screen.dart';
import 'package:portfolio_new/screens/widgets/contact_me_screen.dart';
import 'package:portfolio_new/screens/widgets/experience_screen.dart';
import 'package:portfolio_new/screens/widgets/footer_widget.dart';
import 'package:portfolio_new/screens/widgets/home_screen.dart';
import 'package:portfolio_new/screens/widgets/project_screen.dart';
import 'package:portfolio_new/screens/widgets/skills_screen.dart';
import 'package:portfolio_new/screens/widgets/testimonials_screen.dart';
import 'package:portfolio_new/services/download_cv_service.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

Widget createTestWidget({required Widget child, PortfolioData? data}) {
  final repo = PortfolioRepository();
  final notifier = PortfolioNotifier(repository: repo);

  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: PortfolioScope(notifier: notifier, child: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UI Regression Tests for Every Section', () {
    testWidgets(
      '1. Hero / Profile Section renders dynamic content and buttons',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1440, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(createTestWidget(child: const HomeScreen()));
        await tester.pumpAndSettle();

        expect(find.text('// hello, world'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is RichText && w.text.toPlainText().contains('Adharsh P S'),
          ),
          findsOneWidget,
        );
        expect(find.text('View projects'), findsOneWidget);
        expect(find.text('Download resume'), findsOneWidget);
      },
    );

    testWidgets('2. About Me Section renders intro, journey, and stats', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(child: const AboutMe()));
      await tester.pumpAndSettle();

      expect(find.text('About me'), findsOneWidget);
      expect(
        find.textContaining('industry experience at Avanzo'),
        findsOneWidget,
      );
      // Stats verified
      expect(find.text('1.5+'), findsOneWidget);
      expect(find.text('Years experience'), findsOneWidget);
      expect(find.text('3+'), findsOneWidget);
      expect(find.text('15+'), findsOneWidget);
    });

    testWidgets('3. Skills Section renders category cards and chips', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(child: const SkillsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Core Flutter'), findsOneWidget);
      expect(find.text('Backend & Data'), findsOneWidget);
      expect(find.text('Flutter'), findsWidgets);
      expect(find.text('Clean Architecture'), findsOneWidget);
    });

    testWidgets('4. Projects Section renders cards and filter tabs', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(child: const ProjectsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Open Source'), findsWidgets);
      expect(find.text('NoteFlow'), findsOneWidget);

      // Tap filter
      await tester.tap(find.text('Consumer').first);
      await tester.pumpAndSettle();
      expect(find.text('Paws (Pet Marketplace)'), findsOneWidget);
      expect(find.text('NoteFlow'), findsNothing);
    });

    testWidgets('5. Experience Section renders roles, company, and timeline', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(child: const ExperienceScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Experience'), findsOneWidget);
      expect(find.textContaining('Avanzo Cyber Security'), findsOneWidget);
      expect(find.textContaining('Luminar Technolab'), findsOneWidget);
    });

    testWidgets('6. Testimonials Section renders kind words feedback', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(child: const TestimonialsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kind words'), findsOneWidget);
      expect(
        find.textContaining('clean, testable Flutter applications'),
        findsOneWidget,
      );
      expect(find.text('Technical Team'), findsOneWidget);
    });

    testWidgets(
      '7. Contact Me Section renders contact fields and direct links',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1440, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(createTestWidget(child: const ContactMe()));
        await tester.pumpAndSettle();

        expect(find.text("Let's build something"), findsOneWidget);
        expect(find.text('adharshps000@gmail.com'), findsOneWidget);
        expect(find.text('+91 8138987626'), findsOneWidget);
        expect(find.text('Kerala, India'), findsOneWidget);
      },
    );

    testWidgets('8. Footer Section renders dynamic copyright and links', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1440, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(
          child: FooterWidget(
            onHomeTap: () {},
            onAboutTap: () {},
            onSkillsTap: () {},
            onProjectsTap: () {},
            onExperienceTap: () {},
            onContactTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Adharsh P S'), findsWidgets);
      expect(find.textContaining('Built with care.'), findsOneWidget);
    });

    testWidgets(
      '9. CV Service handles missing URL with error message without crashing',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => downloadCV(
                    context,
                    cvInfo: const CvInfo(downloadUrl: ''),
                  ),
                  child: const Text('Download'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Download'));
        await tester.pump(const Duration(milliseconds: 500));

        expect(
          find.text('CV download link is currently unavailable.'),
          findsOneWidget,
        );
      },
    );
  });
}
