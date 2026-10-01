import 'package:flutter/material.dart';

Color parseHexColor(dynamic hex, {Color fallback = const Color(0xFF2563EB)}) {
  if (hex == null) return fallback;
  var hexStr = hex.toString().trim().replaceAll('#', '').replaceAll('0x', '');
  if (hexStr.length == 6) {
    hexStr = 'FF$hexStr';
  }
  if (hexStr.length == 8) {
    final val = int.tryParse(hexStr, radix: 16);
    if (val != null) return Color(val);
  }
  return fallback;
}

class PortfolioData {
  final Profile profile;
  final About about;
  final List<Stat> stats;
  final List<SkillCategory> skills;
  final List<Project> projects;
  final List<Experience> experience;
  final List<Testimonial> testimonials;
  final SeoMeta seoAndMeta;
  final ContactFormConfig contactForm;

  const PortfolioData({
    required this.profile,
    required this.about,
    required this.stats,
    required this.skills,
    required this.projects,
    required this.experience,
    required this.testimonials,
    required this.seoAndMeta,
    required this.contactForm,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    final profileJson = json['profile'] as Map<String, dynamic>?;
    if (profileJson == null) {
      throw const FormatException('Missing required section: profile');
    }

    final profile = Profile.fromJson(profileJson);
    if (profile.name.trim().isEmpty) {
      throw const FormatException('Missing required field: profile.name');
    }

    final about = json['about'] is Map<String, dynamic>
        ? About.fromJson(json['about'] as Map<String, dynamic>)
        : const About.empty();

    final stats = <Stat>[];
    if (json['stats'] is List) {
      for (final item in json['stats'] as List) {
        if (item is Map<String, dynamic>) {
          try {
            stats.add(Stat.fromJson(item));
          } catch (_) {}
        }
      }
    }

    final skills = <SkillCategory>[];
    if (json['skills'] is Map<String, dynamic>) {
      final skillsMap = json['skills'] as Map<String, dynamic>;
      for (final entry in skillsMap.entries) {
        try {
          final items = <String>[];
          if (entry.value is List) {
            for (final sub in entry.value as List) {
              if (sub != null && sub.toString().trim().isNotEmpty) {
                items.add(sub.toString().trim());
              }
            }
          }
          skills.add(SkillCategory(name: entry.key, items: items));
        } catch (_) {}
      }
    }

    final projects = <Project>[];
    if (json['projects'] is List) {
      for (final item in json['projects'] as List) {
        if (item is Map<String, dynamic>) {
          try {
            projects.add(Project.fromJson(item));
          } catch (_) {}
        }
      }
    }

    final experience = <Experience>[];
    if (json['experience'] is List) {
      for (final item in json['experience'] as List) {
        if (item is Map<String, dynamic>) {
          try {
            experience.add(Experience.fromJson(item));
          } catch (_) {}
        }
      }
    }

    final testimonials = <Testimonial>[];
    if (json['testimonials'] is List) {
      for (final item in json['testimonials'] as List) {
        if (item is Map<String, dynamic>) {
          try {
            testimonials.add(Testimonial.fromJson(item));
          } catch (_) {}
        }
      }
    }

    final seoAndMeta = json['seoAndMeta'] is Map<String, dynamic>
        ? SeoMeta.fromJson(json['seoAndMeta'] as Map<String, dynamic>)
        : const SeoMeta.empty();

    final contactForm = json['contactForm'] is Map<String, dynamic>
        ? ContactFormConfig.fromJson(
            json['contactForm'] as Map<String, dynamic>,
          )
        : const ContactFormConfig.empty();

    return PortfolioData(
      profile: profile,
      about: about,
      stats: stats,
      skills: skills,
      projects: projects,
      experience: experience,
      testimonials: testimonials,
      seoAndMeta: seoAndMeta,
      contactForm: contactForm,
    );
  }

  Map<String, dynamic> toJson() {
    final skillsMap = <String, List<String>>{};
    for (final cat in skills) {
      skillsMap[cat.name] = cat.items;
    }

    return {
      'profile': profile.toJson(),
      'about': about.toJson(),
      'stats': stats.map((s) => s.toJson()).toList(),
      'skills': skillsMap,
      'projects': projects.map((p) => p.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
      'testimonials': testimonials.map((t) => t.toJson()).toList(),
      'seoAndMeta': seoAndMeta.toJson(),
      'contactForm': contactForm.toJson(),
    };
  }

  factory PortfolioData.defaults() {
    return const PortfolioData(
      profile: Profile(
        name: 'Adharsh P S',
        role: 'Flutter Mobile Developer',
        headlineGreeting: '// hello, world',
        tagline:
            'I build fast, polished Flutter apps for Android and iOS, from clean UI architecture to REST APIs and full-stack integrations.',
        avatarImage: 'assets/images/me.png',
        email: 'adharshps000@gmail.com',
        phone: '+91 8138987626',
        location: 'Kerala, India',
        github: 'https://github.com/AdharshPS',
        linkedin: 'https://www.linkedin.com/in/adharshzps/',
        cv: CvInfo(
          fileName: 'Adharsh_PS_Flutter_Developer_Resume.pdf',
          downloadUrl:
              'https://drive.google.com/uc?export=download&id=1RFc9qpkNY7QelQ_2ZleT2xBEgNiuv6DG',
        ),
      ),
      about: About(
        intro:
            "I'm Adharsh P S, a Flutter Developer with 1.5 years of industry experience at Avanzo Cyber Security Solutions Pvt. Ltd., Thrissur. I specialize in building high-quality, responsive mobile and web applications using Flutter, backed by strong experience with PHP & MySQL, REST APIs, and full-stack integrations.",
        journey:
            "I started my journey with a six-month internship at Luminar Technolab, Kochi, where I built a solid foundation in mobile application development. Since then, I've worked on diverse projects — from hospital management systems and dashboards to complex UI implementations and cloud integrations. I enjoy solving real-world problems through clean architecture, scalable code, and intuitive UI/UX.\nI'm always eager to learn, collaborate, and build impactful digital experiences that make a difference.",
      ),
      stats: [
        Stat(value: '1.5+', label: 'Years experience'),
        Stat(value: '3+', label: 'Projects shipped'),
        Stat(value: '15+', label: 'Tech & tools'),
      ],
      skills: [
        SkillCategory(
          name: 'Core Flutter',
          items: [
            'Flutter',
            'Dart',
            'Provider',
            'Material 3',
            'Responsive UI',
            'Clean Architecture',
          ],
        ),
        SkillCategory(
          name: 'Backend & Data',
          items: [
            'REST APIs',
            'Dio',
            'Firebase',
            'Hive',
            'Sqflite',
            'PHP & MySQL',
          ],
        ),
        SkillCategory(
          name: 'Security & Storage',
          items: [
            'Flutter Secure Storage',
            'Shared Preferences',
            'Offline Sync',
            'Token Refresh Flows',
          ],
        ),
        SkillCategory(
          name: 'Delivery & Tools',
          items: [
            'Git / GitHub',
            'CI/CD (GitHub Actions)',
            'Play Store & App Store',
            'Postman',
            'Hoppscotch',
          ],
        ),
      ],
      projects: [],
      experience: [],
      testimonials: [],
      seoAndMeta: SeoMeta(
        siteTitle: 'Adharsh P S | Flutter Mobile Developer',
        metaDescription:
            'Portfolio of Adharsh P S, a Flutter developer building polished, high-performance mobile and web applications.',
        canonicalUrl: 'https://adharshps.dev',
        ogImage: 'assets/images/og-preview.png',
        favicon: 'me.png',
        themeColor: '#0B1220',
      ),
      contactForm: ContactFormConfig(serviceType: 'none', endpointOrAction: ''),
    );
  }
}

class Profile {
  final String name;
  final String role;
  final String headlineGreeting;
  final String tagline;
  final String avatarImage;
  final String? email;
  final String? phone;
  final String? location;
  final String? github;
  final String? linkedin;
  final CvInfo? cv;

  const Profile({
    required this.name,
    this.role = '',
    this.headlineGreeting = '// hello, world',
    this.tagline = '',
    this.avatarImage = 'assets/images/me.png',
    this.email,
    this.phone,
    this.location,
    this.github,
    this.linkedin,
    this.cv,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: (json['name'] as String?)?.trim() ?? '',
      role: (json['role'] as String?)?.trim() ?? '',
      headlineGreeting:
          (json['headlineGreeting'] as String?)?.trim() ?? '// hello, world',
      tagline: (json['tagline'] as String?)?.trim() ?? '',
      avatarImage:
          (json['avatarImage'] as String?)?.trim() ?? 'assets/images/me.png',
      email: _cleanString(json['email']),
      phone: _cleanString(json['phone']),
      location: _cleanString(json['location']),
      github: _cleanString(json['github']),
      linkedin: _cleanString(json['linkedin']),
      cv: json['cv'] is Map<String, dynamic>
          ? CvInfo.fromJson(json['cv'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'headlineGreeting': headlineGreeting,
      'tagline': tagline,
      'avatarImage': avatarImage,
      'email': email ?? '',
      'phone': phone ?? '',
      'location': location ?? '',
      'github': github ?? '',
      'linkedin': linkedin ?? '',
      if (cv != null) 'cv': cv!.toJson(),
    };
  }
}

class CvInfo {
  final String fileName;
  final String downloadUrl;

  const CvInfo({
    this.fileName = 'Adharsh_PS_Flutter_Developer_Resume.pdf',
    required this.downloadUrl,
  });

  factory CvInfo.fromJson(Map<String, dynamic> json) {
    return CvInfo(
      fileName:
          (json['fileName'] as String?)?.trim() ??
          'Adharsh_PS_Flutter_Developer_Resume.pdf',
      downloadUrl: (json['downloadUrl'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'fileName': fileName, 'downloadUrl': downloadUrl};
  }
}

class About {
  final String intro;
  final String journey;

  const About({this.intro = '', this.journey = ''});

  const About.empty() : intro = '', journey = '';

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      intro: (json['intro'] as String?) ?? '',
      journey: (json['journey'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'intro': intro, 'journey': journey};
  }
}

class Stat {
  final String value;
  final String label;

  const Stat({required this.value, required this.label});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      value: (json['value']?.toString()) ?? '',
      label: (json['label'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label};
  }
}

class SkillCategory {
  final String name;
  final List<String> items;

  const SkillCategory({required this.name, required this.items});
}

class Deploy {
  final String web;
  final String playstore;
  final String appstore;
  final String apk;

  const Deploy({
    this.web = '',
    this.playstore = '',
    this.appstore = '',
    this.apk = '',
  });

  const Deploy.empty() : web = '', playstore = '', appstore = '', apk = '';

  factory Deploy.fromJson(Map<String, dynamic> json) {
    return Deploy(
      web: (json['web'] as String?)?.trim() ?? '',
      playstore: (json['playstore'] as String?)?.trim() ?? '',
      appstore: (json['appstore'] as String?)?.trim() ?? '',
      apk: (json['apk'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'web': web,
      'playstore': playstore,
      'appstore': appstore,
      'apk': apk,
    };
  }
}

class Project {
  final String title;
  final String description;
  final String type;
  final List<String> tags;
  final String github;
  final Deploy deploy;
  final String thumbnail;
  final String accentColorHex;
  final Color accentColor;

  const Project({
    required this.title,
    required this.description,
    required this.type,
    required this.tags,
    required this.github,
    required this.deploy,
    required this.thumbnail,
    required this.accentColorHex,
    required this.accentColor,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?)?.trim() ?? '';
    final description = (json['description'] as String?)?.trim() ?? '';
    final type = (json['type'] as String?)?.trim() ?? 'Other';
    final github = (json['github'] as String?)?.trim() ?? '';
    final thumbnail = (json['thumbnail'] as String?)?.trim() ?? '';
    final accentHex = (json['accentColor'] as String?)?.trim() ?? '#2563EB';

    final tags = <String>[];
    if (json['tags'] is List) {
      for (final t in json['tags'] as List) {
        if (t != null && t.toString().trim().isNotEmpty) {
          tags.add(t.toString().trim());
        }
      }
    }

    final deploy = json['deploy'] is Map<String, dynamic>
        ? Deploy.fromJson(json['deploy'] as Map<String, dynamic>)
        : const Deploy.empty();

    return Project(
      title: title,
      description: description,
      type: type,
      tags: tags,
      github: github,
      deploy: deploy,
      thumbnail: thumbnail,
      accentColorHex: accentHex,
      accentColor: parseHexColor(accentHex),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'tags': tags,
      'github': github,
      'deploy': deploy.toJson(),
      'thumbnail': thumbnail,
      'accentColor': accentColorHex,
    };
  }

  List<Color> get gradient {
    return [
      Color.lerp(accentColor, Colors.white, 0.75) ?? const Color(0xFFBFDBFE),
      Color.lerp(accentColor, Colors.white, 0.55) ?? const Color(0xFF93C5FD),
    ];
  }

  Map<String, String> get links {
    final result = <String, String>{};
    if (github.isNotEmpty) result['GitHub'] = github;
    if (deploy.web.isNotEmpty) result['Live Demo'] = deploy.web;
    if (deploy.playstore.isNotEmpty) result['Play Store'] = deploy.playstore;
    if (deploy.appstore.isNotEmpty) result['App Store'] = deploy.appstore;
    if (deploy.apk.isNotEmpty) result['APK'] = deploy.apk;
    return result;
  }
}

class Experience {
  final String role;
  final String company;
  final String period;
  final List<String> points;

  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.points,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    final points = <String>[];
    if (json['points'] is List) {
      for (final p in json['points'] as List) {
        if (p != null && p.toString().trim().isNotEmpty) {
          points.add(p.toString().trim());
        }
      }
    }

    return Experience(
      role: (json['role'] as String?)?.trim() ?? '',
      company: (json['company'] as String?)?.trim() ?? '',
      period: (json['period'] as String?)?.trim() ?? '',
      points: points,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'period': period,
      'points': points,
    };
  }
}

class Testimonial {
  final String quote;
  final String name;
  final String role;

  const Testimonial({
    required this.quote,
    required this.name,
    required this.role,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      quote: (json['quote'] as String?)?.trim() ?? '',
      name: (json['name'] as String?)?.trim() ?? '',
      role: (json['role'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'quote': quote, 'name': name, 'role': role};
  }
}

class SeoMeta {
  final String siteTitle;
  final String metaDescription;
  final String canonicalUrl;
  final String ogImage;
  final String favicon;
  final String themeColor;

  const SeoMeta({
    this.siteTitle = 'Adharsh P S | Flutter Mobile Developer',
    this.metaDescription = '',
    this.canonicalUrl = '',
    this.ogImage = '',
    this.favicon = '',
    this.themeColor = '#0B1220',
  });

  const SeoMeta.empty()
    : siteTitle = 'Adharsh P S | Flutter Mobile Developer',
      metaDescription = '',
      canonicalUrl = '',
      ogImage = '',
      favicon = '',
      themeColor = '#0B1220';

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      siteTitle:
          (json['siteTitle'] as String?)?.trim() ??
          'Adharsh P S | Flutter Mobile Developer',
      metaDescription: (json['metaDescription'] as String?)?.trim() ?? '',
      canonicalUrl: (json['canonicalUrl'] as String?)?.trim() ?? '',
      ogImage: (json['ogImage'] as String?)?.trim() ?? '',
      favicon: (json['favicon'] as String?)?.trim() ?? '',
      themeColor: (json['themeColor'] as String?)?.trim() ?? '#0B1220',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteTitle': siteTitle,
      'metaDescription': metaDescription,
      'canonicalUrl': canonicalUrl,
      'ogImage': ogImage,
      'favicon': favicon,
      'themeColor': themeColor,
    };
  }
}

class ContactFormConfig {
  final String serviceType;
  final String endpointOrAction;

  const ContactFormConfig({
    this.serviceType = 'none',
    this.endpointOrAction = '',
  });

  const ContactFormConfig.empty() : serviceType = 'none', endpointOrAction = '';

  factory ContactFormConfig.fromJson(Map<String, dynamic> json) {
    return ContactFormConfig(
      serviceType: (json['serviceType'] as String?)?.trim() ?? 'none',
      endpointOrAction: (json['endpointOrAction'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'serviceType': serviceType, 'endpointOrAction': endpointOrAction};
  }
}

String? _cleanString(dynamic val) {
  if (val == null) return null;
  final s = val.toString().trim();
  return s.isEmpty ? null : s;
}
