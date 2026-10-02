import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/skill_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

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
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'Skills',
                style: AppTypography.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The tools and frameworks I reach for to build, connect and ship production mobile apps.',
                style: AppTypography.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 36),

              // Responsive Skills Grid with dynamic column count and IntrinsicHeight rows
              LayoutBuilder(
                builder: (context, constraints) {
                  final portfolio = PortfolioScope.dataOf(context);
                  final categories = portfolio.skills.isNotEmpty
                      ? portfolio.skills
                      : SkillConstants.skills.entries
                            .map(
                              (e) => SkillCategory(name: e.key, items: e.value),
                            )
                            .toList();

                  final availableWidth = constraints.maxWidth;
                  final int columnCount = availableWidth >= 600 ? 2 : 1;
                  const spacing = 20.0;
                  final cardWidth = columnCount == 1
                      ? availableWidth
                      : (availableWidth - (columnCount - 1) * spacing) /
                          columnCount;

                  final rows = <Widget>[];
                  for (int i = 0; i < categories.length; i += columnCount) {
                    final chunk = categories.sublist(
                      i,
                      math.min(i + columnCount, categories.length),
                    );

                    final rowChildren = <Widget>[];
                    for (int col = 0; col < columnCount; col++) {
                      if (col > 0) {
                        rowChildren.add(const SizedBox(width: spacing));
                      }
                      if (col < chunk.length) {
                        rowChildren.add(
                          Expanded(
                            child: _SkillCategoryCard(
                              title: chunk[col].name,
                              skills: chunk[col].items,
                              cardWidth: cardWidth,
                            ),
                          ),
                        );
                      } else {
                        rowChildren.add(
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                        );
                      }
                    }

                    if (rows.isNotEmpty) {
                      rows.add(const SizedBox(height: spacing));
                    }

                    rows.add(
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: rowChildren,
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rows,
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

class _SkillCategoryCard extends StatefulWidget {
  final String title;
  final List<String> skills;
  final double cardWidth;

  const _SkillCategoryCard({
    required this.title,
    required this.skills,
    this.cardWidth = 400.0,
  });

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final innerWidth = math.max(100.0, widget.cardWidth - 48.0);

    // Measure Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: widget.title,
        style: AppTypography.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: innerWidth);
    final titleHeight = titlePainter.height;

    // Measure Skills Wrap
    double chipsHeight = 0.0;
    if (widget.skills.isNotEmpty) {
      double currentLineWidth = 0;
      double currentLineMaxHeight = 0;
      for (final skill in widget.skills) {
        final skillPainter = TextPainter(
          text: TextSpan(
            text: skill,
            style: AppTypography.mono(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout(maxWidth: math.max(40.0, innerWidth - 24.0));
        final chipW = math.min(innerWidth, skillPainter.width + 24.0);
        final chipH = skillPainter.height + 12.0;

        if (currentLineWidth > 0 &&
            currentLineWidth + 8.0 + chipW > innerWidth) {
          chipsHeight += currentLineMaxHeight + 8.0;
          currentLineWidth = chipW;
          currentLineMaxHeight = chipH;
        } else {
          currentLineWidth += (currentLineWidth > 0 ? 8.0 : 0.0) + chipW;
          currentLineMaxHeight = math.max(currentLineMaxHeight, chipH);
        }
      }
      chipsHeight += currentLineMaxHeight;
    }

    final estimatedMinHeight =
        48.0 + titleHeight + 16.0 + chipsHeight + 20.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: estimatedMinHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0.0, isHovered ? -4.0 : 0.0, 0.0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? AppColors.primaryColor(context).withValues(alpha: 0.5)
                  : AppColors.line(context),
              width: 1.2,
            ),
            boxShadow: isHovered
                ? AppColors.cardShadowHover(context)
                : AppColors.cardShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppTypography.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text(context),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.skills.map((skill) {
                  return _SkillChip(
                    label: skill,
                    maxChipWidth: innerWidth,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final double maxChipWidth;
  const _SkillChip({
    required this.label,
    this.maxChipWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor(context);
    final primaryInk = AppColors.primaryInk(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxChipWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: primary.withValues(alpha: 0.22), width: 1),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.mono(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: primaryInk,
        ),
      ),
    );
  }
}
