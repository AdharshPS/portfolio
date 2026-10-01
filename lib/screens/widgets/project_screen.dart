import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/image_constants.dart';
import 'package:portfolio_new/constants/project_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:portfolio_new/widgets/portfolio_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedCategory = 'All';

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    final portfolio = PortfolioScope.dataOf(context);
    final allProjects = portfolio.projects.isNotEmpty
        ? portfolio.projects
        : ProjectConstants.projects.map((p) {
            return Project(
              title: p.title,
              description: p.description,
              type: p.category,
              tags: p.tags,
              github: p.gitHubUrl,
              deploy: const Deploy.empty(),
              thumbnail: p.imagePath,
              accentColorHex: '#2563EB',
              accentColor: p.accentColor,
            );
          }).toList();

    final distinctTypes = allProjects
        .map((p) => p.type)
        .where((t) => t.trim().isNotEmpty)
        .toSet()
        .toList();
    final categories = ['All', ...distinctTypes];

    if (!categories.contains(selectedCategory)) {
      selectedCategory = 'All';
    }

    final filteredProjects = selectedCategory == 'All'
        ? allProjects
        : allProjects
              .where(
                (p) => p.type.toLowerCase() == selectedCategory.toLowerCase(),
              )
              .toList();

    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 40.0 : 20.0);
    final availableWidth = size.width - (horizontalPadding * 2);
    final contentWidth = math.min(1200.0, math.max(0.0, availableWidth));

    final spacing = 20.0;
    final totalSpacing = (crossAxisCount - 1) * spacing;
    final cardWidth = crossAxisCount > 0
        ? (contentWidth - totalSpacing) / crossAxisCount
        : contentWidth;

    return Container(
      width: double.infinity,
      color: AppColors.surface(context),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isDesktop ? 90 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Heading
              Text(
                'Projects',
                style: AppTypography.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "A selection of applications I've designed, architected and built with Flutter.",
                style: AppTypography.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 24),

              // Filter Tabs Row
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return _FilterPill(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedCategory = cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),

              // Projects Grid
              if (filteredProjects.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No projects found in this category.',
                    style: AppTypography.inter(
                      fontSize: 15,
                      color: AppColors.muted(context),
                    ),
                  ),
                )
              else
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: spacing,
                  runSpacing: spacing,
                  children: filteredProjects.map((project) {
                    return SizedBox(
                      width: cardWidth,
                      child: _ProjectCard(project: project, onLaunch: _launch),
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

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor(context)
              : AppColors.card(context),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor(context)
                : AppColors.line(context),
            width: 1.2,
          ),
          boxShadow: isSelected ? AppColors.cardShadow(context) : null,
        ),
        child: Text(
          label,
          style: AppTypography.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.text(context),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final Function(String) onLaunch;

  const _ProjectCard({required this.project, required this.onLaunch});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final line = AppColors.line(context);
    final primaryInk = AppColors.primaryInk(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, isHovered ? -6.0 : 0.0, 0.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? AppColors.primaryColor(context).withValues(alpha: 0.5)
                : line,
            width: 1.2,
          ),
          boxShadow: isHovered
              ? AppColors.cardShadowHover(context)
              : AppColors.cardShadow(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail / Device Mockup Frame
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.project.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stylized Mini Phone Mockup
                  Container(
                    width: 76,
                    height: 126,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xF2FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF0F172A),
                        width: 3.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.project.accentColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 6,
                          width: 42,
                          decoration: BoxDecoration(
                            color: widget.project.accentColor.withValues(
                              alpha: 0.4,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: widget.project.accentColor.withValues(
                                alpha: 0.18,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: widget.project.thumbnail.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: PortfolioImage(
                                      imagePath: widget.project.thumbnail,
                                      fallbackAsset: ImageConstants.notesImage,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      fallbackWidget: const SizedBox.shrink(),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category tag badge in top right
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        widget.project.type,
                        style: AppTypography.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.title,
                    style: AppTypography.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    style: AppTypography.inter(
                      fontSize: 14,
                      height: 1.55,
                      color: muted,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Tag Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.project.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor(
                            context,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.mono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: primaryInk,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Links row (Empty string or null means absent: hide that link or button)
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: widget.project.links.entries.map((link) {
                      return InkWell(
                        onTap: () => widget.onLaunch(link.value),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              link.key,
                              style: AppTypography.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryInk,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: primaryInk,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
