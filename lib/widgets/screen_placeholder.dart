import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/models/portfolio_model.dart';

/// Deliberate placeholder screen shown whenever project thumbnail
/// is empty, null, or fails to load.
class ScreenPlaceholder extends StatelessWidget {
  final String title;
  final DeviceType type;
  final Color accent;

  const ScreenPlaceholder({
    super.key,
    required this.title,
    required this.type,
    required this.accent,
  });

  String _getDisplayLetters(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'P';
    // Remove characters inside parentheses and punctuation
    final clean = trimmed
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
    final words =
        clean.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return trimmed.substring(0, 1).toUpperCase();
    if (words.length == 1) {
      return words.first
          .substring(0, math.min(2, words.first.length))
          .toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  IconData get _iconData {
    return switch (type) {
      DeviceType.phone => Icons.phone_android_rounded,
      DeviceType.desktop => Icons.desktop_windows_rounded,
      DeviceType.web => Icons.language_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(accent);
    final darkerAccent = hsl
        .withLightness((hsl.lightness * 0.3).clamp(0.08, 0.35))
        .withSaturation((hsl.saturation * 0.95).clamp(0.2, 1.0))
        .toColor();
    final letters = _getDisplayLetters(title);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final minDim = math.min(w, h);
        final iconSize = (minDim * 0.72).clamp(24.0, 84.0);
        final fontSize = (minDim * 0.34).clamp(12.0, 32.0);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: 0.28),
                darkerAccent,
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _GridTexturePainter(
                  dotColor: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Center(
                child: Icon(
                  _iconData,
                  size: iconSize,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      letters,
                      style: AppTypography.inter(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.95),
                        letterSpacing: 1.0,
                        shadows: const [
                          Shadow(
                            color: Color(0x80000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GridTexturePainter extends CustomPainter {
  final Color dotColor;

  const _GridTexturePainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const spacing = 12.0;
    const dotRadius = 0.8;

    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridTexturePainter oldDelegate) =>
      oldDelegate.dotColor != dotColor;
}
