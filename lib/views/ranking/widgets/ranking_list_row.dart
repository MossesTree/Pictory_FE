import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';
import 'package:picktory/views/ranking/widgets/ranking_rank_change_label.dart';

class RankingListRow extends StatelessWidget {
  const RankingListRow({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final RankingEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${entry.rank}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('👤', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.nickname,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              entry.scoreLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: RankingTheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 28,
              child: RankingRankChangeLabel(change: entry.rankChange),
            ),
          ],
        ),
      ),
    );
  }
}
