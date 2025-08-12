import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_styles.dart';

class CustomTextfields extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.8,
          child: TextFormField(
            controller: controller,
            keyboardType:
                isMultiLine ? TextInputType.multiline : TextInputType.text,
            maxLines: isMultiLine ? 5 : 1,
            style: AppStyles.hintString(context),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusColor: AppColors.primary,
              fillColor: AppColors.appbarSplash,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.buttonTextColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.appbarSplash),
              ),
              filled: true,
              hint: Text(hint, style: AppStyles.hintString(context)),
            ),
          ),
        );
      },
    );
  }
}
