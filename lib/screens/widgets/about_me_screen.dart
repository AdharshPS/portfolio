import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/image_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:portfolio_new/widgets/portfolio_image.dart';

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
                    const _AvatarBlock(),
                    const SizedBox(width: 60),

                    // Bio & Stats
                    const Expanded(child: _AboutContent(isMobile: false)),
                  ],
                )
              : Column(
                  children: [
                    const _AvatarBlock(),
                    const SizedBox(height: 36),
                    _AboutContent(isMobile: isMobile),
                  ],
                ),
        ),
      ),
    );
  }
}

String _getInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts[0].isEmpty) return 'AP';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock();

  @override
  Widget build(BuildContext context) {
    final portfolio = PortfolioScope.dataOf(context);
    final profile = portfolio.profile;

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
        child: PortfolioImage(
          imagePath: profile.avatarImage,
          fallbackAsset: ImageConstants.myImage,
          width: 212,
          height: 212,
          fit: BoxFit.cover,
          fallbackWidget: Container(
            color: const Color(0xFF1E293B),
            child: Center(
              child: Text(
                _getInitials(profile.name),
                style: AppTypography.inter(
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
    final portfolio = PortfolioScope.dataOf(context);
    final about = portfolio.about;

    final intro = about.intro.isNotEmpty
        ? about.intro
        : StringConstants.aboutMeIntro;
    final journey = about.journey.isNotEmpty
        ? about.journey
        : StringConstants.aboutMeIntroJourney;

    final statsList = portfolio.stats.isNotEmpty
        ? portfolio.stats.map((s) => [s.value, s.label]).toList()
        : StringConstants.stats;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: AppTypography.inter(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.w700,
            color: text,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          intro,
          style: AppTypography.inter(
            fontSize: isMobile ? 15 : 16.5,
            height: 1.7,
            color: muted,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 12),
        Text(
          journey,
          style: AppTypography.inter(
            fontSize: isMobile ? 14 : 15.5,
            height: 1.7,
            color: muted,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 28),

        // Stats Cards
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: statsList.map((item) {
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
                          style: AppTypography.inter(
                            fontSize: isMobile ? 22 : 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryInk(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item[1],
                          textAlign: TextAlign.center,
                          style: AppTypography.inter(
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
