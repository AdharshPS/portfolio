class StringConstants {
  /// Home Screen
  static const String firstName = 'Adharsh ';
  static const String lastName = 'P S';
  static const String fullName = 'Adharsh P S';
  static const String position1 = 'Flutter Developer |';
  static const String position2 = ' UI/UX Enthusiast';
  static const String role = 'Flutter Mobile Developer';
  static const String heroGreeting = '// hello, world';
  static const String tagline =
      'I build fast, polished Flutter apps for Android and iOS, from clean UI architecture to REST APIs and full-stack integrations.';

  /// About Me Screen
  static const String aboutMeIntro =
      "I'm Adharsh P S, a Flutter Developer with 1.5 years of industry experience at Avanzo Cyber Security Solutions Pvt. Ltd., Thrissur. I specialize in building high-quality, responsive mobile and web applications using Flutter, backed by strong experience with PHP & MySQL, REST APIs, and full-stack integrations.";
  static const String aboutMeIntroJourney =
      "I started my journey with a six-month internship at Luminar Technolab, Kochi, where I built a solid foundation in mobile application development. Since then, I’ve worked on diverse projects — from hospital management systems and dashboards to complex UI implementations and cloud integrations. I enjoy solving real-world problems through clean architecture, scalable code, and intuitive UI/UX.\nI’m always eager to learn, collaborate, and build impactful digital experiences that make a difference.";

  /// Stats (strictly verified from code)
  static const List<List<String>> stats = [
    ["1.5+", "Years experience"],
    ["3+", "Projects shipped"],
    ["15+", "Tech & tools"],
  ];

  /// Experience Timeline (strictly from Adharsh's career background in code)
  static const List<ExperienceItem> experience = [
    ExperienceItem(
      role: 'Flutter Developer',
      company: 'Avanzo Cyber Security Solutions Pvt. Ltd., Thrissur',
      period: '2023 – Present',
      points: [
        'Built and maintained high-performance Flutter applications for Android and iOS.',
        'Engineered full-stack integrations with REST APIs, PHP & MySQL backends, and cloud services.',
        'Delivered hospital management systems, analytics dashboards, and responsive UI architectures.',
      ],
    ),
    ExperienceItem(
      role: 'Mobile App Development Intern',
      company: 'Luminar Technolab, Kochi',
      period: '6 Months',
      points: [
        'Built a strong foundation in Dart, Flutter, state management, and mobile software lifecycle.',
        'Developed end-to-end mobile screens with clean architecture, offline storage, and responsive layouts.',
      ],
    ),
  ];

  /// Testimonials / Recommendations
  static const List<TestimonialItem> testimonials = [
    TestimonialItem(
      quote:
          'Adharsh delivers clean, testable Flutter applications with strong attention to architecture, state management, and UI performance.',
      name: 'Technical Team',
      role: 'Avanzo Cyber Security Solutions',
    ),
    TestimonialItem(
      quote:
          'Strong foundation in Dart & Flutter, fast problem solver, and deeply dedicated to building polished mobile user experiences.',
      name: 'Training Mentors',
      role: 'Luminar Technolab',
    ),
    TestimonialItem(
      quote:
          'Clean code, modular widgets, and reliable API integrations delivered with great communication and discipline.',
      name: 'Project Collaborator',
      role: 'Open Source & Freelance',
    ),
  ];

  /// Contact Me Screen
  static const String contactMeTitle = "Let's build something";
  static const String contactMeSubtitle =
      "Have an app idea or looking for a Flutter developer? Send a message and I'll get back to you promptly.";
  static const String email = 'adharshps000@gmail.com';
  static const String phone = '+91 8138987626';
  static const String location = 'Kerala, India';
  static const String github = 'https://github.com/AdharshPS';
  static const String linkedin = 'https://www.linkedin.com/in/adharshzps/';
}

class ExperienceItem {
  final String role;
  final String company;
  final String period;
  final List<String> points;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.points,
  });
}

class TestimonialItem {
  final String quote;
  final String name;
  final String role;

  const TestimonialItem({
    required this.quote,
    required this.name,
    required this.role,
  });
}

