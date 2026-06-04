import 'package:flutter/material.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

/// IA M-1 선택 확인 모달 (Figma 미션 상세 팝업)
class MissionConfirmSheet extends StatelessWidget {
  const MissionConfirmSheet({
    super.key,
    required this.selectedLabel,
    required this.pointCost,
    required this.onShare,
    required this.onHome,
    this.isSubmitting = false,
  });

  final String selectedLabel;
  final int pointCost;
  final VoidCallback onShare;
  final VoidCallback onHome;
  final bool isSubmitting;

  static Future<void> show(
    BuildContext context, {
    required String selectedLabel,
    required int pointCost,
    required VoidCallback onShare,
    required VoidCallback onHome,
    bool isSubmitting = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return MissionConfirmSheet(
          selectedLabel: selectedLabel,
          pointCost: pointCost,
          isSubmitting: isSubmitting,
          onShare: () {
            Navigator.of(dialogContext).pop();
            onShare();
          },
          onHome: () {
            Navigator.of(dialogContext).pop();
            onHome();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: MissionTheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: MissionTheme.badgeFill,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: MissionTheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "'$selectedLabel'를 선택했어요!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MissionTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$pointCost Pick이 사용되었어요',
              style: const TextStyle(
                color: MissionTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: MissionTheme.primary,
                  side: const BorderSide(color: MissionTheme.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            MissionYellowButton(
              label: '스레드에 공유하기',
              enabled: !isSubmitting,
              onPressed: isSubmitting ? null : onShare,
            ),
          ],
        ),
      ),
    );
  }
}
