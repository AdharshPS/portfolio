import 'package:portfolio_new/constants/contact_constants.dart';
import 'package:portfolio_new/constants/image_constants.dart';
import 'package:portfolio_new/constants/project_constants.dart';
import 'package:portfolio_new/constants/skill_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';

class PortfolioHardcodedSource {
  static PortfolioData getHardcodedData() {
    final stats = StringConstants.stats
        .map((s) => Stat(value: s[0], label: s[1]))
        .toList();

    final skills = SkillConstants.skills.entries
        .map(
          (e) => SkillCategory(name: e.key, items: List<String>.from(e.value)),
        )
        .toList();

    final projects = ProjectConstants.projects.map((p) {
      return Project(
        title: p.title,
        description: p.description,
        type: p.category,
        tags: List<String>.from(p.tags),
        github: p.gitHubUrl,
        deploy: const Deploy.empty(),
        thumbnail: p.imagePath,
        accentColorHex:
            '#${p.accentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        accentColor: p.accentColor,
      );
    }).toList();

    final experience = StringConstants.experience.map((e) {
      return Experience(
        role: e.role,
        company: e.company,
        period: e.period,
        points: List<String>.from(e.points),
      );
    }).toList();

    final testimonials = StringConstants.testimonials.map((t) {
      return Testimonial(quote: t.quote, name: t.name, role: t.role);
    }).toList();

    return PortfolioData(
      profile: Profile(
        name: StringConstants.fullName,
        role: StringConstants.role,
        headlineGreeting: StringConstants.heroGreeting,
        tagline: StringConstants.tagline,
        avatarImage: ImageConstants.myImage,
        email: ContactConstants.email,
        phone: ContactConstants.phone,
        location: ContactConstants.location,
        github: ContactConstants.github,
        linkedin: ContactConstants.linkedin,
        cv: const CvInfo(
          fileName: 'Adharsh_PS_Flutter_Developer_Resume.pdf',
          downloadUrl:
              'https://drive.google.com/uc?export=download&id=1RFc9qpkNY7QelQ_2ZleT2xBEgNiuv6DG',
        ),
      ),
      about: const About(
        intro: StringConstants.aboutMeIntro,
        journey: StringConstants.aboutMeIntroJourney,
      ),
      stats: stats,
      skills: skills,
      projects: projects,
      experience: experience,
      testimonials: testimonials,
      seoAndMeta: const SeoMeta(
        siteTitle: 'Adharsh P S | Flutter Mobile Developer',
        metaDescription:
            'Portfolio of Adharsh P S, a Flutter developer building polished, high-performance mobile and web applications.',
        canonicalUrl: 'https://adharshps.dev',
        ogImage: 'assets/images/og-preview.png',
        favicon: 'me.png',
        themeColor: '#0B1220',
      ),
      contactForm: const ContactFormConfig(
        serviceType: 'none',
        endpointOrAction: '',
      ),
    );
  }
}
