import 'package:flutter/material.dart';

/// 메인 셸 플로팅 탭바 — Figma 284:280
abstract final class ShellTheme {
  // 글래스 표면
  static const Color tabBarTintTop = Color(0xCCFFFFFF);
  static const Color tabBarTintBottom = Color(0xA8EDE4FF);
  static const Color tabBarBorder = Color(0xF2FFFFFF);
  static const Color tabBarBorderBottom = Color(0x59FFFFFF);
  static const Color tabBarShadow = Color(0x338F6BFF);
  static const Color tabBarSpecular = Color(0x99FFFFFF);

  // 탭 아이템
  static const Color tabActive = Color(0xFF8F6BFF);
  static const Color tabInactive = Color(0xFF8A8A8A);

  static const double tabBarHeight = 68;
  static const double tabBarHorizontalMargin = 16;
  static const double tabBarBottomMargin = 10;
  static const double tabBarRadius = 40;
  static const double tabBarBlurSigma = 32;

  static const double tabIconActiveSize = 38;
  static const double tabIconInactiveSize = 28;

  /// 스크롤 콘텐츠 하단 여백 (플로팅 탭바 + FAB 여유)
  static double scrollBottomPadding(BuildContext context) {
    final safe = MediaQuery.paddingOf(context).bottom;
    return tabBarHeight + tabBarBottomMargin + safe + 20;
  }
}
