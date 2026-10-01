import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/contact_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/services/download_cv_service.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onViewProjectsTap;

  const HomeScreen({super.key, this.onViewProjectsTap});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bg(context),
        gradient: RadialGradient(
          center: const Alignment(0.8, -0.6),
          radius: 1.2,
          colors: [
            AppColors.primaryColor(
              context,
            ).withValues(alpha: isDark ? 0.18 : 0.09),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : (isTablet ? 40 : 20),
        vertical: isDesktop ? 100 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 12,
                      child: _HeroContent(
                        onViewProjectsTap: onViewProjectsTap,
                        onLaunch: _launch,
                      ),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(flex: 8, child: _PhoneMockup()),
                  ],
                )
              : Column(
                  children: [
                    _HeroContent(
                      onViewProjectsTap: onViewProjectsTap,
                      onLaunch: _launch,
                    ),
                    const SizedBox(height: 50),
                    const _PhoneMockup(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final VoidCallback? onViewProjectsTap;
  final Function(String) onLaunch;

  const _HeroContent({required this.onViewProjectsTap, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 640;
    final primaryInk = AppColors.primaryInk(context);
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final portfolio = PortfolioScope.dataOf(context);
    final profile = portfolio.profile;

    final greeting = profile.headlineGreeting.isNotEmpty
        ? profile.headlineGreeting
        : StringConstants.heroGreeting;
    final name = profile.name.isNotEmpty
        ? profile.name
        : StringConstants.fullName;
    final role = profile.role.isNotEmpty ? profile.role : StringConstants.role;
    final tagline = profile.tagline.isNotEmpty
        ? profile.tagline
        : StringConstants.tagline;

    final githubUrl = profile.github ?? ContactConstants.github;
    final linkedinUrl = profile.linkedin ?? ContactConstants.linkedin;
    final emailAddress = profile.email ?? ContactConstants.email;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Greeting // hello, world
        Text(
          greeting,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryInk,
            letterSpacing: 0.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 12),

        // Headline
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: isMobile ? 36 : 56,
              fontWeight: FontWeight.w800,
              height: 1.12,
              letterSpacing: -1.2,
              color: text,
            ),
            children: [
              TextSpan(text: "I'm $name,\n"),
              TextSpan(
                text: role,
                style: TextStyle(color: primaryInk),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tagline
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            tagline,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              height: 1.6,
              color: muted,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
        ),
        const SizedBox(height: 32),

        // CTA Buttons
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _ButtonPrimary(
              label: 'View projects',
              icon: Icons.arrow_forward_rounded,
              onTap: onViewProjectsTap ?? () {},
            ),
            _ButtonGhost(
              label: 'Download resume',
              icon: Icons.file_download_outlined,
              onTap: () => downloadCV(context, cvInfo: profile.cv),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Social pills (hide if absent or empty)
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (githubUrl.trim().isNotEmpty)
              _SocialPill(
                label: 'GitHub',
                icon: Icons.code_rounded,
                onTap: () => onLaunch(githubUrl.trim()),
              ),
            if (linkedinUrl.trim().isNotEmpty)
              _SocialPill(
                label: 'LinkedIn',
                icon: Icons.link_rounded,
                onTap: () => onLaunch(linkedinUrl.trim()),
              ),
            if (emailAddress.trim().isNotEmpty)
              _SocialPill(
                label: 'Email',
                icon: Icons.mail_outline_rounded,
                onTap: () => onLaunch('mailto:${emailAddress.trim()}'),
              ),
          ],
        ),
      ],
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final phoneWidth = width < 360 ? 220.0 : (width < 400 ? 240.0 : 260.0);
    final phoneHeight = phoneWidth * (18.5 / 9.0);

    return Center(
      child: Transform.rotate(
        angle: 3.0 * math.pi / 180.0,
        child: Container(
          width: phoneWidth,
          height: phoneHeight,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF020617)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x472563EB),
                blurRadius: 50,
                offset: Offset(0, 24),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Internal Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // chip: flutter run
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'flutter run',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1917),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Indicator bar
                    Container(
                      height: 8,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Code Snippet Tile
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          children: const [
                            TextSpan(text: 'class '),
                            TextSpan(
                              text: 'HomePage\n',
                              style: TextStyle(
                                color: Color(0xFFFDBA74),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '  extends '),
                            TextSpan(
                              text: 'StatelessWidget',
                              style: TextStyle(
                                color: Color(0xFFFDBA74),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' {\n'),
                            TextSpan(text: '    build(ctx) => '),
                            TextSpan(
                              text: 'Scaffold',
                              style: TextStyle(
                                color: Color(0xFFFDBA74),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '();\n  }'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Badges Tile
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatusLine('✓ 60 fps'),
                          const SizedBox(height: 4),
                          _StatusLine('✓ Android + iOS'),
                          const SizedBox(height: 4),
                          _StatusLine('✓ REST APIs synced'),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Bottom indicator bars
                    Container(
                      height: 8,
                      width: 170,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),

              // Top Speaker Notch
              Positioned(
                top: 6,
                child: Container(
                  width: 70,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF020617),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String text;
  const _StatusLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.95),
      ),
    );
  }
}

class _ButtonPrimary extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ButtonPrimary({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<_ButtonPrimary> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()
            ..translateByDouble(0.0, isHovered ? -2.0 : 0.0, 0.0, 1.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF2563EB,
                ).withValues(alpha: isHovered ? 0.45 : 0.25),
                blurRadius: isHovered ? 24 : 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 380 ? 16 : 24,
            vertical: 14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonGhost extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ButtonGhost({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ButtonGhost> createState() => _ButtonGhostState();
}

class _ButtonGhostState extends State<_ButtonGhost> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final line = AppColors.line(context);
    final primary = AppColors.primaryColor(context);
    final surface = AppColors.surface(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()
            ..translateByDouble(0.0, isHovered ? -2.0 : 0.0, 0.0, 1.0),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 380 ? 16 : 24,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isHovered ? surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isHovered ? primary : line, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: text, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialPill extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final line = AppColors.line(context);
    final primary = AppColors.primaryColor(context);
    final surface = AppColors.surface(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isHovered ? surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isHovered ? primary : line, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: text),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
