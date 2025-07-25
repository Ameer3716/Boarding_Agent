class AppConstants {
  // App Info
  static const String appName = 'Agents Boardroom';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String likesCollection = 'likes';
  static const String pointsCollection = 'points';
  static const String subscriptionsCollection = 'subscriptions';
  static const String eventsCollection = 'events';
  static const String notificationsCollection = 'notifications';
  
  // User Roles
  static const String roleRegular = 'regular';
  static const String roleBlackcard = 'blackcard';
  static const String roleAdmin = 'admin';
  
  // Points System
  static const int pointsPerComment = 1;
  static const int pointsPerLike = 1;
  static const int pointsPerLiveSession = 10;
  
  // Subscription
  static const String blackcardProductId = 'blackcard_monthly';
  static const int blackcardPriceGBP = 50000; // £500.00 in pence
  
  // Stripe Keys (Replace with your actual keys)
  static const String stripePublishableKey = 'pk_test_your_publishable_key_here';
  static const String stripeSecretKey = 'sk_test_your_secret_key_here';
  
  // Forum Categories
  static const List<String> forumCategories = [
    'Lead Generation',
    'Brand Building',
    'Increasing Fees',
    'Conversions',
    'My First...',
    'Live Sessions',
  ];
  
  // Pagination
  static const int postsPerPage = 20;
  static const int commentsPerPage = 10;
  static const int leaderboardLimit = 50;
  
  // Image Limits
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 70;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Debounce Duration
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  // Cache Duration
  static const Duration cacheExpiry = Duration(hours: 1);
  
  // Deep Links
  static const String deepLinkScheme = 'agentsboardroom';
  static const String deepLinkHost = 'app';
  
  // External URLs
  static const String privacyPolicyUrl = 'https://agentsboardroom.com/privacy';
  static const String termsOfServiceUrl = 'https://agentsboardroom.com/terms';
  static const String supportUrl = 'https://agentsboardroom.com/support';
}