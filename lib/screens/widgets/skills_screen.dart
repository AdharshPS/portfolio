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

    final crossAxisCount = isDesktop ? 2 : (isTablet ? 2 : 1);

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

              // Responsive Skills Grid
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

                  final cardWidth = crossAxisCount == 1
                      ? constraints.maxWidth
                      : (constraints.maxWidth - (crossAxisCount - 1) * 20) /
                            crossAxisCount;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: categories.map((cat) {
                      return SizedBox(
                        width: cardWidth,
                        child: _SkillCategoryCard(
                          title: cat.name,
                          skills: cat.items,
                        ),
                      );
                    }).toList(),
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

  const _SkillCategoryCard({required this.title, required this.skills});

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, isHovered ? -4.0 : 0.0, 0.0, 1.0),
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
                return _SkillChip(label: skill);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor(context);
    final primaryInk = AppColors.primaryInk(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: primary.withValues(alpha: 0.22), width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.mono(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: primaryInk,
        ),
      ),
    );
  }
}
