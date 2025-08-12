import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_decoration.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/core/constants/app_styles.dart';
import 'package:portfolio/shared/custom_inkwell.dart';

class HomeMobileScreen extends StatelessWidget {
  const HomeMobileScreen({super.key, required this.homeKey});

  final GlobalKey homeKey;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: homeKey,
      width: AppDimensions.screenWidth(context),
      padding: AppDimensions.overAllDesktopPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: AppDimensions.overAllDesktopPadding,
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    child: Center(
                      child: CustomInkwell(
                        onPressed: () {},
                        splash: false,
                        child: Container(
                          // height: constraints.maxHeight * 0.3,
                          width: constraints.maxWidth * 0.9,
                          decoration: AppDecoration.halfTransparentContainer,
                          padding: AppDimensions.containerButtonPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.welcome,
                                style: AppStyles.largeHeading(context),
                              ),
                              Text(
                                AppStrings.myName,
                                style: AppStyles.mediumHeading(context),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.primaryIconColor,
                                  ),
                                  Expanded(
                                    child: Text(
                                      AppStrings.profession,
                                      style: AppStyles.smallHeading(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
