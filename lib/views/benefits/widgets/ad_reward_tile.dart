import 'package:flutter/material.dart';
import 'package:picktory/models/ad_reward_status.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';

class AdRewardTile extends StatelessWidget {
  const AdRewardTile({
    super.key,
    required this.status,
    required this.onWatch,
  });

  final AdRewardStatus status;
  final VoidCallback onWatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: BenefitTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('📺', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '광고 시청',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: BenefitTheme.textPrimary,
                  ),
                ),
                Text(
                  status.canWatch
                      ? '오늘 ${status.watchesRemainingToday}회 남음 · +${status.rewardPicks} Pick'
                      : '오늘 시청 횟수를 모두 사용했어요',
                  style: const TextStyle(
                    fontSize: 12,
                    color: BenefitTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: status.canWatch ? onWatch : null,
            style: FilledButton.styleFrom(
              backgroundColor: BenefitTheme.primary,
              disabledBackgroundColor: BenefitTheme.disabledButton,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '시청하기',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
