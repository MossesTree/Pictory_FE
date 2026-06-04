import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';

/// 홈 GUI 상단·카드 토큰
abstract final class HomeTheme {
  static const PicktoryPalette palette = PicktoryColors.home;

  static const Color background = Color(0xFFF7F7F8);
  static const Color headerLavender = Color(0xFFEDE8F7);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF3F3F5);
  static const Color primaryPurple = Color(0xFF8F6BFF);
  static const Color primaryPurpleDark = Color(0xFF6B4DE6);
  static const Color heroPointPill = Color(0xFF6E5ADB);
  static const Color progressOrange = Color(0xFFE8A317);
  static const Color sectionTitle = Color(0xFF1E3A3A);
  static const Color chipSelectedBorder = Color(0xFFE84A7A);
  static const Color chipSelectedText = Color(0xFFE84A7A);
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color border = Color(0xFFE0E0E0);
  static const Color searchBorder = Color(0xFF2A2A2A);
  static const Color heroGradientStart = Color(0xFF9A7BFF);
  static const Color heroGradientEnd = Color(0xFF7055E8);
  static const Color navBarBackground = Color(0xFFF3EDFF);
  static const Color adLabelYellow = Color(0xFFFFD600);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [heroGradientEnd,heroGradientStart, heroGradientEnd],
    stops: [0.3, 0.5, 1.0],
  );

  static const double headerBottomRadius = 28;
  static const double heroCardRadius = 22;
}
