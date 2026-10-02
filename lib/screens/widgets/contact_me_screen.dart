import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/constants/contact_constants.dart';
import 'package:portfolio_new/constants/text_constants.dart';
import 'package:portfolio_new/services/contact_service.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMe extends StatefulWidget {
  final ContactService? contactService;

  const ContactMe({super.key, this.contactService});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late final ContactService _contactService;
  String? _statusMessage;
  bool _submitted = false;
  bool _isSending = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _contactService = widget.contactService ?? ContactService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleSubmit() async {
    if (_isSending) return;

    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSending = true;
        _statusMessage = null;
      });

      final result = await _contactService.sendMessage(
        name: _nameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      if (!mounted) return;

      setState(() {
        _isSending = false;
        _isSuccess = result.isSuccess;
        _statusMessage = result.message;

        if (result.isSuccess) {
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
          _submitted = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 640 && size.width < 1024;

    return Container(
      width: double.infinity,
      color: AppColors.bg(context),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : (isTablet ? 40 : (size.width < 360 ? 14 : 20)),
        vertical: isDesktop ? 90 : (isTablet ? 70 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ContactInfo(onLaunch: _launch)),
                    const SizedBox(width: 60),
                    Expanded(child: _buildFormCard(context)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ContactInfo(onLaunch: _launch),
                    const SizedBox(height: 40),
                    _buildFormCard(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final text = AppColors.text(context);
    final line = AppColors.line(context);
    final isMobile = MediaQuery.of(context).size.width < 640;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: line, width: 1.2),
        boxShadow: AppColors.cardShadow(context),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            Text(
              'Name',
              style: AppTypography.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: text,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: AppTypography.inter(fontSize: 15, color: text),
              decoration: _inputDecoration(context, 'Your name'),
              validator: (val) {
                if (val == null || val.trim().length < 2) {
                  return 'Enter your name (at least 2 characters).';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email Field
            Text(
              'Email',
              style: AppTypography.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: text,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: AppTypography.inter(fontSize: 15, color: text),
              decoration: _inputDecoration(context, 'name@example.com'),
              validator: (val) {
                if (val == null ||
                    !RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(val.trim())) {
                  return 'Enter a valid email address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Message Field
            Text(
              'Message',
              style: AppTypography.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: text,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              style: AppTypography.inter(fontSize: 15, color: text),
              decoration: _inputDecoration(
                context,
                'Tell me about your project...',
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a message.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            _SendButton(
              onTap: _isSending ? null : _handleSubmit,
              isLoading: _isSending,
            ),

            // Feedback banner
            if (_statusMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? const Color(0xFF15803D).withValues(alpha: 0.12)
                      : const Color(0xFFDC2626).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isSuccess
                        ? const Color(0xFF15803D).withValues(alpha: 0.3)
                        : const Color(0xFFDC2626).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded,
                      color: _isSuccess
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFEF4444),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: AppTypography.inter(
                          color: _isSuccess
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final line = AppColors.line(context);
    final card = AppColors.card(context);
    final primary = AppColors.primaryColor(context);

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.inter(
        color: AppColors.muted(context).withValues(alpha: 0.6),
        fontSize: 14.5,
      ),
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: line, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: line, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.8),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final Function(String) onLaunch;

  const _ContactInfo({required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    final isMobile = MediaQuery.of(context).size.width < 640;
    final portfolio = PortfolioScope.dataOf(context);
    final profile = portfolio.profile;

    final email = profile.email ?? ContactConstants.email;
    final phone = profile.phone ?? ContactConstants.phone;
    final location = profile.location ?? ContactConstants.location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.contactMeTitle,
          style: AppTypography.inter(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.w700,
            color: text,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 12),
        Text(
          StringConstants.contactMeSubtitle,
          style: AppTypography.inter(fontSize: 16, height: 1.6, color: muted),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 32),

        // Direct Contact Info list (Empty string or null means absent: hide row)
        if (email.trim().isNotEmpty) ...[
          _ContactRow(
            icon: Icons.mail_outline_rounded,
            label: email.trim(),
            onTap: () => onLaunch('mailto:${email.trim()}'),
          ),
          const SizedBox(height: 16),
        ],
        if (phone.trim().isNotEmpty) ...[
          _ContactRow(
            icon: Icons.phone_outlined,
            label: phone.trim(),
            onTap: () => onLaunch('tel:${phone.trim()}'),
          ),
          const SizedBox(height: 16),
        ],
        if (location.trim().isNotEmpty) ...[
          _ContactRow(icon: Icons.location_on_outlined, label: location.trim()),
        ],
      ],
    );
  }
}

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ContactRow({required this.icon, required this.label, this.onTap});

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.text(context);
    final primaryInk = AppColors.primaryInk(context);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryColor(context).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, size: 19, color: primaryInk),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: (isHovered && widget.onTap != null) ? primaryInk : text,
                  decoration: (isHovered && widget.onTap != null)
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const _SendButton({required this.onTap, this.isLoading = false});

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onTap != null && !widget.isLoading;

    return MouseRegion(
      cursor: isEnabled
          ? SystemMouseCursors.click
          : (widget.isLoading
              ? SystemMouseCursors.wait
              : SystemMouseCursors.basic),
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()
            ..translateByDouble(
              0.0,
              (isHovered && isEnabled) ? -2.0 : 0.0,
              0.0,
              1.0,
            ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEnabled
                  ? const [Color(0xFF2563EB), Color(0xFF1E40AF)]
                  : [
                      const Color(0xFF2563EB).withValues(alpha: 0.7),
                      const Color(0xFF1E40AF).withValues(alpha: 0.7),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF2563EB,
                ).withValues(alpha: (isHovered && isEnabled) ? 0.45 : 0.25),
                blurRadius: (isHovered && isEnabled) ? 20 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sending message...',
                        style: AppTypography.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Send message',
                    style: AppTypography.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
