import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryCoinDisplay extends StatelessWidget {
  const PicktoryCoinDisplay({
    super.key,
    required this.amount,
    this.palette = PicktoryColors.dark,
    this.compact = false,
  });

  final int amount;
  final PicktoryPalette palette;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: PicktoryRadius.pillAll,
        border: Border.all(color: palette.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            size: compact ? 16 : 18,
            color: palette.accent,
          ),
          const SizedBox(width: 4),
          Text(
            _format(amount),
            style: typography.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: compact ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }

  static String _format(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
