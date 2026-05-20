import 'package:picktory/models/ranking_badge.dart';
import 'package:picktory/models/ranking_rank_change.dart';

/// 하단 고정 "내 순위" 영역
class RankingMySummary {
  const RankingMySummary({
    required this.rank,
    required this.nickname,
    required this.badge,
    required this.score,
    required this.rankChange,
    this.topPercentTarget,
    this.stepsToTopPercent,
    this.accuracyPercent,
    this.postCount,
    this.commentCount,
    this.missionCount,
    this.activitySummaryLabel,
  });

  final int rank;
  final String nickname;
  final RankingBadge badge;
  final int score;
  final RankingRankChange rankChange;

  /// 시즌·전체: TOP N%까지 N계단
  final int? topPercentTarget;
  final int? stepsToTopPercent;

  /// 시즌·전체: 적중률
  final int? accuracyPercent;

  /// 커뮤니티: 글·댓글·미션 수
  final int? postCount;
  final int? commentCount;
  final int? missionCount;
  final String? activitySummaryLabel;

  RankingMySummary copyWith({
    int? rank,
    int? topPercentTarget,
    int? stepsToTopPercent,
    int? accuracyPercent,
  }) {
    return RankingMySummary(
      rank: rank ?? this.rank,
      nickname: nickname,
      badge: badge,
      score: score,
      rankChange: rankChange,
      topPercentTarget: topPercentTarget ?? this.topPercentTarget,
      stepsToTopPercent: stepsToTopPercent ?? this.stepsToTopPercent,
      accuracyPercent: accuracyPercent ?? this.accuracyPercent,
      postCount: postCount,
      commentCount: commentCount,
      missionCount: missionCount,
      activitySummaryLabel: activitySummaryLabel,
    );
  }
}
