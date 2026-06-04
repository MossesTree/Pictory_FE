import 'package:flutter/material.dart';

/// 미션·결과·공유 화면 라이트 테마 토큰 (Figma 524:3397 / 525:4353 / 549:1338 기준)
abstract final class MissionTheme {
  static const Color background = Color(0xFFF6F4FB);
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF3F0FA);
  static const Color primary = Color(0xFF8F6BFF);
  static const Color primaryDark = Color(0xFF6B4DE6);
  static const Color border = Color(0xFFE5E0F2);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6E6E76);
  static const Color textTertiary = Color(0xFFB4B0C0);
  static const Color countdown = Color(0xFFE53935);
  static const Color correct = Color(0xFF6BC489);
  static const Color wrong = Color(0xFFE57373);
  static const Color progress = Color(0xFF8F6BFF);
  static const Color progressTrack = Color(0xFFEDE8F7);
  static const Color badgeFill = Color(0xFFEDE8F7);
  static const Color pointPill = Color(0xFF8F6BFF);

  /// IA M-1 / M-4 노란 강조는 보라 primary로 통합
  static const Color yellow = primary;
}
