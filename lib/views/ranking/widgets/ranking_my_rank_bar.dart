import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

class RankingMyRankBar extends StatelessWidget {
  const RankingMyRankBar({
    super.key,
    required this.summary,
    required this.mainTab,
    required this.onTap,
    this.onGrowthRecordTap,
  });

  final RankingMySummary summary;
  final RankingMainTab mainTab;
  final VoidCallback onTap;
  final VoidCallback? onGrowthRecordTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    mainTab == RankingMainTab.community ? '내 커뮤니티 순위' : '내 순위',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: RankingTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (summary.currentTierName != null && onGrowthRecordTap != null)
                    TextButton(
                      onPressed: onGrowthRecordTap,
                      style: TextButton.styleFrom(
                        foregroundColor: RankingTheme.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('성장 기록 ›', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${summary.rank}위',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary.nickname,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    summary.scoreLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: RankingTheme.primary,
                    ),
                  ),
                ],
              ),
              if (summary.tierProgressRatio != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: summary.tierProgressRatio,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: RankingTheme.primary,
                  ),
                ),
              ],
              if (summary.progressMessage != null) ...[
                const SizedBox(height: 6),
                Text(
                  summary.progressMessage!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
              if (mainTab == RankingMainTab.community && summary.activitySummaryLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  _communityActivityText(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _communityActivityText() {
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
    return parts.join(' · ');
  }
}
