import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryBrandLogo extends StatelessWidget {
  const PicktoryBrandLogo({
    super.key,
    this.palette = PicktoryColors.dark,
    this.compact = false,
  });

  final PicktoryPalette palette;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    final iconSize = compact ? 28.0 : 32.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: PicktoryRadius.smAll,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.play_arrow_rounded,
            color: palette.onAccent,
            size: compact ? 18 : 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'PICKTORY',
          style: typography.sectionTitle.copyWith(
            fontSize: compact ? 16 : 18,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
