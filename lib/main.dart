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
    // Set system UI overlay style (non-blocking)
    _setSystemUIStyle();
    
    // Initialize critical services in parallel with shorter timeout
    await _initializeCoreServices();
    
    runApp(
      const ProviderScope(
        child: AgentsBoardroomApp(),
      ),
    );
    
    print("✅ App started successfully");
    
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

void _setSystemUIStyle() {
  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    print("📱 System UI configured");
  } catch (e) {
    print("⚠️ System UI configuration failed: $e");
  }
}

Future<void> _initializeCoreServices() async {
  print("🔧 Starting core services initialization...");
  
  // Initialize services in parallel with reduced timeout
  final results = await Future.wait([
    _initializeFirebase(),
    _initializeHive(),
    _initializeStripe(),
  ], eagerError: false).timeout(
    const Duration(seconds: 5), // Reduced timeout
    onTimeout: () {
      print("⚠️ Core services timeout - continuing anyway");
      return [false, false, false];
    },
  );
  
  print("✅ Core services initialization completed");
  
  // Initialize notifications in background after app starts
  _initializeNotificationsInBackground();
}

Future<void> _initializeFirebase() async {
  try {
    print("🔥 Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 3));
    print("✅ Firebase initialized");
    return true;
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
    return false;
  }
}

Future<void> _initializeHive() async {
  try {
    print("📦 Initializing Hive...");
    await Hive.initFlutter().timeout(const Duration(seconds: 2));
    print("✅ Hive initialized");
    return true;
  } catch (e) {
    print("❌ Hive initialization failed: $e");
    return false;
  }
}

Future<bool> _initializeStripe() async {
  try {
    print("💳 Initializing Stripe...");
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    print("✅ Stripe initialized");
    return true;
  } catch (e) {
    print("❌ Stripe initialization failed: $e");
    return false;
  }
}

void _initializeNotificationsInBackground() {
  // Initialize notifications after the app is fully loaded
  Future.delayed(const Duration(milliseconds: 500), () async {
    try {
      print("🔔 Initializing Notifications...");
      await NotificationService.initialize();
      print("✅ Notifications initialized");
    } catch (e) {
      print("❌ Notification initialization failed: $e");
    }
  });
}