import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/views/ranking/widgets/ranking_badge_chip.dart';

class RankingTop3Podium extends StatelessWidget {
  const RankingTop3Podium({
    super.key,
    required this.entries,
    required this.scoreLabel,
    required this.onUserTap,
  });

  final List<RankingPodiumEntry> entries;
  final String scoreLabel;
  final ValueChanged<String> onUserTap;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) {
      return const SizedBox.shrink();
    }

    final second = entries.firstWhere((e) => e.rank == 2, orElse: () => entries[0]);
    final first = entries.firstWhere((e) => e.rank == 1, orElse: () => entries[1]);
    final third = entries.firstWhere((e) => e.rank == 3, orElse: () => entries[2]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOP 3',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _PodiumCard(
                  entry: second,
                  height: 100,
                  scoreLabel: scoreLabel,
                  onTap: () => onUserTap(second.userId),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PodiumCard(
                  entry: first,
                  height: 130,
                  scoreLabel: scoreLabel,
                  onTap: () => onUserTap(first.userId),
                  emphasize: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PodiumCard(
                  entry: third,
                  height: 90,
                  scoreLabel: scoreLabel,
                  onTap: () => onUserTap(third.userId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.entry,
    required this.height,
    required this.scoreLabel,
    required this.onTap,
    this.emphasize = false,
  });

  final RankingPodiumEntry entry;
  final double height;
  final String scoreLabel;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height + 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: emphasize ? Colors.black : Colors.grey.shade300,
            width: emphasize ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: emphasize ? Colors.grey.shade50 : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('👤', style: TextStyle(fontSize: emphasize ? 28 : 22)),
            const SizedBox(height: 4),
            Text(
              '${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: emphasize ? 18 : 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.isFirst ? '👑 ${entry.nickname}' : entry.nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: emphasize ? 13 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            RankingBadgeChip(badge: entry.badge),
            const SizedBox(height: 4),
            Text(
              '${_formatScore(entry.score)}점',
              style: TextStyle(
                fontSize: emphasize ? 13 : 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
