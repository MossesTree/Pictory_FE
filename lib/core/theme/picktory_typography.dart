import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';

class PicktoryTypography {
  const PicktoryTypography(this.palette);

  final PicktoryPalette palette;

  TextStyle get screenTitle => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
        height: 1.2,
      );

  TextStyle get sectionTitle => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        height: 1.25,
      );

  TextStyle get cardTitle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        height: 1.3,
      );

  TextStyle get body => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.textPrimary,
        height: 1.4,
      );

  TextStyle get bodySecondary => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: palette.textSecondary,
        height: 1.4,
      );

  TextStyle get caption => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: palette.textSecondary,
        height: 1.3,
      );

  TextStyle get label => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: palette.textTertiary,
        height: 1.2,
      );

  TextStyle get accent => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: palette.accent,
      );

  TextStyle get heroTitle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
        height: 1.25,
      );
}
