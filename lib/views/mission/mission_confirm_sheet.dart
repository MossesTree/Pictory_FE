import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionConfirmSheet extends StatelessWidget {
  const MissionConfirmSheet({
    super.key,
    required this.selectedLabel,
    required this.notifyOnResult,
    required this.onNotifyChanged,
    required this.onShare,
    required this.onHome,
    this.isSubmitting = false,
  });

  final String selectedLabel;
  final bool notifyOnResult;
  final ValueChanged<bool> onNotifyChanged;
  final VoidCallback onShare;
  final VoidCallback onHome;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: HomeTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: HomeTheme.surfaceLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.check_circle, color: HomeTheme.yellow, size: 48),
          const SizedBox(height: 12),
          Text(
            "'$selectedLabel'를 선택했어요!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HomeTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '결과 알림 받기',
                  style: TextStyle(color: HomeTheme.textPrimary),
                ),
              ),
              Switch(
                value: notifyOnResult,
                onChanged: isSubmitting ? null : onNotifyChanged,
                activeTrackColor: HomeTheme.yellow.withValues(alpha: 0.4),
                activeThumbColor: HomeTheme.yellow,
              ),
            ],
          ),
          const SizedBox(height: 16),
          MissionYellowButton(
            label: '스레드에 공유하기',
            onPressed: isSubmitting ? null : onShare,
          ),
          const SizedBox(height: 8),
          MissionYellowButton(
            label: '홈으로 돌아가기',
            onPressed: isSubmitting ? null : onHome,
          ),
        ],
      ),
    );
  }
}
