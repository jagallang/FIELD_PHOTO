import 'package:flutter/material.dart';

/// Application color constants
/// 
/// This class contains all the color constants used throughout the application.
/// Colors are organized by usage type and provide consistent theming.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueVariant = Color(0xFF1976D2);
  static const Color primaryBlueDark = Color(0xFF0D47A1);

  // Secondary Colors  
  static const Color secondaryColor = Color(0xFF1976D2);
  
  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  
  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFE91E63);
  static const Color errorLight = Color(0xFFF06292);
  static const Color info = primaryBlue;
  static const Color infoLight = Color(0xFF64B5F6);
  
  // Gradient Colors
  static const List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF81C784)];
  static const List<Color> blueGradient = [Color(0xFF2196F3), Color(0xFF64B5F6)];
  static const List<Color> orangeGradient = [Color(0xFFFF9800), Color(0xFFFFB74D)];
  static const List<Color> pinkGradient = [Color(0xFFE91E63), Color(0xFFF06292)];
  
  // Cover Page Template Colors
  static const Color coverPrimary = primaryBlue;
  static const Color coverSecondary = primaryBlueVariant;
  static const Color coverAccent = Color(0xFF0D47A1);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textInverse = Colors.white;
  
  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // Background Colors
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color backgroundTertiary = Color(0xFFFAFAFA);
  
  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.1);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.2);
  static Color shadowDark = Colors.black.withValues(alpha: 0.3);
}