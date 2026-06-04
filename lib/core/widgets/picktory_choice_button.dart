import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryChoiceButton extends StatelessWidget {
  const PicktoryChoiceButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.palette = PicktoryColors.dark,
  });

  final String label;
  final VoidCallback onPressed;
  final PicktoryPalette palette;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: PicktoryRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: PicktoryRadius.mdAll,
            border: Border.all(color: palette.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: typography.caption.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
