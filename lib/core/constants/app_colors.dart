import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8B4513); // Coffee Brown
  static const Color primaryLight = Color(0xFFA0522D);
  static const Color primaryDark = Color(0xFF654321);

  // Secondary Colors
  static const Color secondary = Color(0xFFDEB887); // Burlywood
  static const Color secondaryLight = Color(0xFFF5DEB3);
  static const Color secondaryDark = Color(0xFFCD853F);

  // Accent Colors
  static const Color accent = Color(0xFFD2691E); // Orange
  static const Color accentLight = Color(0xFFFF8C00);

  // Background Colors
  static const Color background = Color(0xFFFFFFF8); // Ivory
  static const Color backgroundDark = Color(0xFF1C1C1C);
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Colors.white;
  static const Color textHint = Color(0xFF999999);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Other Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFCCCCCC);
  static const Color shadow = Color(0x1A000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
}
