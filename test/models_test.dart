import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/models/portfolio_model.dart';

void main() {
  group('Portfolio Models Tests', () {
    test('parseHexColor handles various hex formats and invalid inputs', () {
      expect(parseHexColor('#2563EB'), equals(const Color(0xFF2563EB)));
      expect(parseHexColor('2563EB'), equals(const Color(0xFF2563EB)));
      expect(parseHexColor('0xFF2563EB'), equals(const Color(0xFF2563EB)));
      expect(parseHexColor('#F97316'), equals(const Color(0xFFF97316)));
      // Invalid hex returns fallback
      expect(parseHexColor('invalid'), equals(const Color(0xFF2563EB)));
      expect(parseHexColor(null), equals(const Color(0xFF2563EB)));
      expect(
        parseHexColor('bad', fallback: const Color(0xFF00FF00)),
        equals(const Color(0xFF00FF00)),
      );
    });

    test('Valid full portfolio JSON parses accurately', () {
      final json = {
        'profile': {
          'name': 'Adharsh P S',
          'role': 'Flutter Mobile Developer',
          'headlineGreeting': '// hello, world',
          'tagline': 'I build fast apps.',
          'avatarImage': 'assets/images/me.png',
          'email': 'adharshps000@gmail.com',
          'phone': '+91 8138987626',
          'location': 'Kerala, India',
          'github': 'https://github.com/AdharshPS',
          'linkedin': 'https://linkedin.com/in/adharshzps',
          'cv': {
            'fileName': 'resume.pdf',
            'downloadUrl': 'https://example.com/cv.pdf',
          },
        },
        'about': {
          'intro': 'Intro text',
          'journey': 'Journey paragraph 1\nJourney paragraph 2',
        },
        'stats': [
          {'value': '1.5+', 'label': 'Years experience'},
          {'value': '3+', 'label': 'Projects shipped'},
        ],
        'skills': {
          'Core Flutter': ['Flutter', 'Dart'],
          'Backend': ['REST', 'Dio'],
        },
        'projects': [
          {
            'title': 'NoteFlow',
            'description': 'Offline notes',
            'type': 'Open Source',
            'tags': ['Flutter', 'Hive'],
            'github': 'https://github.com/AdharshPS/notes',
            'deploy': {
              'web': 'https://notes.web',
              'playstore': '',
              'appstore': '',
              'apk': '',
            },
            'thumbnail': 'assets/images/projects/noteflow.png',
            'accentColor': '#2563EB',
          },
        ],
        'experience': [
          {
            'role': 'Flutter Developer',
            'company': 'Avanzo',
            'period': '2023 - Present',
            'points': ['Point 1', 'Point 2'],
          },
        ],
        'testimonials': [
          {'quote': 'Great work', 'name': 'Colleague', 'role': 'Lead'},
        ],
        'seoAndMeta': {
          'siteTitle': 'Adharsh Portfolio',
          'metaDescription': 'Test meta',
        },
        'contactForm': {'serviceType': 'none', 'endpointOrAction': ''},
      };

      final data = PortfolioData.fromJson(json);

      expect(data.profile.name, equals('Adharsh P S'));
      expect(data.profile.role, equals('Flutter Mobile Developer'));
      expect(
        data.profile.cv?.downloadUrl,
        equals('https://example.com/cv.pdf'),
      );
      expect(data.about.intro, equals('Intro text'));
      expect(data.stats.length, equals(2));
      expect(data.skills.length, equals(2));
      expect(data.skills[0].name, equals('Core Flutter'));
      expect(data.skills[0].items, equals(['Flutter', 'Dart']));
      expect(data.projects.length, equals(1));
      expect(data.projects[0].title, equals('NoteFlow'));
      expect(data.projects[0].gradient.length, equals(2));
      expect(
        data.projects[0].links['GitHub'],
        equals('https://github.com/AdharshPS/notes'),
      );
      expect(data.projects[0].links['Live Demo'], equals('https://notes.web'));
      expect(data.experience.length, equals(1));
      expect(data.testimonials.length, equals(1));
      expect(data.seoAndMeta.siteTitle, equals('Adharsh Portfolio'));

      // Test roundtrip serialization
      final reencoded = data.toJson();
      final roundtrip = PortfolioData.fromJson(reencoded);
      expect(roundtrip.profile.name, equals(data.profile.name));
      expect(roundtrip.projects.first.title, equals(data.projects.first.title));
    });

    test('Missing optional fields parse safely with nulls and defaults', () {
      final json = {
        'profile': {
          'name': 'Adharsh P S',
          'email': '',
          'github': null,
          'cv': null,
        },
        // about, stats, skills, projects all missing
      };

      final data = PortfolioData.fromJson(json);
      expect(data.profile.name, equals('Adharsh P S'));
      expect(data.profile.email, isNull);
      expect(data.profile.github, isNull);
      expect(data.profile.cv, isNull);
      expect(data.about.intro, isEmpty);
      expect(data.stats, isEmpty);
      expect(data.skills, isEmpty);
      expect(data.projects, isEmpty);
    });

    test('Empty strings or nulls hide project links and buttons', () {
      final project = Project.fromJson({
        'title': 'Test Project',
        'github': '',
        'deploy': {'web': '', 'playstore': '', 'appstore': '', 'apk': ''},
      });

      expect(project.links.isEmpty, isTrue);
    });

    test('Invalid data: missing profile.name throws FormatException', () {
      final noName = {
        'profile': {'name': ''},
      };
      expect(() => PortfolioData.fromJson(noName), throwsFormatException);

      final noProfile = <String, dynamic>{};
      expect(() => PortfolioData.fromJson(noProfile), throwsFormatException);
    });

    test('Bad list item is skipped and never fails the whole parse', () {
      final jsonWithCorruptedItems = {
        'profile': {'name': 'Adharsh P S'},
        'stats': [
          {'value': '1.5+', 'label': 'Years'},
          'completely invalid stat item',
          null,
          {'value': '3+', 'label': 'Projects'},
        ],
        'projects': [
          {'title': 'Valid Project 1', 'type': 'Open Source'},
          null,
          12345,
          {'title': 'Valid Project 2', 'type': 'Consumer'},
        ],
        'experience': [
          {
            'role': 'Developer',
            'company': 'Avanzo',
            'points': ['p1'],
          },
          'broken experience item',
        ],
        'testimonials': [
          {'quote': 'Great', 'name': 'John'},
          true,
        ],
      };

      final data = PortfolioData.fromJson(jsonWithCorruptedItems);
      expect(data.stats.length, equals(2));
      expect(data.stats[0].label, equals('Years'));
      expect(data.stats[1].label, equals('Projects'));
      expect(data.projects.length, equals(2));
      expect(data.projects[0].title, equals('Valid Project 1'));
      expect(data.projects[1].title, equals('Valid Project 2'));
      expect(data.experience.length, equals(1));
      expect(data.testimonials.length, equals(1));
    });
  });
}
