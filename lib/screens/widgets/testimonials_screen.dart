import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    final portfolio = PortfolioScope.dataOf(context);
    final testimonials = portfolio.testimonials.isNotEmpty
        ? portfolio.testimonials
        : StringConstants.testimonials
              .map(
                (t) => Testimonial(quote: t.quote, name: t.name, role: t.role),
              )
              .toList();

    final horizontalPadding = isDesktop
        ? 60.0
        : (isTablet ? 40.0 : (size.width < 360 ? 14.0 : 20.0));

    return Container(
      width: double.infinity,
      color: AppColors.surface(context),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isDesktop ? 90 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'Kind words',
                style: AppTypography.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Feedback from technical mentors and project collaborators.',
                style: AppTypography.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 36),

              // Testimonial Cards
              if (crossAxisCount == 1)
                Column(
                  children: [
                    for (var i = 0; i < testimonials.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _TestimonialCard(
                        testimonial: testimonials[i],
                        isMobile: true,
                      ),
                    ],
                  ],
                )
              else
                Builder(
                  builder: (context) {
                    final spacing = 20.0;
                    final rows = <List<int>>[];
                    for (
                      var i = 0;
                      i < testimonials.length;
                      i += crossAxisCount
                    ) {
                      final end = math.min(
                        i + crossAxisCount,
                        testimonials.length,
                      );
                      rows.add([for (var k = i; k < end; k++) k]);
                    }

                    return Column(
                      children: [
                        for (var r = 0; r < rows.length; r++) ...[
                          if (r > 0) SizedBox(height: spacing),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (
                                  var idx = 0;
                                  idx < rows[r].length;
                                  idx++
                                ) ...[
                                  if (idx > 0) SizedBox(width: spacing),
                                  Expanded(
                                    child: _TestimonialCard(
                                      testimonial: testimonials[rows[r][idx]],
                                      isMobile: false,
                                    ),
                                  ),
                                ],
                                for (
                                  var s = 0;
                                  s < crossAxisCount - rows[r].length;
                                  s++
                                ) ...[
                                  SizedBox(width: spacing),
                                  const Expanded(child: SizedBox()),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
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

class _TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;
  final bool isMobile;

  const _TestimonialCard({
    required this.testimonial,
    this.isMobile = false,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final line = AppColors.line(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, isHovered ? -4.0 : 0.0, 0.0, 1.0),
        padding: EdgeInsets.all(widget.isMobile ? 18 : 24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '“${widget.testimonial.quote}”',
              style: AppTypography.inter(
                fontSize: widget.isMobile ? 14 : 15,
                height: 1.65,
                fontStyle: FontStyle.italic,
                color: text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.testimonial.name,
                    style: AppTypography.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.testimonial.role,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: muted,
                    ),
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
