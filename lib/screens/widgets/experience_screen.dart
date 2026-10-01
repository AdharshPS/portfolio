import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    return Container(
      width: double.infinity,
      color: AppColors.bg(context),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : (isTablet ? 40 : 20),
        vertical: isDesktop ? 90 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'Experience',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'My professional career journey in mobile application engineering.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 40),

              // Timeline
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: StringConstants.experience.length,
                itemBuilder: (context, index) {
                  final item = StringConstants.experience[index];
                  final isLast = index == StringConstants.experience.length - 1;

                  return _TimelineTile(
                    item: item,
                    isLast: isLast,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final ExperienceItem item;
  final bool isLast;

  const _TimelineTile({
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final line = AppColors.line(context);
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final primaryInk = AppColors.primaryInk(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Line & Dot indicator
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    border: Border.all(
                      color: AppColors.bg(context),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: line,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period Badge
                  Text(
                    item.period,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryInk,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Role & Company
                  Text(
                    '${item.role} · ${item.company}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: text,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Points
                  ...item.points.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: muted,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                height: 1.6,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
