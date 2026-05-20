import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';

class MissionYellowButton extends StatelessWidget {
  const MissionYellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: HomeTheme.yellow,
          foregroundColor: Colors.black,
          disabledBackgroundColor: HomeTheme.surfaceLight,
          disabledForegroundColor: HomeTheme.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
