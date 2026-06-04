import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryChip extends StatelessWidget {
  const PicktoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.palette = PicktoryColors.dark,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final PicktoryPalette palette;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        borderRadius: PicktoryRadius.pillAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? palette.accent : palette.surface,
            borderRadius: PicktoryRadius.pillAll,
            border: Border.all(
              color: selected ? palette.accent : palette.border,
            ),
          ),
          child: Text(
            label,
            style: typography.caption.copyWith(
              color: selected ? palette.onAccent : palette.textPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
