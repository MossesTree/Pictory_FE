import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';

enum PicktoryBadgeVariant { ad, urgent, result, accent, muted }

class PicktoryBadge extends StatelessWidget {
  const PicktoryBadge({
    super.key,
    required this.label,
    this.variant = PicktoryBadgeVariant.muted,
    this.palette = PicktoryColors.dark,
  });

  final String label;
  final PicktoryBadgeVariant variant;
  final PicktoryPalette palette;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: PicktoryRadius.smAll,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foreground,
          height: 1.1,
        ),
      ),
    );
  }

  (Color, Color) _colors() {
    switch (variant) {
      case PicktoryBadgeVariant.ad:
        return (Colors.black.withValues(alpha: 0.55), Colors.white);
      case PicktoryBadgeVariant.urgent:
        return (PicktoryBrandColors.urgent, Colors.white);
      case PicktoryBadgeVariant.result:
        return (palette.accent.withValues(alpha: 0.2), palette.accent);
      case PicktoryBadgeVariant.accent:
        return (palette.accent, palette.onAccent);
      case PicktoryBadgeVariant.muted:
        return (palette.surfaceMuted, palette.textSecondary);
    }
  }
}
