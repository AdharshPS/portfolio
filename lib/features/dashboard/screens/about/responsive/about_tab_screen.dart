import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/core/constants/app_styles.dart';

class AboutTabScreen extends StatelessWidget {
  const AboutTabScreen({super.key, required this.aboutKey});
  final GlobalKey aboutKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: aboutKey,
      width: AppDimensions.screenWidth(context),
      padding: AppDimensions.overAllDesktopPadding,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('About Me', style: AppStyles.mediumHeading(context)),
                  Text(
                    AppStrings.aboutMe,
                    style: AppStyles.messageString(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
