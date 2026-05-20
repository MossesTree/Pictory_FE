import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/views/ranking/widgets/ranking_badge_chip.dart';
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '${entry.rank}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Text('👤', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.nickname,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  RankingBadgeChip(badge: entry.badge),
                ],
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '${_formatScore(entry.score)}점',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 36,
              child: Align(
                alignment: Alignment.centerRight,
                child: RankingRankChangeLabel(change: entry.rankChange),
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
