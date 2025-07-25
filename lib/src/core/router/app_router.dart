import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/forum/screens/forum_screen.dart';
import '../../features/forum/screens/thread_detail_screen.dart';
import '../../features/blackcard/screens/blackcard_screen.dart';
import '../../features/blackcard/screens/subscription_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/leaderboard/screens/leaderboard_screen.dart';
import '../../features/admin/screens/admin_panel_screen.dart';
import '../../../app.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  print("🧭 Creating router");
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false, // Disable debug logs for performance
    redirect: (context, state) {
      print("🔄 Router redirect check: ${state.matchedLocation}");
      
      final isLoggedIn = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == RouteNames.login ||
                         state.matchedLocation == RouteNames.signup;
      
      // If not logged in and trying to access protected routes
      if (!isLoggedIn && !isLoggingIn && state.matchedLocation != RouteNames.splash) {
        print("🔒 Redirecting to login");
        return RouteNames.login;
      }
      
      // If logged in and trying to access auth routes
      if (isLoggedIn && isLoggingIn) {
        print("🏠 Redirecting to home");
        return RouteNames.home;
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) {
          print("📱 Building splash screen");
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) {
          print("🏠 Building main screen");
          return const MainScreen();
        },
      ),
      GoRoute(
        path: RouteNames.forum,
        name: 'forum',
        builder: (context, state) => const ForumScreen(),
      ),
      GoRoute(
        path: '${RouteNames.threadDetail}/:threadId',
        name: 'thread-detail',
        builder: (context, state) {
          final threadId = state.pathParameters['threadId']!;
          return ThreadDetailScreen(threadId: threadId);
        },
      ),
      GoRoute(
        path: RouteNames.blackcard,
        name: 'blackcard',
        builder: (context, state) => const BlackcardScreen(),
      ),
      GoRoute(
        path: RouteNames.subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.leaderboard,
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: RouteNames.admin,
        name: 'admin',
        builder: (context, state) => const AdminPanelScreen(),
      ),
    ],
  );
});

// Splash Screen Widget
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("🎬 Building splash screen widget");
    
    // Auto-navigate after a short delay to prevent hanging
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        print("⏰ Auto-navigating from splash");
        context.go(RouteNames.login);
      }
    });
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.business_center,
                size: 80,
                color: Color(0xFF6366F1),
              ),
              const SizedBox(height: 24),
              const Text(
                'Agents Boardroom',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Premium Estate Agent Community',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB0B7C3),
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Color(0xFF6366F1),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}