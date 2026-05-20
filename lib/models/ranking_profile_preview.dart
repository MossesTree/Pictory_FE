/// 유저 프로필 미리보기 (랭킹 탭)
class RankingProfilePreview {
  const RankingProfilePreview({
    required this.userId,
    required this.nickname,
    required this.subtitle,
    required this.knowledgePoints,
    required this.activityPoints,
    required this.accuracyPercent,
    required this.isCurrentUser,
  });

  final String userId;
  final String nickname;
  final String subtitle;
  final int knowledgePoints;
  final int activityPoints;
  final int accuracyPercent;
  final bool isCurrentUser;
}
