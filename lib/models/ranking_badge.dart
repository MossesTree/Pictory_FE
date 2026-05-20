/// 랭킹 등급 뱃지
enum RankingBadge {
  bronze('브론즈'),
  silver('실버'),
  gold('골드'),
  master('마스터'),
  legend('레전드');

  const RankingBadge(this.label);

  final String label;
}

/// 특수 뱃지 (보유 뱃지 목록용)
enum RankingSpecialBadge {
  legend('레전드'),
  accuracyKing('적중왕'),
  seasonComplete('시즌완주');

  const RankingSpecialBadge(this.label);

  final String label;
}
