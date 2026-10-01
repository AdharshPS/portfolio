import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';

class FooterWidget extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;

  const FooterWidget({
    super.key,
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final isDesktop = MediaQuery.of(context).size.width >= 640;
    final muted = AppColors.muted(context);
    final line = AppColors.line(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bg(context),
        border: Border(
          top: BorderSide(color: line, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© $year ${StringConstants.fullName}. Built with care.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: muted,
                      ),
                    ),
                    _FooterNavLinks(
                      onHomeTap: onHomeTap,
                      onAboutTap: onAboutTap,
                      onSkillsTap: onSkillsTap,
                      onProjectsTap: onProjectsTap,
                      onExperienceTap: onExperienceTap,
                      onContactTap: onContactTap,
                    ),
                  ],
                )
              : Column(
                  children: [
                    _FooterNavLinks(
                      onHomeTap: onHomeTap,
                      onAboutTap: onAboutTap,
                      onSkillsTap: onSkillsTap,
                      onProjectsTap: onProjectsTap,
                      onExperienceTap: onExperienceTap,
                      onContactTap: onContactTap,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '© $year ${StringConstants.fullName}. Built with care.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: muted,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _FooterNavLinks extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;

  const _FooterNavLinks({
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _FooterLink(label: 'Home', onTap: onHomeTap),
        _FooterLink(label: 'About', onTap: onAboutTap),
        _FooterLink(label: 'Skills', onTap: onSkillsTap),
        _FooterLink(label: 'Projects', onTap: onProjectsTap),
        _FooterLink(label: 'Experience', onTap: onExperienceTap),
        _FooterLink(label: 'Contact', onTap: onContactTap),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isHovered
                ? AppColors.primaryInk(context)
                : AppColors.muted(context),
          ),
        ),
      ),
    );
  }
}
