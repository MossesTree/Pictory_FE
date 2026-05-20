import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/views/ranking/widgets/ranking_badge_chip.dart';

Future<void> showRankingProfileSheet({
  required BuildContext context,
  required RankingProfilePreview profile,
  VoidCallback? onEditProfile,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => _RankingProfileSheetBody(
        profile: profile,
        scrollController: scrollController,
        onEditProfile: onEditProfile,
      ),
    ),
  );
}

class _RankingProfileSheetBody extends StatelessWidget {
  const _RankingProfileSheetBody({
    required this.profile,
    required this.scrollController,
    this.onEditProfile,
  });

  final RankingProfilePreview profile;
  final ScrollController scrollController;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                const Text(
                  '유저 프로필 미리보기',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text('👤', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 12),
                      Text(
                        '👑 ${profile.highestBadge.label}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.seasonRankLabel} · ${profile.overallRankLabel}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                RankingBadgeChip(badge: profile.highestBadge),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        value: '${profile.accuracyPercent}%',
                        label: '적중률',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatBox(
                        value: '${profile.participatedMissionCount}',
                        label: '참여 미션',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatBox(
                        value: _formatScore(profile.seasonScore),
                        label: '시즌점수',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  '이번 시즌 성적',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _DetailRow(label: '시즌 순위', value: profile.seasonRankDetail),
                _DetailRow(label: '연속 적중', value: profile.streakLabel),
                _DetailRow(label: '순위 변동', value: profile.rankChangeLabel),
                _DetailRow(
                  label: '가장 잘 맞힌 프로그램',
                  value: profile.bestProgramLabel,
                ),
                _DetailRow(
                  label: '획득 포인트 (시즌)',
                  value: profile.earnedPointsLabel,
                ),
                const SizedBox(height: 24),
                const Text(
                  '보유 뱃지',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...profile.ownedBadges.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _SpecialBadgeChip(label: b.label, locked: false),
                        ),
                      ),
                      ...profile.lockedBadges.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _SpecialBadgeChip(label: b.label, locked: true),
                        ),
                      ),
                    ],
                  ),
                ),
                if (profile.isCurrentUser && onEditProfile != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onEditProfile!();
                      },
                      child: const Text('내 프로필 수정'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    return score.toString().replaceAllMapped(
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SpecialBadgeChip extends StatelessWidget {
  const _SpecialBadgeChip({required this.label, required this.locked});

  final String label;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: locked ? Colors.grey.shade200 : Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: locked ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
