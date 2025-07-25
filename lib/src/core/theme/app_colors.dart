import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);
  
  // Premium/Blackcard Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color goldLight = Color(0xFFFFE55C);
  static const Color goldDark = Color(0xFFB8860B);
  
  // Background Gradients
  static const Color backgroundStart = Color(0xFF0A0E27);
  static const Color backgroundEnd = Color(0xFF1A1F3A);
  static const Color background = Color(0xFF0F1419);
  
  // Surface Colors
  static const Color surface = Color(0xFF1A1F2E);
  static const Color surfaceLight = Color(0xFF252B3A);
  static const Color cardBackground = Color(0xFF1E2329);
  static const Color inputBackground = Color(0xFF252B36);
  
  // Glass Effect Colors
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color textTertiary = Color(0xFF8B92A5);
  static const Color textMuted = Color(0xFF6B7280);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Border Colors
  static const Color border = Color(0xFF374151);
  static const Color borderLight = Color(0xFF4B5563);
  
  // Interactive Colors
  static const Color hover = Color(0xFF374151);
  static const Color pressed = Color(0xFF4B5563);
  static const Color disabled = Color(0xFF6B7280);
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundStart, backgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, gold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}