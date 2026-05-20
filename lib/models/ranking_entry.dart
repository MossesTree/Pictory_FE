import 'package:picktory/models/ranking_badge.dart';
import 'package:picktory/models/ranking_rank_change.dart';

/// 랭킹 리스트 항목 (4위~)
class RankingEntry {
  const RankingEntry({
    required this.rank,
    required this.userId,
    required this.nickname,
    required this.badge,
    required this.score,
    required this.rankChange,
    this.isCurrentUser = false,
  });

  final int rank;
  final String userId;
  final String nickname;
  final RankingBadge badge;
  final int score;
  final RankingRankChange rankChange;
  final bool isCurrentUser;
}

/// TOP 3 포디움 항목
class RankingPodiumEntry {
  const RankingPodiumEntry({
    required this.rank,
    required this.userId,
    required this.nickname,
    required this.badge,
    required this.score,
    this.isFirst = false,
  });

  final int rank;
  final String userId;
  final String nickname;
  final RankingBadge badge;
  final int score;
  final bool isFirst;
}
