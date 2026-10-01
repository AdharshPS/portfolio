import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    final portfolio = PortfolioScope.dataOf(context);
    final experiences = portfolio.experience.isNotEmpty
        ? portfolio.experience
        : StringConstants.experience.map((e) {
            return Experience(
              role: e.role,
              company: e.company,
              period: e.period,
              points: e.points,
            );
          }).toList();

    return Container(
      width: double.infinity,
      color: AppColors.bg(context),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : (isTablet ? 40 : (size.width < 360 ? 14 : 20)),
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
                style: AppTypography.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'My professional career journey in mobile application engineering.',
                style: AppTypography.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 40),

              // Timeline Column (no nested ListView.builder shrinkWrap)
              Column(
                children: [
                  for (var index = 0; index < experiences.length; index++)
                    _TimelineTile(
                      item: experiences[index],
                      isLast: index == experiences.length - 1,
                      isMobile: isMobile,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final Experience item;
  final bool isLast;
  final bool isMobile;

  const _TimelineTile({
    required this.item,
    required this.isLast,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final line = AppColors.line(context);
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final primaryInk = AppColors.primaryInk(context);
    final indicatorWidth = isMobile ? 24.0 : 32.0;
    const dotSize = 14.0;
    final dotLeft = (indicatorWidth - dotSize) / 2;
    final lineLeft = (indicatorWidth - 2.0) / 2;
    final contentPaddingLeft = indicatorWidth + (isMobile ? 12.0 : 16.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Connecting vertical line (runs to the next dot)
        if (!isLast)
          Positioned(
            top: 4.0 + dotSize,
            bottom: -4.0,
            left: lineLeft,
            child: Container(
              width: 2.0,
              color: line,
            ),
          ),

        // Indicator dot aligned with period badge
        Positioned(
          top: 4.0,
          left: dotLeft,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
              border: Border.all(color: AppColors.bg(context), width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),

        // Timeline Content (natural height, never constrained by intrinsic pass)
        Padding(
          padding: EdgeInsets.only(
            left: contentPaddingLeft,
            bottom: isLast ? 0 : 36.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Badge
              Text(
                item.period,
                style: AppTypography.mono(
                  fontSize: isMobile ? 12 : 13,
                  fontWeight: FontWeight.w600,
                  color: primaryInk,
                ),
              ),
              const SizedBox(height: 6),

              // Role & Company
              Text(
                '${item.role} · ${item.company}',
                style: AppTypography.inter(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: text,
                ),
              ),
              const SizedBox(height: 12),

              // Points
              ...item.points.where((point) => point.trim().isNotEmpty).map((point) {
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
                          style: AppTypography.inter(
                            fontSize: isMobile ? 13.5 : 14.5,
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
      ],
    );
  }
}
