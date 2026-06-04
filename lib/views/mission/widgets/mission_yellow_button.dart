import 'package:flutter/material.dart';
import 'package:picktory/views/mission/mission_theme.dart';

/// 미션 화면 primary CTA — 보라 풀 너비 버튼
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
          backgroundColor: MissionTheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: MissionTheme.border,
          disabledForegroundColor: MissionTheme.textTertiary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
    );
  }
}
