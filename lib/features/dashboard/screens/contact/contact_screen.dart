import 'package:flutter/widgets.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/dashboard/screens/contact/responsive/contact_desktop_screen.dart';
import 'package:portfolio/features/dashboard/screens/contact/responsive/contact_mobile_screen.dart';
import 'package:portfolio/features/dashboard/screens/contact/responsive/contact_tab_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, required this.contactKey});

  final GlobalKey contactKey;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: ContactMobileScreen(
        contactKey: widget.contactKey,
        nameController: _nameController,
        mobileController: _mobileController,
        emailController: _emailController,
        messageController: _messageController,
      ),
      tabletLayout: ContactTabScreen(
        contactKey: widget.contactKey,
        nameController: _nameController,
        mobileController: _mobileController,
        emailController: _emailController,
        messageController: _messageController,
      ),
      desktopLayout: ContactDesktopScreen(
        contactKey: widget.contactKey,
        nameController: _nameController,
        mobileController: _mobileController,
        emailController: _emailController,
        messageController: _messageController,
      ),
    );
  }
}
