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
    this.usePointsUnit = true,
    this.currentTierName,
    this.nextTierName,
    this.pointsToNextTier,
    this.tierProgressCurrent,
    this.tierProgressMax,
    this.topPercentile,
    this.seasonRemainingPoints,
    this.footerMessage,
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
  final bool usePointsUnit;

  final String? currentTierName;
  final String? nextTierName;
  final int? pointsToNextTier;
  final int? tierProgressCurrent;
  final int? tierProgressMax;
  final int? topPercentile;
  final int? seasonRemainingPoints;
  final String? footerMessage;
  final int? postCount;
  final int? commentCount;
  final int? missionCount;
  final String? activitySummaryLabel;

  String get scoreLabel => usePointsUnit ? '$score pt' : '$score점';

  String? get progressMessage {
    if (footerMessage != null) {
      return footerMessage;
    }
    if (nextTierName != null && pointsToNextTier != null) {
      return '$nextTierName까지 ${pointsToNextTier}pt 남음';
    }
    if (topPercentile != null && seasonRemainingPoints != null) {
      return '상위 $topPercentile% · 시즌 종료까지 ${seasonRemainingPoints}pt 남음';
    }
    return null;
  }

  double? get tierProgressRatio {
    if (tierProgressCurrent == null || tierProgressMax == null) {
      return null;
    }
    if (tierProgressMax == 0) {
      return 0;
    }
    return (tierProgressCurrent! / tierProgressMax!).clamp(0.0, 1.0);
  }
}
