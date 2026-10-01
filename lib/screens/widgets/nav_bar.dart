import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/constants/typography_constants.dart';
import 'package:portfolio_new/main.dart';

class NavBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;
  final VoidCallback onMenuTap;
  final String activeSection;
  final bool isRefreshing;
  final VoidCallback? onRefreshTap;

  const NavBar({
    super.key,
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
    required this.onMenuTap,
    this.activeSection = 'home',
    this.isRefreshing = false,
    this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1150;
    final isSmall = width < 380;
    final isDark = AppColors.isDark(context);

    final horizontalPadding = width < 360 ? 12.0 : (width < 600 ? 16.0 : 24.0);
    final iconBtnSize = isSmall ? 38.0 : 44.0;
    final iconSize = isSmall ? 18.0 : 20.0;
    final actionSpacing = isSmall ? 6.0 : 8.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkBg : AppColors.lightBg).withValues(
              alpha: 0.88,
            ),
            border: Border(
              bottom: BorderSide(color: AppColors.line(context), width: 1),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo: <adharsh/>
                  Flexible(
                    flex: isDesktop ? 0 : 1,
                    child: InkWell(
                      onTap: onHomeTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmall ? 4 : 8,
                          vertical: 6,
                        ),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: AppTypography.mono(
                              fontSize: isSmall ? 16 : 19,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context),
                              letterSpacing: -0.5,
                            ),
                            children: const [
                              TextSpan(text: '<adharsh'),
                              TextSpan(
                                text: '/',
                                style: TextStyle(color: AppColors.accent),
                              ),
                              TextSpan(text: '>'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Desktop Nav Links
                  if (isDesktop)
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _NavLink(
                              title: 'Home',
                              isActive: activeSection == 'home',
                              onTap: onHomeTap,
                            ),
                            _NavLink(
                              title: 'About',
                              isActive: activeSection == 'about',
                              onTap: onAboutTap,
                            ),
                            _NavLink(
                              title: 'Skills',
                              isActive: activeSection == 'skills',
                              onTap: onSkillsTap,
                            ),
                            _NavLink(
                              title: 'Projects',
                              isActive: activeSection == 'projects',
                              onTap: onProjectsTap,
                            ),
                            _NavLink(
                              title: 'Experience',
                              isActive: activeSection == 'experience',
                              onTap: onExperienceTap,
                            ),
                            _NavLink(
                              title: 'Contact',
                              isActive: activeSection == 'contact',
                              onTap: onContactTap,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Right Actions (Theme toggle, Hire me, Burger)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onRefreshTap != null) ...[
                        _IconButton(
                          tooltip: 'Refresh portfolio',
                          icon: isRefreshing
                              ? Icons.sync_rounded
                              : Icons.refresh_rounded,
                          size: iconBtnSize,
                          iconSize: iconSize,
                          onTap: isRefreshing ? () {} : onRefreshTap!,
                        ),
                        SizedBox(width: actionSpacing),
                      ],
                      // Theme Toggle Button
                      _IconButton(
                        tooltip: 'Toggle Theme',
                        icon: isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        size: iconBtnSize,
                        iconSize: iconSize,
                        onTap: toggleTheme,
                      ),
                      SizedBox(width: actionSpacing),

                      // Desktop Hire Me CTA
                      if (isDesktop)
                        _PrimaryButton(title: 'Hire me', onTap: onContactTap),

                      // Mobile Hamburger
                      if (!isDesktop) ...[
                        _IconButton(
                          tooltip: 'Open Menu',
                          icon: Icons.menu_rounded,
                          size: iconBtnSize,
                          iconSize: iconSize,
                          onTap: onMenuTap,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeOrHover = widget.isActive || isHovered;
    final primaryInk = AppColors.primaryInk(context);
    final muted = AppColors.muted(context);
    final surface = AppColors.surface(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: activeOrHover ? surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.title,
            style: AppTypography.inter(
              fontSize: 15,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: activeOrHover ? primaryInk : muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 44.0,
    this.iconSize = 20.0,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? AppColors.primaryColor(context)
                    : AppColors.line(context),
                width: 1.2,
              ),
              boxShadow: isHovered ? AppColors.cardShadow(context) : null,
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: AppColors.text(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _PrimaryButton({required this.title, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()
            ..translateByDouble(0.0, isHovered ? -2.0 : 0.0, 0.0, 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x240F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Text(
            widget.title,
            style: AppTypography.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class MobileDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;

  const MobileDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return IgnorePointer(
      ignoring: !isOpen,
      child: Stack(
        children: [
          // Scrim overlay
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isOpen ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: onClose,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

          // Drawer panel sliding in from right
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            top: 0,
            bottom: 0,
            right: isOpen ? 0 : -320,
            width: 280,
            child: Material(
              color: AppColors.card(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header with logo and close button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: AppTypography.mono(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text(context),
                                        ),
                                        children: const [
                                          TextSpan(text: '<adharsh'),
                                          TextSpan(
                                            text: '/',
                                            style: TextStyle(
                                              color: AppColors.accent,
                                            ),
                                          ),
                                          TextSpan(text: '>'),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      color: AppColors.text(context),
                                      onPressed: onClose,
                                    ),
                                  ],
                                ),
                                const Divider(height: 32),

                                // Nav links
                                _DrawerLink(
                                  title: 'Home',
                                  icon: Icons.home_outlined,
                                  onTap: () {
                                    onClose();
                                    onHomeTap();
                                  },
                                ),
                                _DrawerLink(
                                  title: 'About',
                                  icon: Icons.person_outline,
                                  onTap: () {
                                    onClose();
                                    onAboutTap();
                                  },
                                ),
                                _DrawerLink(
                                  title: 'Skills',
                                  icon: Icons.code_rounded,
                                  onTap: () {
                                    onClose();
                                    onSkillsTap();
                                  },
                                ),
                                _DrawerLink(
                                  title: 'Projects',
                                  icon: Icons.folder_open_rounded,
                                  onTap: () {
                                    onClose();
                                    onProjectsTap();
                                  },
                                ),
                                _DrawerLink(
                                  title: 'Experience',
                                  icon: Icons.work_outline,
                                  onTap: () {
                                    onClose();
                                    onExperienceTap();
                                  },
                                ),
                                _DrawerLink(
                                  title: 'Contact',
                                  icon: Icons.mail_outline,
                                  onTap: () {
                                    onClose();
                                    onContactTap();
                                  },
                                ),

                                const Spacer(),

                                // Theme switcher in drawer
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    isDark
                                        ? Icons.light_mode
                                        : Icons.dark_mode,
                                    color: AppColors.text(context),
                                  ),
                                  title: Text(
                                    isDark ? 'Light mode' : 'Dark mode',
                                    style: AppTypography.inter(
                                      color: AppColors.text(context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Switch(
                                    value: isDark,
                                    onChanged: (_) => toggleTheme(),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Hire me button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    onClose();
                                    onContactTap();
                                  },
                                  child: Text(
                                    'Hire me',
                                    style: AppTypography.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DrawerLink({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: AppColors.muted(context)),
      title: Text(
        title,
        style: AppTypography.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text(context),
        ),
      ),
      onTap: onTap,
    );
  }
}
