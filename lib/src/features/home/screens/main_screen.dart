import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../forum/screens/forum_screen.dart';
import '../../leaderboard/screens/leaderboard_screen.dart';
import '../../blackcard/screens/blackcard_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/home_dashboard.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin { // Changed to single ticker
  int _selectedIndex = 0;
  late AnimationController _animationController;

  // Lazy load screens to improve initial performance
  late final List<Widget Function()> _screenBuilders;
  final Map<int, Widget> _cachedScreens = {};

  final List<String> _titles = [
    'Boardroom',
    'Forum',
    'Leaderboard',
    'Blackcard',
    'Profile',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.forum_outlined,
    Icons.leaderboard_outlined,
    Icons.star_outline,
    Icons.person_outline,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.forum,
    Icons.leaderboard,
    Icons.star,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    print("🖥️ MainScreen initState started");
    
    // Single animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Reduced duration
      vsync: this,
    );

    // Lazy screen builders
    _screenBuilders = [
      () => const HomeDashboard(),
      () => const ForumScreen(),
      () => const LeaderboardScreen(),
      () => const BlackcardScreen(),
      () => const ProfileScreen(),
    ];

    // Pre-cache the home screen
    _cachedScreens[0] = _screenBuilders[0]();
    _animationController.forward();
    
    print("✅ MainScreen initialized");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _getScreen(int index) {
    if (!_cachedScreens.containsKey(index)) {
      print("📱 Loading screen $index");
      _cachedScreens[index] = _screenBuilders[index]();
    }
    return _cachedScreens[index]!;
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Simple animation reset
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🏗️ Building MainScreen");
    
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _animationController,
            child: _getScreen(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Reduced opacity
            blurRadius: 10, // Reduced blur
            offset: const Offset(0, 5), // Reduced offset
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3), // Simplified background
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: List.generate(_icons.length, (index) {
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 150), // Reduced duration
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: index == _selectedIndex
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    index == _selectedIndex ? _selectedIcons[index] : _icons[index],
                    size: 24,
                  ),
                ),
                label: _titles[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}