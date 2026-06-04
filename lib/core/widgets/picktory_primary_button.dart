import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktoryPrimaryButton extends StatelessWidget {
  const PicktoryPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.palette = PicktoryColors.dark,
    this.enabled = true,
    this.height = 52,
    this.expand = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PicktoryPalette palette;
  final bool enabled;
  final double height;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final typography = PicktoryTypography(palette);
    final button = SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.onAccent,
          disabledBackgroundColor: palette.surfaceMuted,
          disabledForegroundColor: palette.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: PicktoryRadius.mdAll),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: palette.onAccent,
                ),
              )
            : Text(
                label,
                style: typography.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.onAccent,
                ),
              ),
      ),
    );
    return button;
  }
}
