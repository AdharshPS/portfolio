import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;
    final isMobile = size.width < 640;

    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Container(
      width: double.infinity,
      color: AppColors.surface(context),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : (isTablet ? 40 : 20),
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
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Feedback from technical mentors and project collaborators.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.muted(context),
                ),
              ),
              const SizedBox(height: 36),

              // Testimonial Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = 20.0;
                  final totalSpacing = (crossAxisCount - 1) * spacing;
                  final cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: StringConstants.testimonials.map((t) {
                      return SizedBox(
                        width: cardWidth,
                        child: _TestimonialCard(testimonial: t),
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

class _TestimonialCard extends StatefulWidget {
  final TestimonialItem testimonial;

  const _TestimonialCard({required this.testimonial});

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
        padding: const EdgeInsets.all(24),
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
          children: [
            Text(
              '“${widget.testimonial.quote}”',
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.65,
                fontStyle: FontStyle.italic,
                color: text,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.testimonial.name,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.testimonial.role,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
