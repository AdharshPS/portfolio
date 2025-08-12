import 'package:flutter/widgets.dart';
import 'package:portfolio/core/constants/app_decoration.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/constants/app_styles.dart';
import 'package:portfolio/shared/custom_textfields.dart';

class ContactTabScreen extends StatelessWidget {
  const ContactTabScreen({
    super.key,
    required this.contactKey,
    required this.nameController,
    required this.mobileController,
    required this.emailController,
    required this.messageController,
  });

  final GlobalKey contactKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: contactKey,
      width: AppDimensions.screenWidth(context),
      padding: AppDimensions.overAllDesktopPadding,
      child: Column(
        children: [
          Text('Contact Me', style: AppStyles.smallHeading(context)),
          Center(
            child: Container(
              width: AppDimensions.screenWidth(context) * 0.6,
              height: AppDimensions.screenHeight(context) * 0.7,
              decoration: AppDecoration.outlinedButtonDecoration,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextfields(
                              controller: nameController,
                              hint: 'Name',
                            ),
                            CustomTextfields(
                              controller: mobileController,
                              hint: 'Mobile',
                            ),
                            CustomTextfields(
                              controller: emailController,
                              hint: 'Email',
                            ),
                            CustomTextfields(
                              controller: messageController,
                              isMultiLine: true,
                              hint: 'Message',
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: constraints.maxHeight * 0.1,
                          width: constraints.maxWidth * 0.3,
                          decoration: AppDecoration.filledButtonDecoration,
                          alignment: Alignment.center,
                          child: Text('Send', style: AppStyles.buttonTextStyle),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
