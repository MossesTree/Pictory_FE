import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';

/// 앱 전역 Material 테마 (온보딩 라이트 + 메인 다크 참조)
abstract final class PicktoryTheme {
  static ThemeData dark() {
    const palette = PicktoryColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme.dark(
        primary: palette.accent,
        onPrimary: palette.onAccent,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        outline: palette.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
      ),
      dividerColor: palette.border,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: palette.accent),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceElevated,
        contentTextStyle: TextStyle(color: palette.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: PicktoryRadius.mdAll),
      ),
    );
  }
}
