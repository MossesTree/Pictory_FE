import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryIconLabel extends StatelessWidget {
  const PicktoryIconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.palette = PicktoryColors.dark,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final PicktoryPalette palette;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor ?? palette.textTertiary),
        const SizedBox(width: 4),
        Text(label, style: typography.caption),
      ],
    );
  }
}
