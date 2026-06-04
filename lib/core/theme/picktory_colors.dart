import 'package:flutter/material.dart';

/// 브랜드 공통 색 (라이트/다크 공유)
abstract final class PicktoryBrandColors {
  static const Color yellow = Color(0xFFFFD600);
  static const Color orange = Color(0xFFFF6B00);
  static const Color purple = Color(0xFF8F6BFF);
  static const Color purpleDark = Color(0xFF6B4DE6);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color urgent = Color(0xFFE53935);
}

/// 화면별 팔레트 베이스 — 색·타이포·데코가 이 객체를 참조
class PicktoryPalette {
  const PicktoryPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.onAccent,
    required this.searchFill,
    required this.overlay,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color onAccent;
  final Color searchFill;
  final Color overlay;

  Color get success => PicktoryBrandColors.success;
  Color get error => PicktoryBrandColors.error;
  Color get urgent => PicktoryBrandColors.urgent;
}

abstract final class PicktoryColors {
  static const PicktoryPalette dark = PicktoryPalette(
    background: Color(0xFF0D0D0D),
    surface: Color(0xFF1A1A1A),
    surfaceElevated: Color(0xFF242424),
    surfaceMuted: Color(0xFF2E2E2E),
    border: Color(0xFF3A3A3A),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0B0B0),
    textTertiary: Color(0xFF757575),
    accent: PicktoryBrandColors.yellow,
    onAccent: Color(0xFF111111),
    searchFill: Color(0xFF1E1E1E),
    overlay: Color(0x99000000),
  );

  static const PicktoryPalette light = PicktoryPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F5F5),
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEEEEEE),
    border: Color(0xFFE0E0E0),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF757575),
    textTertiary: Color(0xFF9E9E9E),
    accent: PicktoryBrandColors.yellow,
    onAccent: Color(0xFF111111),
    searchFill: Color(0xFFF0F0F0),
    overlay: Color(0x66000000),
  );

  /// 메인 홈 GUI (279:174)
  static const PicktoryPalette home = PicktoryPalette(
    background: Color(0xFFF7F7F8),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF0E8FF),
    surfaceMuted: Color(0xFFF3F3F5),
    border: Color(0xFFE8E8E8),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF757575),
    textTertiary: Color(0xFF9E9E9E),
    accent: PicktoryBrandColors.purple,
    onAccent: Color(0xFFFFFFFF),
    searchFill: Color(0xFFFFFFFF),
    overlay: Color(0x66000000),
  );
}
