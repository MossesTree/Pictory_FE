import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';

class PicktoryDecorations {
  const PicktoryDecorations(this.palette);

  final PicktoryPalette palette;

  BoxDecoration card({double radius = PicktoryRadius.lg}) => BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: palette.border, width: 1),
      );

  BoxDecoration cardElevated({double radius = PicktoryRadius.lg}) =>
      BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: palette.border.withValues(alpha: 0.6)),
      );

  BoxDecoration searchField() => BoxDecoration(
        color: palette.searchFill,
        borderRadius: PicktoryRadius.mdAll,
        border: Border.all(color: palette.border),
      );

  BoxDecoration heroGradient() => BoxDecoration(
        borderRadius: PicktoryRadius.lgAll,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.surfaceElevated,
            palette.surface,
            const Color(0xFF1A1408),
          ],
        ),
        border: Border.all(color: palette.border),
      );

  BoxDecoration adBanner() => BoxDecoration(
        borderRadius: PicktoryRadius.mdAll,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.surfaceMuted,
            palette.surfaceElevated,
          ],
        ),
      );

  BoxDecoration thumbnail() => BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: PicktoryRadius.smAll,
        border: Border.all(color: palette.border),
      );
}
