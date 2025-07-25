import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Form controllers
  final _agencyController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedExperience = 'beginner';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _agencyController.dispose();
    _locationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _completeOnboarding() async {
    final currentUser = ref.read(currentUserProvider);
    
    await currentUser.when(
      data: (user) async {
        if (user != null) {
          setState(() {
            _isLoading = true;
          });

          try {
            await ref.read(userRepositoryProvider).completeOnboarding(
              user.id,
              {
                'agency': _agencyController.text.trim(),
                'location': _locationController.text.trim(),
                'experienceLevel': _selectedExperience,
              },
            );

            if (mounted) {
              context.go(RouteNames.home);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error completing onboarding: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                    _animationController.reset();
                    _animationController.forward();
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildProfilePage(),
                    _buildCompletePage(),
                  ],
                ),
              ),
              
              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: CustomButton(
                          text: 'Back',
                          onPressed: _previousPage,
                          variant: ButtonVariant.outlined,
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: _currentPage == 2 ? 'Get Started' : 'Continue',
                        onPressed: _currentPage == 2 ? _completeOnboarding : _nextPage,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.waving_hand,
              size: 120,
              color: AppColors.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to the Boardroom!',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Join thousands of estate agents sharing insights, asking questions, and growing their business together.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Features List
            GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 2,
              linearGradient: AppColors.glassGradient,
              borderGradient: const LinearGradient(
                colors: [AppColors.glassBorder, AppColors.glassBorder],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      Icons.forum_outlined,
                      'Ask Questions',
                      'Get expert advice from experienced agents',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      Icons.leaderboard_outlined,
                      'Earn Points',
                      'Build your reputation by helping others',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      Icons.star_outline,
                      'Blackcard Access',
                      'Unlock premium content and events',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.person_outline,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Tell us about yourself',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Help us personalize your experience',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            Expanded(
              child: SingleChildScrollView(
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 20,
                  blur: 10,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: AppColors.glassGradient,
                  borderGradient: const LinearGradient(
                    colors: [AppColors.glassBorder, AppColors.glassBorder],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _agencyController,
                          label: 'Agency Name',
                          prefixIcon: Icons.business_outlined,
                          hint: 'e.g., Foxtons, Rightmove, etc.',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _locationController,
                          label: 'Location',
                          prefixIcon: Icons.location_on_outlined,
                          hint: 'e.g., London, Manchester, etc.',
                        ),
                        const SizedBox(height: 24),
                        
                        // Experience Level
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Experience Level',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Column(
                          children: [
                            _buildExperienceOption(
                              'beginner',
                              'New to Estate Agency',
                              '0-2 years experience',
                            ),
                            _buildExperienceOption(
                              'intermediate',
                              'Experienced Agent',
                              '2-5 years experience',
                            ),
                            _buildExperienceOption(
                              'expert',
                              'Senior Agent/Manager',
                              '5+ years experience',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletePage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 120,
              color: AppColors.success,
            ),
            const SizedBox(height: 32),
            Text(
              'You\'re all set!',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to the Agents Boardroom community. Start exploring, asking questions, and connecting with fellow estate agents.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 2,
              linearGradient: AppColors.glassGradient,
              borderGradient: const LinearGradient(
                colors: [AppColors.glassBorder, AppColors.glassBorder],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'What\'s Next?',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildNextStepItem(
                      Icons.forum_outlined,
                      'Browse discussions and ask your first question',
                    ),
                    const SizedBox(height: 12),
                    _buildNextStepItem(
                      Icons.people_outline,
                      'Connect with agents in your area',
                    ),
                    const SizedBox(height: 12),
                    _buildNextStepItem(
                      Icons.star_outline,
                      'Start earning points by helping others',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceOption(String value, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedExperience = value;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedExperience == value
                ? AppColors.primary
                : AppColors.border,
            width: _selectedExperience == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _selectedExperience == value
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedExperience,
              onChanged: (val) {
                setState(() {
                  _selectedExperience = val!;
                });
              },
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}