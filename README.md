# Agents Boardroom

A premium community platform for estate agents built with Flutter.

## Features

### 🔐 Authentication & Onboarding
- Email/password login with Google Sign-In
- Multi-step onboarding flow
- Role-based access (Regular, Blackcard, Admin)

### 🏠 Home Dashboard  
- Modern dark theme with glassmorphic design
- "Ask the Boardroom" section with animated input
- Activity feed and top contributors
- Animated points counter

### 💬 Discussion Forum
- Category filtering system
- Nested comment threads
- Like animations and engagement metrics
- @ mention functionality

### 🏆 Gamification System
- Points for comments, likes, and live sessions
- Animated leaderboard with podium
- Weekly/Monthly/All-time views

### ⭐ Blackcard Premium Section
- Stripe subscription integration (£500+VAT)
- Exclusive content and events
- Premium dashboard with gold theme
- Event calendar and recordings

### 👤 User Profiles
- Profile customization with stats
- Contribution history
- Blackcard badges and achievements

### ⚙️ Admin Panel
- User management tools
- Point adjustment system
- Content moderation
- Analytics dashboard

## Tech Stack

- **Framework**: Flutter 3.0+ with Dart
- **State Management**: Riverpod 2.0
- **Backend**: Firebase (Auth, Firestore, Cloud Functions)
- **Payments**: Stripe integration
- **Design**: Material 3 with custom dark theme
- **Animations**: Flutter Animate, custom transitions
- **Storage**: Hive for local caching
- **Push Notifications**: Firebase Cloud Messaging

## Design System

### Colors
- **Primary**: Purple gradient (#6366F1 to #818CF8)
- **Premium**: Gold gradient for Blackcard features
- **Background**: Dark gradient (#0A0E27 to #1A1F3A)
- **Glass Effects**: Glassmorphic cards with blur effects

### Typography
- **Font**: Inter with multiple weights
- **Hierarchy**: Clear text scaling and contrast
- **Accessibility**: High contrast ratios maintained

### Animations
- **60fps** smooth transitions
- **Micro-interactions** on all interactive elements
- **Page transitions** with slide + fade effects
- **Loading states** with skeleton screens

## Getting Started

### Prerequisites
- Flutter 3.0+
- Dart SDK 3.0+
- Firebase project setup
- Stripe account for payments

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd agents_boardroom
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add your `google-services.json` (Android)
- Add your `GoogleService-Info.plist` (iOS)
- Update `firebase_options.dart` with your config

4. Configure Stripe
- Update `AppConstants.stripePublishableKey` with your key
- Set up your backend webhook endpoints

5. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── core/
    │   ├── constants/         # App constants
    │   ├── router/           # Go Router configuration
    │   ├── services/         # Core services
    │   ├── theme/           # App theme and colors
    │   └── widgets/         # Reusable widgets
    └── features/
        ├── auth/            # Authentication
        ├── onboarding/      # User onboarding
        ├── home/           # Dashboard
        ├── forum/          # Discussion forum
        ├── leaderboard/    # Points and rankings
        ├── blackcard/      # Premium features
        ├── profile/        # User profiles
        └── admin/          # Admin panel
```

## Key Features Implementation

### Authentication Flow
- Firebase Auth with email/password and Google Sign-In
- Automatic user profile creation
- Role-based access control
- Secure token management

### Glassmorphic UI
- Custom glassmorphic containers with blur effects
- Gradient backgrounds and borders
- Smooth animations and transitions
- Dark theme optimization

### Points System
- Real-time point calculation
- Leaderboard updates
- Achievement tracking
- Visual feedback with animations

### Premium Subscription
- Stripe integration for recurring payments
- Content access control
- Premium feature unlocking
- Subscription status management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is proprietary software. All rights reserved.

## Support

For support and questions, contact the development team or create an issue in the repository.