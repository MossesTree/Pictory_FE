/// 순위 변동
sealed class RankingRankChange {
  const RankingRankChange();
}

class RankingRankChangeUp extends RankingRankChange {
  const RankingRankChangeUp(this.steps);

  final int steps;
}

class RankingRankChangeDown extends RankingRankChange {
  const RankingRankChangeDown(this.steps);

  final int steps;
}

class RankingRankChangeNone extends RankingRankChange {
  const RankingRankChangeNone();
}
