import 'package:picktory/models/ranking_badge.dart';

/// R-2 유저 프로필 미리보기
class RankingProfilePreview {
  const RankingProfilePreview({
    required this.userId,
    required this.nickname,
    required this.highestBadge,
    required this.seasonRankLabel,
    required this.overallRankLabel,
    required this.accuracyPercent,
    required this.participatedMissionCount,
    required this.seasonScore,
    required this.seasonRankDetail,
    required this.streakLabel,
    required this.rankChangeLabel,
    required this.bestProgramLabel,
    required this.earnedPointsLabel,
    required this.ownedBadges,
    required this.lockedBadges,
    required this.isCurrentUser,
  });

  final String userId;
  final String nickname;
  final RankingBadge highestBadge;
  final String seasonRankLabel;
  final String overallRankLabel;
  final int accuracyPercent;
  final int participatedMissionCount;
  final int seasonScore;
  final String seasonRankDetail;
  final String streakLabel;
  final String rankChangeLabel;
  final String bestProgramLabel;
  final String earnedPointsLabel;
  final List<RankingSpecialBadge> ownedBadges;
  final List<RankingSpecialBadge> lockedBadges;
  final bool isCurrentUser;
}
