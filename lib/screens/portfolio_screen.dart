import 'package:flutter/material.dart';
import 'package:portfolio_new/constants/color_constants.dart';
import 'package:portfolio_new/screens/widgets/about_me_screen.dart';
import 'package:portfolio_new/screens/widgets/contact_me_screen.dart';
import 'package:portfolio_new/screens/widgets/experience_screen.dart';
import 'package:portfolio_new/screens/widgets/footer_widget.dart';
import 'package:portfolio_new/screens/widgets/home_screen.dart';
import 'package:portfolio_new/screens/widgets/nav_bar.dart';
import 'package:portfolio_new/screens/widgets/project_screen.dart';
import 'package:portfolio_new/screens/widgets/skills_screen.dart';
import 'package:portfolio_new/screens/widgets/testimonials_screen.dart';
import 'package:portfolio_new/services/portfolio_scope.dart';
import 'package:portfolio_new/services/portfolio_state.dart';
import 'package:portfolio_new/widgets/app_toast.dart';

class PortfolioScrollablePage extends StatefulWidget {
  const PortfolioScrollablePage({super.key});

  @override
  State<PortfolioScrollablePage> createState() =>
      _PortfolioScrollablePageState();
}

class _PortfolioScrollablePageState extends State<PortfolioScrollablePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isDrawerOpen = false;
  bool _showBackToTop = false;
  String _activeSection = 'home';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldShow = offset > 500;
    if (shouldShow != _showBackToTop) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }

    _updateActiveSection();
  }

  void _updateActiveSection() {
    final keys = [
      ('home', _homeKey),
      ('about', _aboutKey),
      ('skills', _skillsKey),
      ('projects', _projectsKey),
      ('experience', _experienceKey),
      ('contact', _contactKey),
    ];

    for (var i = keys.length - 1; i >= 0; i--) {
      final key = keys[i].$2;
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= 200) {
            if (_activeSection != keys[i].$1) {
              setState(() {
                _activeSection = keys[i].$1;
              });
            }
            break;
          }
        }
      }
    }
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _handleRefresh() async {
    final notifier = PortfolioScope.of(context);
    final success = await notifier.refresh();
    if (!mounted) return;
    if (!success) {
      final error =
          notifier.state.errorMessage ?? 'Unable to refresh portfolio.';
      AppToast.error(context, error);
    } else {
      AppToast.success(context, 'Portfolio content updated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = PortfolioScope.stateOf(context);
    final isRefreshing = state.status == PortfolioStatus.refreshing;

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: Stack(
        children: [
          // Main Scrollable Page with pull-to-refresh
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.accent,
            backgroundColor: AppColors.card(context),
            edgeOffset: 68,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Spacer for sticky navbar
                  const SizedBox(height: 68),

                  // Hero Section
                  Container(
                    key: _homeKey,
                    child: HomeScreen(
                      onViewProjectsTap: () => _scrollToKey(_projectsKey),
                    ),
                  ),

                  // About Me Section
                  Container(key: _aboutKey, child: const AboutMe()),

                  // Skills Section
                  Container(key: _skillsKey, child: const SkillsScreen()),

                  // Projects Section
                  Container(key: _projectsKey, child: const ProjectsScreen()),

                  // Experience Section
                  Container(
                    key: _experienceKey,
                    child: const ExperienceScreen(),
                  ),

                  // Testimonials Section
                  const TestimonialsScreen(),

                  // Contact Me Section
                  Container(key: _contactKey, child: const ContactMe()),

                  // Footer
                  FooterWidget(
                    onHomeTap: () => _scrollToKey(_homeKey),
                    onAboutTap: () => _scrollToKey(_aboutKey),
                    onSkillsTap: () => _scrollToKey(_skillsKey),
                    onProjectsTap: () => _scrollToKey(_projectsKey),
                    onExperienceTap: () => _scrollToKey(_experienceKey),
                    onContactTap: () => _scrollToKey(_contactKey),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Top NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              activeSection: _activeSection,
              isRefreshing: isRefreshing,
              onRefreshTap: _handleRefresh,
              onHomeTap: () => _scrollToKey(_homeKey),
              onAboutTap: () => _scrollToKey(_aboutKey),
              onSkillsTap: () => _scrollToKey(_skillsKey),
              onProjectsTap: () => _scrollToKey(_projectsKey),
              onExperienceTap: () => _scrollToKey(_experienceKey),
              onContactTap: () => _scrollToKey(_contactKey),
              onMenuTap: () => setState(() => _isDrawerOpen = true),
            ),
          ),

          // Mobile Drawer overlay
          MobileDrawer(
            isOpen: _isDrawerOpen,
            onClose: () => setState(() => _isDrawerOpen = false),
            onHomeTap: () => _scrollToKey(_homeKey),
            onAboutTap: () => _scrollToKey(_aboutKey),
            onSkillsTap: () => _scrollToKey(_skillsKey),
            onProjectsTap: () => _scrollToKey(_projectsKey),
            onExperienceTap: () => _scrollToKey(_experienceKey),
            onContactTap: () => _scrollToKey(_contactKey),
          ),

          // Floating Back To Top Button
          Positioned(
            bottom: 24,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _showBackToTop ? 1.0 : 0.0,
              child: _showBackToTop
                  ? FloatingActionButton.small(
                      heroTag: 'back_to_top_btn',
                      onPressed: _scrollToTop,
                      backgroundColor: AppColors.primaryColor(context),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      child: const Icon(Icons.arrow_upward_rounded, size: 20),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
