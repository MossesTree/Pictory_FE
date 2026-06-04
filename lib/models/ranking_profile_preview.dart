import 'package:picktory/models/special_badge.dart';

/// IA R-2 유저 프로필 팝업
/// - 프로필 + 닉네임 + 뱃지 단계 + 현재 순위
/// - 시즌 포인트 / 전체 포인트 / 정답률
/// - 스페셜 뱃지 목록
class RankingProfilePreview {
  const RankingProfilePreview({
    required this.userId,
    required this.nickname,
    required this.tierLabel,
    required this.tierEmoji,
    required this.currentRank,
    required this.seasonPoints,
    required this.overallPoints,
    required this.accuracyPercent,
    required this.specialBadges,
    required this.isCurrentUser,
  });

  final String userId;
  final String nickname;

  /// 현재 성장 뱃지 단계 라벨 (예: "꼬마토리 2")
  final String tierLabel;
  final String tierEmoji;

  /// IA R-2: 현재 순위 (위)
  final int currentRank;

  /// IA R-2: 시즌 포인트
  final int seasonPoints;

  /// IA R-2: 전체 포인트
  final int overallPoints;

  /// IA R-2: 정답률 0~100
  final int accuracyPercent;

  /// IA R-2: 스페셜 뱃지 목록
  final List<SpecialBadge> specialBadges;

  final bool isCurrentUser;
}
