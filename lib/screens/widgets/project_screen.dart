import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/project_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:portfolio_new/widgets/device_frame.dart';
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
            final lowerTags = p.tags.map((t) => t.toLowerCase()).toList();
            DeviceType deviceType = DeviceType.phone;
            if (lowerTags.any(
              (t) => t.contains('windows desktop') || t == 'desktop',
            )) {
              deviceType = DeviceType.desktop;
            } else if (lowerTags.any((t) => t == 'web')) {
              deviceType = DeviceType.web;
            }
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
              deviceType: deviceType,
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

    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 40.0 : 20.0);
    final availableWidth = size.width - (horizontalPadding * 2);
    final contentWidth = math.min(1200.0, math.max(0.0, availableWidth));

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

              // Responsive Projects Grid with dynamic column count and IntrinsicHeight rows
              LayoutBuilder(
                builder: (context, constraints) {
                  if (filteredProjects.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No projects found in this category.',
                        style: AppTypography.inter(
                          fontSize: 15,
                          color: AppColors.muted(context),
                        ),
                      ),
                    );
                  }

                  final availableGridWidth = constraints.maxWidth;
                  final int columnCount;
                  if (availableGridWidth >= 900) {
                    columnCount = 3;
                  } else if (availableGridWidth >= 580) {
                    columnCount = 2;
                  } else {
                    columnCount = 1;
                  }

                  const spacing = 20.0;
                  final cardWidth = columnCount == 1
                      ? availableGridWidth
                      : (availableGridWidth - (columnCount - 1) * spacing) /
                            columnCount;
                  final rows = <Widget>[];

                  for (
                    int i = 0;
                    i < filteredProjects.length;
                    i += columnCount
                  ) {
                    final chunk = filteredProjects.sublist(
                      i,
                      math.min(i + columnCount, filteredProjects.length),
                    );

                    final rowChildren = <Widget>[];
                    for (int col = 0; col < columnCount; col++) {
                      if (col > 0) {
                        rowChildren.add(const SizedBox(width: spacing));
                      }
                      if (col < chunk.length) {
                        rowChildren.add(
                          Expanded(
                            child: _ProjectCard(
                              project: chunk[col],
                              onLaunch: _launch,
                              cardWidth: cardWidth,
                            ),
                          ),
                        );
                      } else {
                        rowChildren.add(
                          const Expanded(child: SizedBox.shrink()),
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
  final double cardWidth;

  const _ProjectCard({
    required this.project,
    required this.onLaunch,
    this.cardWidth = 350.0,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  void _showFullDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.card(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.line(ctx), width: 1.2),
          ),
          title: Text(
            widget.project.title,
            style: AppTypography.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.text(ctx),
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Text(
                widget.project.description,
                style: AppTypography.inter(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.muted(ctx),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: AppTypography.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryInk(ctx),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final line = AppColors.line(context);
    final primaryInk = AppColors.primaryInk(context);
    final textScaler = MediaQuery.textScalerOf(context);

    final innerWidth = math.max(100.0, widget.cardWidth - 40.0);
    final thumbnailHeight = widget.cardWidth / (16 / 9);

    // Measure Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: widget.project.title,
        style: AppTypography.inter(
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: innerWidth);
    final titleHeight = math.max(
      titlePainter.height,
      (widget.project.title.length * 11.0 / innerWidth).ceil() * 26.0,
    );

    // Measure Description (clamped to 3 lines)
    double descHeight = 0.0;
    if (widget.project.description.trim().isNotEmpty) {
      final descPainter = TextPainter(
        text: TextSpan(
          text: widget.project.description,
          style: AppTypography.inter(
            fontSize: 14,
            height: 1.55,
          ),
        ),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 3,
      )..layout(maxWidth: innerWidth);
      descHeight = 8.0 + descPainter.height + 4.0 + textScaler.scale(22.0);
    }

    // Measure Tags Wrap
    double tagsHeight = 0.0;
    if (widget.project.tags.isNotEmpty) {
      double currentLineWidth = 0;
      double currentLineMaxHeight = 28.0;
      for (final tag in widget.project.tags) {
        final tagPainter = TextPainter(
          text: TextSpan(
            text: tag,
            style: AppTypography.mono(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout(maxWidth: math.max(40.0, innerWidth - 20.0));
        // Use max of measured width and monospace character width to protect against unrendered font metrics
        final measuredW = math.max(tagPainter.width, tag.length * 7.5);
        final tagW = math.min(innerWidth, measuredW + 24.0);
        final tagH = math.max(tagPainter.height + 10.0, 28.0);

        if (currentLineWidth > 0 &&
            currentLineWidth + 6.0 + tagW > innerWidth) {
          tagsHeight += currentLineMaxHeight + 6.0;
          currentLineWidth = tagW;
          currentLineMaxHeight = tagH;
        } else {
          currentLineWidth += (currentLineWidth > 0 ? 6.0 : 0.0) + tagW;
          currentLineMaxHeight = math.max(currentLineMaxHeight, tagH);
        }
      }
      tagsHeight += currentLineMaxHeight;
    }

    // Measure Links Wrap
    double linksHeight = 0.0;
    if (widget.project.links.isNotEmpty) {
      double currentLineWidth = 0;
      double currentLineMaxHeight = 20.0;
      for (final linkKey in widget.project.links.keys) {
        final linkPainter = TextPainter(
          text: TextSpan(
            text: linkKey,
            style: AppTypography.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout(maxWidth: math.max(40.0, innerWidth - 18.0));
        final linkW = math.min(innerWidth, linkPainter.width + 22.0);
        final linkH = math.max(linkPainter.height, 20.0);

        if (currentLineWidth > 0 &&
            currentLineWidth + 14.0 + linkW > innerWidth) {
          linksHeight += currentLineMaxHeight + 8.0;
          currentLineWidth = linkW;
          currentLineMaxHeight = linkH;
        } else {
          currentLineWidth += (currentLineWidth > 0 ? 14.0 : 0.0) + linkW;
          currentLineMaxHeight = math.max(currentLineMaxHeight, linkH);
        }
      }
      linksHeight += currentLineMaxHeight + 36.0;
    } else {
      linksHeight = 20.0;
    }

    final estimatedMinHeight = thumbnailHeight +
        20.0 +
        titleHeight +
        descHeight +
        (widget.project.tags.isNotEmpty ? 16.0 : 0.0) +
        tagsHeight +
        linksHeight +
        32.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: estimatedMinHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(
            0.0,
            isHovered ? -6.0 : 0.0,
            0.0,
          ),
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
              // Thumbnail / Device Mockup Frame - concrete height so IntrinsicHeight is accurate
              SizedBox(
                width: double.infinity,
                height: thumbnailHeight,
                child: Container(
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
                      Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: DeviceFrame(
                            type: widget.project.deviceType,
                            accent: widget.project.accentColor,
                            child: widget.project.thumbnail.trim().isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: PortfolioImage(
                                      imagePath: widget.project.thumbnail,
                                      fallbackAsset: '',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      fallbackWidget: const SizedBox.shrink(),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      // Category tag badge in top right (bounded so it never overflows)
                      if (widget.project.type.trim().isNotEmpty)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: math.max(60.0, widget.cardWidth - 24.0),
                            ),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              ),

              // Card Body Header & Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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

                    // Description clamped to 3 lines with ellipsis, plus "Read more"
                    Text(
                      widget.project.description,
                      style: AppTypography.inter(
                        fontSize: 14,
                        height: 1.55,
                        color: muted,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.project.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => _showFullDescription(context),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Read more',
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryInk,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Tag Chips (show all, no hardcoded heights, never hidden behind +N)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.project.tags.map((tag) {
                        return Container(
                          constraints: BoxConstraints(maxWidth: innerWidth),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor(context)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            tag,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.mono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: primaryInk,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Pin links to bottom with Spacer
              const Spacer(),

              // Links row pinned to bottom (or clean bottom padding if no links)
              if (widget.project.links.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: widget.project.links.entries.map((link) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: innerWidth),
                        child: InkWell(
                          onTap: () => widget.onLaunch(link.value),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  link.key,
                                  style: AppTypography.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: primaryInk,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
