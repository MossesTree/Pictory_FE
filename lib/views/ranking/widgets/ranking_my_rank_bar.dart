import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/views/ranking/widgets/ranking_badge_chip.dart';
import 'package:picktory/views/ranking/widgets/ranking_rank_change_label.dart';

class RankingMyRankBar extends StatelessWidget {
  const RankingMyRankBar({
    super.key,
    required this.summary,
    required this.mainTab,
    required this.onTap,
  });

  final RankingMySummary summary;
  final RankingMainTab mainTab;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '내 순위',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${summary.rank}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Text('👤', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        RankingBadgeChip(badge: summary.badge),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatScore(summary.score)}점',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  RankingRankChangeLabel(change: summary.rankChange),
                ],
              ),
              const SizedBox(height: 8),
              _buildSubInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubInfo() {
    if (mainTab == RankingMainTab.community) {
      final parts = <String>[];
      if (summary.postCount != null) {
        parts.add('글 ${summary.postCount}');
      }
      if (summary.commentCount != null) {
        parts.add('댓글 ${summary.commentCount}');
      }
      if (summary.missionCount != null) {
        parts.add('미션 ${summary.missionCount}');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.activitySummaryLabel != null)
            Text(
              summary.activitySummaryLabel!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          if (parts.isNotEmpty)
            Text(
              parts.join(' · '),
              style: const TextStyle(fontSize: 12),
            ),
        ],
      );
    }

    final lines = <Widget>[];
    if (summary.topPercentTarget != null && summary.stepsToTopPercent != null) {
      lines.add(Text(
        'TOP${summary.topPercentTarget}%까지 ${summary.stepsToTopPercent}계단',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ));
    }
    if (summary.accuracyPercent != null) {
      lines.add(Text(
        '적중률 ${summary.accuracyPercent}%',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines,
    );
  }

  String _formatScore(int score) {
    return score.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
