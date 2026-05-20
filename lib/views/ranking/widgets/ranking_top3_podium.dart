import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

class RankingTop3Podium extends StatelessWidget {
  const RankingTop3Podium({
    super.key,
    required this.entries,
    required this.useCommunityTitles,
    required this.onUserTap,
  });

  final List<RankingPodiumEntry> entries;
  final bool useCommunityTitles;
  final ValueChanged<String> onUserTap;

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) {
      return const SizedBox.shrink();
    }

    final second = entries.firstWhere((e) => e.rank == 2);
    final first = entries.firstWhere((e) => e.rank == 1);
    final third = entries.firstWhere((e) => e.rank == 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _PodiumCard(entry: second, height: 88, onUserTap: onUserTap, useCommunityTitles: useCommunityTitles)),
          const SizedBox(width: 8),
          Expanded(child: _PodiumCard(entry: first, height: 110, onUserTap: onUserTap, emphasize: true, useCommunityTitles: useCommunityTitles)),
          const SizedBox(width: 8),
          Expanded(child: _PodiumCard(entry: third, height: 80, onUserTap: onUserTap, useCommunityTitles: useCommunityTitles)),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.entry,
    required this.height,
    required this.onUserTap,
    required this.useCommunityTitles,
    this.emphasize = false,
  });

  final RankingPodiumEntry entry;
  final double height;
  final ValueChanged<String> onUserTap;
  final bool useCommunityTitles;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onUserTap(entry.userId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: emphasize ? RankingTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: emphasize ? RankingTheme.primary : Colors.grey.shade300,
            width: emphasize ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: emphasize ? 52 : 44,
              height: emphasize ? 52 : 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
                border: emphasize
                    ? Border.all(color: RankingTheme.podiumGold, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text('👤', style: TextStyle(fontSize: emphasize ? 24 : 20)),
            ),
            SizedBox(height: height * 0.15),
            Text(
              '${entry.rank}위',
              style: TextStyle(
                fontSize: 11,
                color: RankingTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            if (useCommunityTitles && entry.communityTitle != null)
              Text(
                entry.communityTitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: emphasize ? 13 : 11,
                  fontWeight: FontWeight.bold,
                  color: RankingTheme.primary,
                ),
              ),
            Text(
              entry.nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: emphasize ? 13 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.scoreLabel,
              style: TextStyle(
                fontSize: emphasize ? 14 : 12,
                fontWeight: FontWeight.bold,
                color: RankingTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
