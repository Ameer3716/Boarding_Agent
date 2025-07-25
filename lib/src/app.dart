import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class AgentsBoardroomApp extends ConsumerWidget {
  const AgentsBoardroomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("🏗️ Building AgentsBoardroomApp");
    
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Agents Boardroom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      // Disable animations for better performance
      themeAnimationDuration: const Duration(milliseconds: 150),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🔄 Showing loading screen");
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple icon without animations
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.business_center,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Agents Boardroom',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}