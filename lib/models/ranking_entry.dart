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
    this.usePointsUnit = true,
  });

  final int rank;
  final String userId;
  final String nickname;
  final RankingBadge badge;
  final int score;
  final RankingRankChange rankChange;
  final bool isCurrentUser;

  /// true: Npt / false: N점 (커뮤니티)
  final bool usePointsUnit;

  String get scoreLabel =>
      usePointsUnit ? '${_format(score)}pt' : '${_format(score)}점';

  static String _format(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
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
    this.communityTitle,
    this.usePointsUnit = true,
  });

  final int rank;
  final String userId;
  final String nickname;
  final RankingBadge badge;
  final int score;
  final bool isFirst;
  final String? communityTitle;
  final bool usePointsUnit;

  String get scoreLabel =>
      usePointsUnit ? '${RankingEntry._format(score)}pt' : '${RankingEntry._format(score)}점';
}
