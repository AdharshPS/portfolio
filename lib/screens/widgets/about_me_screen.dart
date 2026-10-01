import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/image_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    return Container(
      width: double.infinity,
      color: AppColors.surface(context),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : (isTablet ? 40 : 20),
        vertical: isDesktop ? 90 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    _AvatarBlock(),
                    const SizedBox(width: 60),

                    // Bio & Stats
                    Expanded(
                      child: _AboutContent(isMobile: false),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _AvatarBlock(),
                    const SizedBox(height: 36),
                    _AboutContent(isMobile: isMobile),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          ImageConstants.myImage,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1E293B),
            child: Center(
              child: Text(
                'AP',
                style: GoogleFonts.inter(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  final bool isMobile;
  const _AboutContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.w700,
            color: text,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          StringConstants.aboutMeIntro,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 15 : 16.5,
            height: 1.7,
            color: muted,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 12),
        Text(
          StringConstants.aboutMeIntroJourney,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 14 : 15.5,
            height: 1.7,
            color: muted,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 28),

        // Verified Stats Cards (from code)
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: StringConstants.stats.map((item) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.line(context),
                        width: 1,
                      ),
                      boxShadow: AppColors.cardShadow(context),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item[0],
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 22 : 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryInk(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item[1],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 11 : 13,
                            fontWeight: FontWeight.w500,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
