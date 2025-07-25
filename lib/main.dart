import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/core/constants/app_constants.dart';
import 'src/core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print("🚀 App starting initialization...");
  
  try {
    // Set system UI overlay style first (non-blocking)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    // Lock orientation to portrait (non-blocking)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    print("📱 System UI configured");
    
    // Initialize critical services with timeout
    await Future.wait([
      _initializeFirebase(),
      _initializeHive(),
    ]).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print("⚠️ Initialization timeout - continuing with defaults");
        return [];
      },
    );
    
    print("✅ Core services initialized");
    
    // Initialize Stripe (this should be fast)
    _initializeStripe();
    
    print("💳 Stripe configured");
    
    runApp(
      const ProviderScope(
        child: AgentsBoardroomApp(),
      ),
    );
    
    // Initialize notifications after app starts (non-blocking)
    _initializeNotificationsAsync();
    
  } catch (e, stackTrace) {
    print("❌ Error during initialization: $e");
    print("Stack trace: $stackTrace");
    
    // Still run the app even if some services fail
    runApp(
      const ProviderScope(
        child: AgentsBoardroomApp(),
      ),
    );
  }
}

Future<void> _initializeFirebase() async {
  try {
    print("🔥 Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
    rethrow;
  }
}

Future<void> _initializeHive() async {
  try {
    print("📦 Initializing Hive...");
    await Hive.initFlutter();
    print("✅ Hive initialized");
  } catch (e) {
    print("❌ Hive initialization failed: $e");
    rethrow;
  }
}

void _initializeStripe() {
  try {
    print("💳 Initializing Stripe...");
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    print("✅ Stripe initialized");
  } catch (e) {
    print("❌ Stripe initialization failed: $e");
  }
}

void _initializeNotificationsAsync() {
  Future.delayed(const Duration(seconds: 1), () async {
    try {
      print("🔔 Initializing Notifications...");
      await NotificationService.initialize();
      print("✅ Notifications initialized");
    } catch (e) {
      print("❌ Notification initialization failed: $e");
    }
  });
}