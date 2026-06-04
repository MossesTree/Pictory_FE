import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/models/special_badge.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

/// IA R-2 유저 프로필 팝업
/// - 프로필 + 닉네임 + 뱃지 단계 + 현재 순위
/// - 시즌 포인트 / 전체 포인트 / 정답률
/// - 스페셜 뱃지 목록
/// - 딤 영역 탭 시 팝업 닫힘 (showModalBottomSheet 기본 동작)
Future<void> showRankingProfileSheet({
  required BuildContext context,
  required RankingProfilePreview profile,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (ctx) => _RankingProfileSheetBody(profile: profile),
  );
}

class _RankingProfileSheetBody extends StatelessWidget {
  const _RankingProfileSheetBody({required this.profile});

  final RankingProfilePreview profile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(PicktorySpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: PicktorySpacing.lg),
            _ProfileHeader(profile: profile),
            const SizedBox(height: PicktorySpacing.lg),
            _PointStatsRow(profile: profile),
            const SizedBox(height: PicktorySpacing.lg),
            _SpecialBadgeSection(badges: profile.specialBadges),
            const SizedBox(height: PicktorySpacing.lg),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PicktorySpacing.md,
                0,
                PicktorySpacing.md,
                PicktorySpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RankingTheme.textSecondary,
                    side: const BorderSide(color: RankingTheme.cardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('닫기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final RankingProfilePreview profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: RankingTheme.primaryLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text('👤', style: TextStyle(fontSize: 36)),
        ),
        const SizedBox(height: PicktorySpacing.sm),
        Text(
          profile.nickname,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(profile.tierEmoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              profile.tierLabel,
              style: const TextStyle(
                color: RankingTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              ' · ',
              style: TextStyle(color: RankingTheme.textSecondary),
            ),
            Text(
              '현재 ${profile.currentRank}위',
              style: const TextStyle(
                color: RankingTheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PointStatsRow extends StatelessWidget {
  const _PointStatsRow({required this.profile});

  final RankingProfilePreview profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              value: _format(profile.seasonPoints),
              label: '시즌 포인트',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatBox(
              value: _format(profile.overallPoints),
              label: '전체 포인트',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatBox(
              value: '${profile.accuracyPercent}%',
              label: '정답률',
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

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: RankingTheme.cardBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: RankingTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// IA R-2: 스페셜 뱃지 목록
class _SpecialBadgeSection extends StatelessWidget {
  const _SpecialBadgeSection({required this.badges});

  final List<SpecialBadge> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }
    final earned = badges.where((b) => b.isEarned).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '스페셜 뱃지',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${earned.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: RankingTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges.map((b) => _BadgeChip(badge: b)).toList(),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});

  final SpecialBadge badge;

  @override
  Widget build(BuildContext context) {
    final earned = badge.isEarned;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: earned ? RankingTheme.primaryLight : RankingTheme.cardBorder,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            badge.iconEmoji,
            style: TextStyle(
              fontSize: 14,
              color: earned ? null : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            badge.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: earned
                  ? RankingTheme.textPrimary
                  : RankingTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
