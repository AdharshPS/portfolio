import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_styles.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';

class CustomTextfields extends StatefulWidget {
  const CustomTextfields({
    super.key,
    required this.controller,
    this.isMultiLine = false,
    required this.hint,
  });

  final TextEditingController controller;
  final bool isMultiLine;
  final String hint;

  @override
  State<CustomTextfields> createState() => _CustomTextfieldsState();
}

class _CustomTextfieldsState extends State<CustomTextfields> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.8;

        return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width,
            decoration: BoxDecoration(
              borderRadius: AppDimensions.containerButtonRadius,
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.isMultiLine
                  ? TextInputType.multiline
                  : TextInputType.text,
              maxLines: widget.isMultiLine ? 5 : 1,
              style: AppStyles.hintString(
                context,
              ).copyWith(color: AppColors.primaryTextColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.appBarSplash.withValues(alpha: 0.1),
                hintText: widget.hint,
                hintStyle: AppStyles.hintString(context).copyWith(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppDimensions.containerButtonRadius,
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppDimensions.containerButtonRadius,
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppDimensions.containerButtonRadius,
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
