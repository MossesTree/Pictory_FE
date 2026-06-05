import 'package:flutter/material.dart';
import 'package:picktory/views/mission/mission_theme.dart';

/// IA M-1 선택 확인 모달 — 화면 정중앙 (Figma 미션 상세 팝업)
class MissionConfirmSheet extends StatelessWidget {
  const MissionConfirmSheet({
    super.key,
    required this.selectedLabel,
    required this.pointCost,
    required this.balanceAfter,
    required this.participantCount,
    required this.onShare,
    required this.onHome,
    this.isSubmitting = false,
  });

  final String selectedLabel;
  final int pointCost;
  final int balanceAfter;
  final int participantCount;
  final VoidCallback onShare;
  final VoidCallback onHome;
  final bool isSubmitting;

  static Future<void> show(
    BuildContext context, {
    required String selectedLabel,
    required int pointCost,
    required int balanceAfter,
    required int participantCount,
    required VoidCallback onShare,
    required VoidCallback onHome,
    bool isSubmitting = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: MissionConfirmSheet(
              selectedLabel: selectedLabel,
              pointCost: pointCost,
              balanceAfter: balanceAfter,
              participantCount: participantCount,
              isSubmitting: isSubmitting,
              onShare: () {
                Navigator.of(dialogContext).pop();
                onShare();
              },
              onHome: () {
                Navigator.of(dialogContext).pop();
                onHome();
              },
            ),
          ),
        );
      },
    );
  }

  static String _formatCount(int n) {
    return n.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: MissionTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: MissionTheme.badgeFill,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: MissionTheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                  color: MissionTheme.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: selectedLabel,
                    style: const TextStyle(color: MissionTheme.primary),
                  ),
                  const TextSpan(text: '을\n선택했어요!'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '선택은 변경할 수 없습니다',
              style: TextStyle(
                color: MissionTheme.textTertiary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: MissionTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MissionTheme.primary, width: 1.2),
              ),
              child: Row(
                children: [
                  Text(
                    '${pointCost}P 사용 완료',
                    style: const TextStyle(
                      color: MissionTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '잔액 ${_formatCount(balanceAfter)}P',
                    style: const TextStyle(
                      color: MissionTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: MissionTheme.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 15,
                  color: MissionTheme.textSecondary.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 5),
                Text(
                  '참여 ${_formatCount(participantCount)}명',
                  style: const TextStyle(
                    color: MissionTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MissionTheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: MissionTheme.border,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onShare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MissionTheme.badgeFill,
                  foregroundColor: MissionTheme.primary,
                  disabledBackgroundColor: MissionTheme.surfaceLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '스레드에 공유하기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
