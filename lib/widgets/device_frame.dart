import 'package:flutter/material.dart';
import 'package:portfolio_new/models/portfolio_model.dart';

/// Renders a stylized hardware or window mockup frame around a project screen,
/// styled consistently with the original phone mockup aesthetic.
///
/// Supported variants:
/// - [DeviceType.phone]: The original stylized phone mockup (76x126).
/// - [DeviceType.desktop]: Monitor frame with stand in the same stylized look.
/// - [DeviceType.web]: Browser window with window dots & URL bar in the same stylized look.
class DeviceFrame extends StatelessWidget {
  final DeviceType type;
  final Widget? child;
  final Color accent;

  const DeviceFrame({
    super.key,
    required this.type,
    this.child,
    required this.accent,
  });

  static const double boxWidth = 160.0;
  static const double boxHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (type) {
      case DeviceType.phone:
        content = _buildPhone();
        break;
      case DeviceType.desktop:
        content = _buildDesktop();
        break;
      case DeviceType.web:
        content = _buildWeb();
        break;
    }

    return SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: Center(child: content),
    );
  }

  Widget _buildPhone() {
    return Container(
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
              color: accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 6,
            width: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Monitor screen
        Container(
          width: 140,
          height: 96,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xF2FFFFFF),
            borderRadius: BorderRadius.circular(12),
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
              Row(
                children: [
                  Container(
                    height: 7,
                    width: 48,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 6,
                    width: 28,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
        // Stand neck
        Container(
          width: 14,
          height: 9,
          color: const Color(0xFF0F172A),
        ),
        // Stand base
        Container(
          width: 52,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildWeb() {
    return Container(
      width: 142,
      height: 114,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xF2FFFFFF),
        borderRadius: BorderRadius.circular(12),
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
          // Browser bar
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
