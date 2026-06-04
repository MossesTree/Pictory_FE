import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktorySectionHeader extends StatelessWidget {
  const PicktorySectionHeader({
    super.key,
    required this.title,
    this.palette = PicktoryColors.dark,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final PicktoryPalette palette;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        PicktorySpacing.md,
        PicktorySpacing.md,
        PicktorySpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: typography.sectionTitle)),
          if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: palette.accent,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: typography.caption.copyWith(color: palette.accent),
              ),
            ),
        ],
      ),
    );
  }
}
