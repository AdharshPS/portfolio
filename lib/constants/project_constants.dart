import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/image_constants.dart';

class ProjectConstants {
  static final List<ProjectModel> projects = [
    ProjectModel(
      title: 'NoteFlow',
      description:
          'Lightweight offline-first notes application built with Flutter following Clean Architecture. Features Hive local storage, AI-assisted content refinement, and automated GitHub Actions CI/CD.',
      gitHubUrl: 'https://github.com/AdharshPS/notes',
      imagePath: ImageConstants.notesImage,
      category: 'Open Source',
      tags: const ['Flutter', 'Hive', 'AI Integration', 'CI/CD', 'Clean Arch'],
      accentColor: const Color(0xFF2563EB),
      gradient: const [Color(0xFFBFDBFE), Color(0xFF93C5FD)],
      links: const {
        'GitHub': 'https://github.com/AdharshPS/notes',
      },
    ),
    ProjectModel(
      title: 'Paws (Pet Marketplace)',
      description:
          'User-to-user pet marketplace enabling users to list pets, browse available listings, and connect in real time. Built with Firebase authentication, cloud Firestore, and cloud storage.',
      gitHubUrl: 'https://github.com/AdharshPS/paws_app',
      imagePath: ImageConstants.pawsImage,
      category: 'Consumer',
      tags: const ['Flutter', 'Firebase Auth', 'Firestore', 'Cloud Storage'],
      accentColor: const Color(0xFFF97316),
      gradient: const [Color(0xFFFED7AA), Color(0xFFFDBA74)],
      links: const {
        'GitHub': 'https://github.com/AdharshPS/paws_app',
      },
    ),
    ProjectModel(
      title: 'Netflix UI Clone',
      description:
          'Visually faithful recreation of the Netflix mobile interface with dynamic hero banners, categorized movie carousels, responsive layout scaling, and fluid animations.',
      gitHubUrl: 'https://github.com/AdharshPS/Netflix',
      imagePath: ImageConstants.netflixImage,
      category: 'UI/UX',
      tags: const ['Flutter', 'Responsive Layout', 'Micro-animations', 'Clean UI'],
      accentColor: const Color(0xFFEF4444),
      gradient: const [Color(0xFFFECDD3), Color(0xFFFDA4AF)],
      links: const {
        'GitHub': 'https://github.com/AdharshPS/Netflix',
      },
    ),
  ];
}

class ProjectModel {
  final String title;
  final String description;
  final String imagePath;
  final String gitHubUrl;
  final String category;
  final List<String> tags;
  final Color accentColor;
  final List<Color> gradient;
  final Map<String, String> links;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.gitHubUrl,
    required this.category,
    required this.tags,
    required this.accentColor,
    required this.gradient,
    required this.links,
  });
}

