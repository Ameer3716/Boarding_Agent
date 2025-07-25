import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) print('📱 Notifications already initialized');
      return;
    }

    try {
      if (kDebugMode) print('🔔 Starting notification initialization...');

      // Request permission with timeout
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      ).timeout(
        const Duration(seconds: 3), // Reduced timeout
        onTimeout: () {
          if (kDebugMode) print('⚠️ Permission request timed out');
          const notificationSettings = NotificationSettings(
            authorizationStatus: AuthorizationStatus.notDetermined,
            alert: AppleNotificationSetting.notSupported,
            announcement: AppleNotificationSetting.notSupported,
            badge: AppleNotificationSetting.notSupported,
            carPlay: AppleNotificationSetting.notSupported,
            lockScreen: AppleNotificationSetting.notSupported,
            notificationCenter: AppleNotificationSetting.notSupported,
            showPreviews: AppleShowPreviewSetting.notSupported,
            timeSensitive: AppleNotificationSetting.notSupported,
            criticalAlert: AppleNotificationSetting.notSupported,
            sound: AppleNotificationSetting.notSupported,
            providesAppNotificationSettings: AppleNotificationSetting.notSupported, // Added required parameter
          );
          return notificationSettings;
        },
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) print('User granted permission');
        
        // Get token with timeout
        String? token = await _messaging.getToken().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            if (kDebugMode) print('⚠️ Token request timed out');
            return null;
          },
        );
        
        if (token != null && kDebugMode) {
          print('FCM Token: $token');
        }

        // Set up handlers (non-blocking)
        _setupMessageHandlers();
        
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (kDebugMode) print('User granted provisional permission');
      } else {
        if (kDebugMode) print('User declined or has not accepted permission');
      }

      _isInitialized = true;
      if (kDebugMode) print('✅ Notifications initialized');

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error initializing notifications: $e');
        print('Stack trace: $stackTrace');
      }
      
      // Mark as initialized to prevent hanging
      _isInitialized = true;
    }
  }

  static void _setupMessageHandlers() {
    try {
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
        }

        if (message.notification != null && kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
      });

      // Handle notification opened app
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('A new onMessageOpenedApp event was published!');
        }
      });

      if (kDebugMode) print('✅ Message handlers set up');
    } catch (e) {
      if (kDebugMode) print('❌ Error setting up handlers: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken().timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );
    } catch (e) {
      if (kDebugMode) print('❌ Error getting token: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic).timeout(
        const Duration(seconds: 3),
      );
      if (kDebugMode) print('✅ Subscribed to topic: $topic');
    } catch (e) {
      if (kDebugMode) print('❌ Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic).timeout(
        const Duration(seconds: 3),
      );
      if (kDebugMode) print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      if (kDebugMode) print('❌ Error unsubscribing from topic: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}